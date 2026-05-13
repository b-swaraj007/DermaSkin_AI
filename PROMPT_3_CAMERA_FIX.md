# Qoder Prompt — Fix Live Camera Feed + MediaPipe Overlay (Phase 3)

> **The AR screen is built but has 2 critical bugs:**
> 1. Camera feed freezes after first frame — not live
> 2. Face is not being detected — "Position your face in frame" never goes away
>
> Fix both issues completely. Do NOT rewrite the whole screen. Surgically fix only what is broken.

---

## Bug 1 — Camera Freezes (Most Critical)

### Root Cause
`CameraPreview` widget and `startImageStream` are conflicting. When `startImageStream` is active and frames are being processed with `await` inside the callback, it blocks the camera pipeline and the preview freezes.

### Fix in `ar_camera_screen.dart`

**Find `_onCameraFrame` method and replace it entirely:**

```dart
void _onCameraFrame(CameraImage image) {
  // DO NOT use async/await here — this runs on camera thread
  // Use a flag to skip frames, never block
  if (_isProcessing) return;
  _isProcessing = true;

  // Fire and forget — do NOT await
  _processFrameInBackground(image).whenComplete(() {
    _isProcessing = false;
  });
}

Future<void> _processFrameInBackground(CameraImage image) async {
  try {
    final bytes = await _convertCameraImageToJpeg(image);
    if (bytes == null) return;
    await MediaPipeChannel.processFrame(bytes, isFrontCamera: true);
  } catch (_) {
    // Silently ignore frame errors — next frame will retry
  }
}
```

**Add this JPEG conversion method to the State class:**

```dart
Future<Uint8List?> _convertCameraImageToJpeg(CameraImage image) async {
  try {
    // Handle both YUV420 (Android) and BGRA8888 (iOS)
    if (image.format.group == ImageFormatGroup.yuv420) {
      return _convertYUV420ToJpeg(image);
    } else if (image.format.group == ImageFormatGroup.bgra8888) {
      return _convertBGRA8888ToJpeg(image);
    } else if (image.format.group == ImageFormatGroup.jpeg) {
      // Already JPEG (some Android devices)
      return image.planes[0].bytes;
    }
    return null;
  } catch (_) {
    return null;
  }
}

Uint8List? _convertYUV420ToJpeg(CameraImage image) {
  try {
    final img.Image convertedImage = img.Image(
      width: image.width,
      height: image.height,
    );

    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final yBytes = yPlane.bytes;
    final uBytes = uPlane.bytes;
    final vBytes = vPlane.bytes;

    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixelStride = uPlane.bytesPerPixel ?? 1;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final int yIndex = y * yPlane.bytesPerRow + x;
        final int uvIndex = (y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride;

        if (yIndex >= yBytes.length || uvIndex >= uBytes.length || uvIndex >= vBytes.length) continue;

        final int yVal = yBytes[yIndex];
        final int uVal = uBytes[uvIndex] - 128;
        final int vVal = vBytes[uvIndex] - 128;

        final int r = (yVal + 1.370705 * vVal).round().clamp(0, 255);
        final int g = (yVal - 0.337633 * uVal - 0.698001 * vVal).round().clamp(0, 255);
        final int b = (yVal + 1.732446 * uVal).round().clamp(0, 255);

        convertedImage.setPixelRgb(x, y, r, g, b);
      }
    }

    return Uint8List.fromList(img.encodeJpg(convertedImage, quality: 80));
  } catch (_) {
    return null;
  }
}

Uint8List? _convertBGRA8888ToJpeg(CameraImage image) {
  try {
    final img.Image convertedImage = img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      order: img.ChannelOrder.bgra,
    );
    return Uint8List.fromList(img.encodeJpg(convertedImage, quality: 80));
  } catch (_) {
    return null;
  }
}
```

**Add this import at the top of `ar_camera_screen.dart` if not already present:**

```dart
import 'package:image/image.dart' as img;
```

---

## Bug 2 — CameraPreview Conflicts With Image Stream

### Root Cause
On many Android devices, `CameraPreview` internally uses a `SurfaceTexture`. When `startImageStream` is also active, they compete for the camera output. The preview shows the first frame then stalls.

### Fix — Replace `CameraPreview` with a Texture-based approach

**In `_initCamera()`, change the resolution and add the stream AFTER a short delay:**

```dart
Future<void> _initCamera() async {
  final status = await Permission.camera.request();
  if (!status.isGranted) return;

  final cameras = await availableCameras();
  final frontCam = cameras.firstWhere(
    (c) => c.lensDirection == CameraLensDirection.front,
    orElse: () => cameras.first,
  );

  _cameraController = CameraController(
    frontCam,
    ResolutionPreset.medium,   // CHANGED: high → medium (reduces processing load)
    enableAudio: false,
    imageFormatGroup: ImageFormatGroup.yuv420,  // CHANGED: jpeg → yuv420 (more compatible)
  );

  await _cameraController!.initialize();
  if (!mounted) return;
  setState(() {});

  // CRITICAL: small delay before starting image stream
  // prevents SurfaceTexture conflict on Android
  await Future.delayed(const Duration(milliseconds: 300));
  
  if (_cameraController!.value.isInitialized) {
    await _cameraController!.startImageStream(_onCameraFrame);
  }
}
```

---

## Bug 3 — Overlay CustomPaint Not Updating Live

### Root Cause
`CustomPaint` is inside a `LayoutBuilder` but `setState` from the landmark stream may not be triggering a repaint if the widget tree hasn't changed structurally.

### Fix — Wrap overlay in `RepaintBoundary` and use `ValueNotifier`

**Add a ValueNotifier at the top of the State class:**

```dart
final _landmarkNotifier = ValueNotifier<List<FaceLandmark>>([]);
```

**Change the stream listener in `_initMediaPipe()` to use the notifier:**

```dart
_meshSub = MediaPipeChannel.landmarkStream.listen((result) {
  _landmarkNotifier.value = result.detected ? result.landmarks : [];
  // Also update _landmarks for the "no face" message check
  if (mounted) setState(() => _landmarks = _landmarkNotifier.value);
});
```

**Replace `_buildOverlay()` with this ValueListenableBuilder version:**

```dart
Widget _buildOverlay() {
  return ValueListenableBuilder<List<FaceLandmark>>(
    valueListenable: _landmarkNotifier,
    builder: (context, landmarks, _) {
      if (landmarks.isEmpty) return const SizedBox.shrink();

      return LayoutBuilder(builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        if (_mode == ARMode.skinZones) {
          return AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (_, __) => RepaintBoundary(
              child: CustomPaint(
                size: size,
                painter: SkinZoneOverlayPainter(
                  landmarks: landmarks,
                  imageSize: size,
                  issues: widget.detectedIssues,
                  pulseValue: _pulseAnimation.value,
                ),
              ),
            ),
          );
        } else {
          return AnimatedBuilder(
            animation: _treatmentController.animation,
            builder: (_, __) => RepaintBoundary(
              child: CustomPaint(
                size: size,
                painter: TreatmentOverlayPainter(
                  landmarks: landmarks,
                  imageSize: size,
                  progress: _treatmentController.transformProgress,
                  config: widget.treatmentConfig,
                ),
              ),
            ),
          );
        }
      });
    },
  );
}
```

**Also dispose the notifier in `dispose()`:**

```dart
@override
void dispose() {
  _landmarkNotifier.dispose();
  _meshSub?.cancel();
  _cameraController?.dispose();
  _pulseController.dispose();
  _treatmentController.dispose();
  MediaPipeChannel.dispose();
  super.dispose();
}
```

---

## Bug 4 — Stack Order Wrong (Overlay Behind Camera)

### Root Cause
`CameraPreview` fills the full Stack but `CustomPaint` needs explicit `size` or it renders at zero size.

### Fix — Ensure correct Stack structure in `build()`

Replace the entire `build()` method's `Stack` children with:

```dart
body: Stack(
  fit: StackFit.expand,
  children: [
    // Layer 1: Live camera feed
    if (_cameraController?.value.isInitialized == true)
      CameraPreview(_cameraController!),

    // Layer 2: AR overlay — fills same space as camera
    Positioned.fill(
      child: _buildOverlay(),
    ),

    // Layer 3: No face message — only show if camera is ready but no face
    if (_cameraController?.value.isInitialized == true && _landmarks.isEmpty)
      Center(child: _buildNoFaceMessage()),

    // Layer 4: Mode controls at bottom
    _buildControls(),

    // Layer 5: Treatment UI at top
    if (_mode == ARMode.treatmentPreview) _buildTreatmentUI(),
  ],
),
```

---

## Bug 5 — Frame Rate Too High Causing Processing Backup

### Root Cause
Camera stream fires at 30–60fps. MediaPipe can't keep up. Frame queue backs up, causing lag and eventual freeze.

### Fix — Add frame throttling using timestamps

**Add this field to State class:**

```dart
int _lastFrameTime = 0;
static const int _frameIntervalMs = 66; // ~15fps for processing (plenty for AR overlay)
```

**Update `_onCameraFrame` to throttle:**

```dart
void _onCameraFrame(CameraImage image) {
  final now = DateTime.now().millisecondsSinceEpoch;
  
  // Skip frames to maintain ~15fps processing rate
  if (now - _lastFrameTime < _frameIntervalMs) return;
  if (_isProcessing) return;
  
  _lastFrameTime = now;
  _isProcessing = true;

  _processFrameInBackground(image).whenComplete(() {
    _isProcessing = false;
  });
}
```

---

## Final Checklist for Qoder

After making all changes above:

1. Make sure `import 'package:image/image.dart' as img;` is at top of `ar_camera_screen.dart`
2. Make sure `import 'dart:typed_data';` is present
3. Hot restart the app (not hot reload — camera needs full restart)
4. Test on physical device only
5. If face still not detected after 5 seconds, add this debug log temporarily inside `_initMediaPipe()`:

```dart
_meshSub = MediaPipeChannel.landmarkStream.listen((result) {
  debugPrint('MediaPipe result: detected=${result.detected}, points=${result.landmarks.length}');
  _landmarkNotifier.value = result.detected ? result.landmarks : [];
  if (mounted) setState(() => _landmarks = _landmarkNotifier.value);
});
```

Check the debug console — if you see `detected=false` repeatedly, the issue is in the native bridge (model not loading). If you see no output at all, the EventChannel is not connected properly.

6. Report back what the debug log shows and we fix from there.
