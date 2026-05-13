# Qoder Prompt — MediaPipe AR Full Implementation (Phase 2)

> **Use this prompt ONLY after PROMPT_1_SETUP.md tasks are fully complete and build is verified.**  
> Copy and paste this entire prompt into Qoder IDE chat.

---

## Context

Flutter skin analysis app. Setup is complete. MediaPipe dependencies and empty files are in place.  
Now implement two AR camera features using MediaPipe Face Landmarker via Flutter Method Channels:

1. **Feature 1 — Skin Problem Zone AR Overlay:** Real-time camera feed with colored heatmap zones overlaid on the user's face showing detected skin issues.
2. **Feature 2 — After Treatment Preview:** Camera feed where user sees a gradual animated transformation of how their skin will look after correct treatment.

**Constraints:**
- 30–60 FPS target
- All overlays via Flutter `CustomPainter` on top of camera feed
- MediaPipe Face Landmarker gives 478 landmark points (468 face + 10 iris)
- Method Channel name: `com.skinapp/mediapipe`
- No Unity, no ARKit/ARCore plugins

---

## File 1 — `FaceLandmarkerHelper.kt`

Full path: `android/app/src/main/kotlin/<package>/FaceLandmarkerHelper.kt`

```kotlin
package <YOUR_PACKAGE_NAME>

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Matrix
import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarker
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarkerResult

class FaceLandmarkerHelper(
    private val context: Context,
    private val onResult: (FaceLandmarkerResult, Int, Int) -> Unit,
    private val onError: (String) -> Unit
) {
    private var faceLandmarker: FaceLandmarker? = null

    fun setup() {
        try {
            val baseOptions = BaseOptions.builder()
                .setModelAssetPath("face_landmarker.task")
                .build()

            val options = FaceLandmarker.FaceLandmarkerOptions.builder()
                .setBaseOptions(baseOptions)
                .setRunningMode(RunningMode.LIVE_STREAM)
                .setNumFaces(1)
                .setMinFaceDetectionConfidence(0.5f)
                .setMinFacePresenceConfidence(0.5f)
                .setMinTrackingConfidence(0.5f)
                .setOutputFaceBlendshapes(false)
                .setOutputFacialTransformationMatrixes(false)
                .setResultListener { result, input ->
                    onResult(result, input.width, input.height)
                }
                .setErrorListener { error ->
                    onError(error.message ?: "Unknown error")
                }
                .build()

            faceLandmarker = FaceLandmarker.createFromOptions(context, options)
        } catch (e: Exception) {
            onError("FaceLandmarker setup failed: ${e.message}")
        }
    }

    fun detectAsync(bitmap: Bitmap, frameTime: Long, isFrontCamera: Boolean) {
        val matrix = Matrix()
        if (isFrontCamera) matrix.postScale(-1f, 1f, bitmap.width / 2f, bitmap.height / 2f)
        val processedBitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
        val mpImage = BitmapImageBuilder(processedBitmap).build()
        faceLandmarker?.detectAsync(mpImage, frameTime)
    }

    fun close() {
        faceLandmarker?.close()
        faceLandmarker = null
    }
}
```

---

## File 2 — `MediaPipePlugin.kt`

Full path: `android/app/src/main/kotlin/<package>/MediaPipePlugin.kt`

```kotlin
package <YOUR_PACKAGE_NAME>

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarkerResult
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MediaPipePlugin(private val context: Context) :
    MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private var faceLandmarkerHelper: FaceLandmarkerHelper? = null
    private var eventSink: EventChannel.EventSink? = null
    private var frameTimestamp = 0L

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                setupLandmarker()
                result.success(true)
            }
            "processFrame" -> {
                val bytes = call.argument<ByteArray>("bytes") ?: return result.error("NO_DATA", "No frame bytes", null)
                val isFront = call.argument<Boolean>("isFrontCamera") ?: true
                val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                frameTimestamp += 33
                faceLandmarkerHelper?.detectAsync(bitmap, frameTimestamp, isFront)
                result.success(null)
            }
            "dispose" -> {
                faceLandmarkerHelper?.close()
                faceLandmarkerHelper = null
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun setupLandmarker() {
        faceLandmarkerHelper = FaceLandmarkerHelper(
            context = context,
            onResult = { landmarkerResult, width, height ->
                sendLandmarksToFlutter(landmarkerResult, width, height)
            },
            onError = { error ->
                eventSink?.error("MEDIAPIPE_ERROR", error, null)
            }
        )
        faceLandmarkerHelper?.setup()
    }

    private fun sendLandmarksToFlutter(result: FaceLandmarkerResult, width: Int, height: Int) {
        if (result.faceLandmarks().isEmpty()) {
            eventSink?.success(mapOf("detected" to false))
            return
        }

        val landmarks = result.faceLandmarks()[0].map { lm ->
            mapOf("x" to lm.x().toDouble(), "y" to lm.y().toDouble(), "z" to lm.z().toDouble())
        }

        eventSink?.success(mapOf(
            "detected" to true,
            "landmarks" to landmarks,
            "imageWidth" to width,
            "imageHeight" to height
        ))
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
```

---

## File 3 — Modify `MainActivity.kt`

Register both the MethodChannel and EventChannel inside `configureFlutterEngine`:

```kotlin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "com.skinapp/mediapipe"
    private val EVENT_CHANNEL = "com.skinapp/mediapipe_events"
    private lateinit var plugin: MediaPipePlugin

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        plugin = MediaPipePlugin(applicationContext)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler(plugin)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(plugin)
    }
}
```

---

## File 4 — `FaceLandmarkerHelper.swift`

Full path: `ios/Runner/FaceLandmarkerHelper.swift`

```swift
import Foundation
import MediaPipeTasksVision
import UIKit

typealias LandmarkResult = ([[String: Double]], Int, Int)

class FaceLandmarkerHelper: NSObject {
    private var faceLandmarker: FaceLandmarker?
    var onResult: ((LandmarkResult) -> Void)?
    var onError: ((String) -> Void)?

    func setup() {
        guard let modelPath = Bundle.main.path(forResource: "face_landmarker", ofType: "task") else {
            onError?("Model file not found in bundle")
            return
        }
        do {
            let options = FaceLandmarkerOptions()
            options.baseOptions.modelAssetPath = modelPath
            options.runningMode = .liveStream
            options.numFaces = 1
            options.minFaceDetectionConfidence = 0.5
            options.minFacePresenceConfidence = 0.5
            options.minTrackingConfidence = 0.5
            options.faceLandmarkerLiveStreamDelegate = self
            faceLandmarker = try FaceLandmarker(options: options)
        } catch {
            onError?("FaceLandmarker init failed: \(error.localizedDescription)")
        }
    }

    func detectAsync(imageData: Data, timestamp: Int, isFrontCamera: Bool) {
        guard let uiImage = UIImage(data: imageData),
              let cgImage = uiImage.cgImage else { return }

        var image: MPImage
        do {
            image = try MPImage(uiImage: UIImage(cgImage: cgImage))
        } catch { return }

        try? faceLandmarker?.detectAsync(image: image, timestampInMilliseconds: timestamp)
    }

    func close() {
        faceLandmarker = nil
    }
}

extension FaceLandmarkerHelper: FaceLandmarkerLiveStreamDelegate {
    func faceLandmarker(_ faceLandmarker: FaceLandmarker,
                        didFinishDetection result: FaceLandmarkerResult?,
                        timestampInMilliseconds: Int,
                        error: Error?) {
        if let error = error {
            onError?(error.localizedDescription)
            return
        }
        guard let result = result,
              let landmarks = result.faceLandmarks.first else {
            onResult?(([], 0, 0))
            return
        }
        let mapped = landmarks.map { lm in
            ["x": Double(lm.x), "y": Double(lm.y), "z": Double(lm.z)]
        }
        onResult?((mapped, 0, 0))
    }
}
```

---

## File 5 — `MediaPipePlugin.swift`

Full path: `ios/Runner/MediaPipePlugin.swift`

```swift
import Flutter
import UIKit

class MediaPipePlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var helper = FaceLandmarkerHelper()
    private var frameTimestamp = 0

    static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "com.skinapp/mediapipe",
            binaryMessenger: registrar.messenger()
        )
        let eventChannel = FlutterEventChannel(
            name: "com.skinapp/mediapipe_events",
            binaryMessenger: registrar.messenger()
        )
        let instance = MediaPipePlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            helper.onResult = { [weak self] (landmarks, w, h) in
                DispatchQueue.main.async {
                    if landmarks.isEmpty {
                        self?.eventSink?(["detected": false])
                    } else {
                        self?.eventSink?([
                            "detected": true,
                            "landmarks": landmarks,
                            "imageWidth": w,
                            "imageHeight": h
                        ])
                    }
                }
            }
            helper.onError = { [weak self] error in
                self?.eventSink?(FlutterError(code: "MEDIAPIPE_ERROR", message: error, details: nil))
            }
            helper.setup()
            result(true)

        case "processFrame":
            guard let args = call.arguments as? [String: Any],
                  let bytes = args["bytes"] as? FlutterStandardTypedData,
                  let isFront = args["isFrontCamera"] as? Bool else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing args", details: nil))
                return
            }
            frameTimestamp += 33
            helper.detectAsync(imageData: bytes.data, timestamp: frameTimestamp, isFrontCamera: isFront)
            result(nil)

        case "dispose":
            helper.close()
            result(true)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
```

---

## File 6 — Modify `AppDelegate.swift`

Register the plugin inside `application(_:didFinishLaunchingWithOptions:)`:

```swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        if let registrar = self.registrar(forPlugin: "MediaPipePlugin") {
            MediaPipePlugin.register(with: registrar)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

---

## File 7 — `lib/ar_features/mediapipe_channel.dart`

This is the Flutter-side bridge to native:

```dart
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class FaceLandmark {
  final double x, y, z;
  const FaceLandmark({required this.x, required this.y, required this.z});

  factory FaceLandmark.fromMap(Map map) => FaceLandmark(
        x: (map['x'] as num).toDouble(),
        y: (map['y'] as num).toDouble(),
        z: (map['z'] as num).toDouble(),
      );
}

class FaceMeshResult {
  final bool detected;
  final List<FaceLandmark> landmarks;
  const FaceMeshResult({required this.detected, required this.landmarks});
}

class MediaPipeChannel {
  static const _method = MethodChannel('com.skinapp/mediapipe');
  static const _events = EventChannel('com.skinapp/mediapipe_events');

  static Stream<FaceMeshResult>? _stream;

  static Future<void> initialize() async {
    await _method.invokeMethod('initialize');
  }

  static Future<void> processFrame(Uint8List jpegBytes, {bool isFrontCamera = true}) async {
    await _method.invokeMethod('processFrame', {
      'bytes': jpegBytes,
      'isFrontCamera': isFrontCamera,
    });
  }

  static Stream<FaceMeshResult> get landmarkStream {
    _stream ??= _events.receiveBroadcastStream().map((event) {
      final map = Map<String, dynamic>.from(event);
      final detected = map['detected'] as bool? ?? false;
      if (!detected) return const FaceMeshResult(detected: false, landmarks: []);

      final rawList = map['landmarks'] as List;
      final landmarks = rawList
          .map((e) => FaceLandmark.fromMap(Map.from(e)))
          .toList();
      return FaceMeshResult(detected: true, landmarks: landmarks);
    });
    return _stream!;
  }

  static Future<void> dispose() async {
    await _method.invokeMethod('dispose');
    _stream = null;
  }
}
```

---

## File 8 — `lib/ar_features/face_mesh_painter.dart`

Base painter — maps landmark index to screen coordinates:

```dart
import 'package:flutter/material.dart';
import 'mediapipe_channel.dart';

// MediaPipe 478-point face zone index groups
class FaceZones {
  static const List<int> forehead = [10, 67, 69, 104, 108, 151, 337, 338, 297, 299, 333];
  static const List<int> leftCheek = [116, 117, 118, 119, 120, 121, 126, 142, 203, 206, 207];
  static const List<int> rightCheek = [345, 346, 347, 348, 349, 350, 355, 371, 423, 426, 427];
  static const List<int> nose = [1, 2, 4, 5, 6, 19, 20, 94, 125, 141, 235, 44];
  static const List<int> chin = [152, 175, 176, 148, 149, 150, 169, 170, 140, 171];
  static const List<int> leftUnderEye = [33, 7, 163, 144, 145, 153, 154, 155, 133];
  static const List<int> rightUnderEye = [362, 382, 381, 380, 374, 373, 390, 249, 263];
  static const List<int> leftJaw = [234, 227, 132, 58, 172, 136, 150, 149, 176];
  static const List<int> rightJaw = [454, 447, 361, 288, 397, 365, 379, 378, 400];
}

abstract class BaseFacePainter extends CustomPainter {
  final List<FaceLandmark> landmarks;
  final Size imageSize;

  const BaseFacePainter({required this.landmarks, required this.imageSize});

  Offset landmarkToScreen(FaceLandmark lm, Size canvasSize) {
    // MediaPipe returns normalized 0-1 coords, flip X for front camera
    return Offset(
      (1.0 - lm.x) * canvasSize.width,
      lm.y * canvasSize.height,
    );
  }

  Path buildZonePath(List<int> indices, Size canvasSize) {
    if (landmarks.isEmpty) return Path();
    final validIndices = indices.where((i) => i < landmarks.length).toList();
    if (validIndices.isEmpty) return Path();

    final points = validIndices.map((i) => landmarkToScreen(landmarks[i], canvasSize)).toList();
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }
}
```

---

## File 9 — `lib/ar_features/skin_zone_overlay_painter.dart`

Feature 1 — draws colored heatmap zones over skin problem areas:

```dart
import 'package:flutter/material.dart';
import 'face_mesh_painter.dart';
import 'mediapipe_channel.dart';

enum IssueSeverity { high, medium, low }

class SkinZoneIssue {
  final String zoneName;
  final String issueLabel;
  final IssueSeverity severity;

  const SkinZoneIssue({
    required this.zoneName,
    required this.issueLabel,
    required this.severity,
  });
}

class SkinZoneOverlayPainter extends BaseFacePainter {
  final List<SkinZoneIssue> issues;
  final double pulseValue; // 0.0 to 1.0 from AnimationController

  const SkinZoneOverlayPainter({
    required super.landmarks,
    required super.imageSize,
    required this.issues,
    required this.pulseValue,
  });

  static const Map<String, List<int>> zoneMap = {
    'forehead': FaceZones.forehead,
    'leftCheek': FaceZones.leftCheek,
    'rightCheek': FaceZones.rightCheek,
    'nose': FaceZones.nose,
    'chin': FaceZones.chin,
    'leftUnderEye': FaceZones.leftUnderEye,
    'rightUnderEye': FaceZones.rightUnderEye,
    'leftJaw': FaceZones.leftJaw,
    'rightJaw': FaceZones.rightJaw,
  };

  Color _severityColor(IssueSeverity s) => switch (s) {
    IssueSeverity.high   => const Color(0xFFFF3B30),
    IssueSeverity.medium => const Color(0xFFFF9500),
    IssueSeverity.low    => const Color(0xFFFFCC00),
  };

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.isEmpty) return;

    for (final issue in issues) {
      final indices = zoneMap[issue.zoneName];
      if (indices == null) continue;

      final path = buildZonePath(indices, size);
      final color = _severityColor(issue.severity);

      // Fill with animated opacity
      final fillPaint = Paint()
        ..color = color.withOpacity(0.25 + (pulseValue * 0.15))
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      // Animated border
      final borderPaint = Paint()
        ..color = color.withOpacity(0.7 + (pulseValue * 0.3))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, borderPaint);

      // Draw label at zone centroid
      _drawLabel(canvas, path, issue.issueLabel, color, size);
    }
  }

  void _drawLabel(Canvas canvas, Path path, String label, Color color, Size size) {
    final bounds = path.getBounds();
    final center = bounds.center;
    if (center.dx <= 0 || center.dy <= 0) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.028,
          fontWeight: FontWeight.w600,
          shadows: [Shadow(color: color, blurRadius: 8)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Background pill
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: textPainter.width + 14,
        height: textPainter.height + 8,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(rect, Paint()..color = color.withOpacity(0.85));

    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(SkinZoneOverlayPainter old) =>
      old.landmarks != landmarks || old.pulseValue != pulseValue || old.issues != issues;
}
```

---

## File 10 — `lib/ar_features/treatment_painter.dart`

Feature 2 — draws skin transformation overlay with animated progress:

```dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'face_mesh_painter.dart';
import 'mediapipe_channel.dart';

class TreatmentOverlayPainter extends BaseFacePainter {
  final double progress;       // 0.0 (current skin) → 1.0 (treated skin)
  final TreatmentConfig config;

  const TreatmentOverlayPainter({
    required super.landmarks,
    required super.imageSize,
    required this.progress,
    required this.config,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.isEmpty) return;

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    _applyFaceMaskClip(canvas, size);
    _applyColorCorrection(canvas, size);
    _applyGlowEffect(canvas, size);

    canvas.restore();
  }

  void _applyFaceMaskClip(Canvas canvas, Size size) {
    // Use outer face oval indices to clip
    const ovalIndices = [
      10, 338, 297, 332, 284, 251, 389, 356, 454,
      323, 361, 288, 397, 365, 379, 378, 400, 377,
      152, 148, 176, 149, 150, 136, 172, 58, 132,
      93, 234, 127, 162, 21, 54, 103, 67, 109
    ];

    final facePath = buildZonePath(ovalIndices, size);
    canvas.clipPath(facePath);
  }

  void _applyColorCorrection(Canvas canvas, Size size) {
    // Skin tone brightening + redness reduction as progress increases
    final opacity = progress * 0.35;
    final paint = Paint()
      ..colorFilter = ui.ColorFilter.matrix(_buildCorrectionMatrix())
      ..color = Colors.transparent.withOpacity(opacity);

    // Warm skin tone overlay
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = const Color(0xFFFFE0CC).withOpacity(opacity * 0.4)
        ..blendMode = BlendMode.softLight,
    );

    // Reduce redness
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = const Color(0xFFFFE4D6).withOpacity(opacity * 0.3)
        ..blendMode = BlendMode.luminosity,
    );
  }

  void _applyGlowEffect(Canvas canvas, Size size) {
    if (progress < 0.5) return;
    final glowOpacity = (progress - 0.5) * 2.0 * 0.15;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = Colors.white.withOpacity(glowOpacity)
        ..blendMode = BlendMode.overlay,
    );
  }

  List<double> _buildCorrectionMatrix() {
    // Color matrix: [R, G, B, A adjustments]
    // Progressively even skin tone and reduce spots
    final t = progress;
    return [
      1.0 + (t * 0.05),  0,               0,               0, t * 5,
      0,                  1.0 + (t * 0.03), 0,               0, t * 3,
      0,                  0,               1.0 - (t * 0.02), 0, t * 2,
      0,                  0,               0,               1, 0,
    ];
  }

  @override
  bool shouldRepaint(TreatmentOverlayPainter old) =>
      old.landmarks != landmarks || old.progress != progress;
}

class TreatmentConfig {
  final double rednessReduction;
  final double brightnessBoost;
  final double pigmentationCorrection;
  final double wrinkleSmoothing;

  const TreatmentConfig({
    this.rednessReduction = 0.6,
    this.brightnessBoost = 0.4,
    this.pigmentationCorrection = 0.5,
    this.wrinkleSmoothing = 0.3,
  });
}
```

---

## File 11 — `lib/ar_features/treatment_animation_controller.dart`

Manages the 4-phase treatment animation sequence:

```dart
import 'package:flutter/material.dart';

enum TreatmentPhase { idle, showing, applying, transforming, result }

class TreatmentAnimationController {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  TreatmentPhase phase = TreatmentPhase.idle;
  VoidCallback? onPhaseChanged;

  TreatmentAnimationController({required TickerProvider vsync}) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 6),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        phase = TreatmentPhase.result;
        onPhaseChanged?.call();
      }
    });

    _controller.addListener(() {
      final value = _controller.value;
      TreatmentPhase newPhase;

      if (value < 0.15) {
        newPhase = TreatmentPhase.showing;        // 0–0.9s: show current skin
      } else if (value < 0.45) {
        newPhase = TreatmentPhase.applying;       // 0.9–2.7s: applying animation
      } else {
        newPhase = TreatmentPhase.transforming;   // 2.7–6s: skin transforms
      }

      if (newPhase != phase) {
        phase = newPhase;
        onPhaseChanged?.call();
      }
    });
  }

  Animation<double> get animation => _animation;
  AnimationController get controller => _controller;

  /// Returns 0.0–1.0 progress for the transformation effect only
  double get transformProgress {
    if (_controller.value < 0.45) return 0.0;
    return ((_controller.value - 0.45) / 0.55).clamp(0.0, 1.0);
  }

  void start() {
    phase = TreatmentPhase.showing;
    _controller.forward(from: 0.0);
    onPhaseChanged?.call();
  }

  void reset() {
    _controller.reset();
    phase = TreatmentPhase.idle;
    onPhaseChanged?.call();
  }

  void dispose() => _controller.dispose();
}
```

---

## File 12 — `lib/ar_features/ar_camera_screen.dart`

Main screen combining camera + MediaPipe + both AR features:

```dart
import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mediapipe_channel.dart';
import 'face_mesh_painter.dart';
import 'skin_zone_overlay_painter.dart';
import 'treatment_painter.dart';
import 'treatment_animation_controller.dart';

enum ARMode { skinZones, treatmentPreview }

class ARCameraScreen extends StatefulWidget {
  /// Pass your skin analysis result here
  final List<SkinZoneIssue> detectedIssues;
  final TreatmentConfig treatmentConfig;
  final ARMode initialMode;

  const ARCameraScreen({
    super.key,
    required this.detectedIssues,
    this.treatmentConfig = const TreatmentConfig(),
    this.initialMode = ARMode.skinZones,
  });

  @override
  State<ARCameraScreen> createState() => _ARCameraScreenState();
}

class _ARCameraScreenState extends State<ARCameraScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  StreamSubscription<FaceMeshResult>? _meshSub;
  List<FaceLandmark> _landmarks = [];
  ARMode _mode = ARMode.skinZones;
  bool _isProcessing = false;

  // Feature 1 — pulse animation
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  // Feature 2 — treatment animation
  late final TreatmentAnimationController _treatmentController;
  TreatmentPhase _treatmentPhase = TreatmentPhase.idle;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);

    _treatmentController = TreatmentAnimationController(vsync: this);
    _treatmentController.onPhaseChanged = () {
      setState(() => _treatmentPhase = _treatmentController.phase);
    };

    _initCamera();
    _initMediaPipe();
  }

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
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});

    _cameraController!.startImageStream(_onCameraFrame);
  }

  Future<void> _initMediaPipe() async {
    await MediaPipeChannel.initialize();
    _meshSub = MediaPipeChannel.landmarkStream.listen((result) {
      if (mounted) {
        setState(() => _landmarks = result.detected ? result.landmarks : []);
      }
    });
  }

  void _onCameraFrame(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      // Convert to JPEG bytes for MediaPipe
      final bytes = image.planes[0].bytes;
      await MediaPipeChannel.processFrame(bytes, isFrontCamera: true);
    } finally {
      _isProcessing = false;
    }
  }

  @override
  void dispose() {
    _meshSub?.cancel();
    _cameraController?.dispose();
    _pulseController.dispose();
    _treatmentController.dispose();
    MediaPipeChannel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          if (_cameraController?.value.isInitialized == true)
            CameraPreview(_cameraController!),

          // AR Overlay
          if (_landmarks.isNotEmpty) _buildOverlay(),

          // No face detected message
          if (_landmarks.isEmpty) _buildNoFaceMessage(),

          // Controls
          _buildControls(),

          // Treatment phase UI
          if (_mode == ARMode.treatmentPreview) _buildTreatmentUI(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);

      if (_mode == ARMode.skinZones) {
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (_, __) => CustomPaint(
            painter: SkinZoneOverlayPainter(
              landmarks: _landmarks,
              imageSize: size,
              issues: widget.detectedIssues,
              pulseValue: _pulseAnimation.value,
            ),
          ),
        );
      } else {
        return AnimatedBuilder(
          animation: _treatmentController.animation,
          builder: (_, __) => CustomPaint(
            painter: TreatmentOverlayPainter(
              landmarks: _landmarks,
              imageSize: size,
              progress: _treatmentController.transformProgress,
              config: widget.treatmentConfig,
            ),
          ),
        );
      }
    });
  }

  Widget _buildNoFaceMessage() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Position your face in frame',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ModeButton(
            label: 'Skin Zones',
            icon: Icons.face_retouching_natural,
            selected: _mode == ARMode.skinZones,
            onTap: () => setState(() {
              _mode = ARMode.skinZones;
              _treatmentController.reset();
            }),
          ),
          const SizedBox(width: 16),
          _ModeButton(
            label: 'After Treatment',
            icon: Icons.auto_fix_high,
            selected: _mode == ARMode.treatmentPreview,
            onTap: () => setState(() => _mode = ARMode.treatmentPreview),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentUI() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Phase label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _phaseLabel(_treatmentPhase),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          // Start / Reset button
          if (_treatmentPhase == TreatmentPhase.idle || _treatmentPhase == TreatmentPhase.result)
            GestureDetector(
              onTap: () {
                if (_treatmentPhase == TreatmentPhase.result) {
                  _treatmentController.reset();
                } else {
                  _treatmentController.start();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  _treatmentPhase == TreatmentPhase.result ? 'Reset' : 'Preview Treatment',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _phaseLabel(TreatmentPhase phase) => switch (phase) {
    TreatmentPhase.idle         => 'Tap to preview your skin after treatment',
    TreatmentPhase.showing      => 'Analysing current skin condition...',
    TreatmentPhase.applying     => 'Applying recommended treatment...',
    TreatmentPhase.transforming => 'Transforming skin...',
    TreatmentPhase.result       => 'This is how your skin could look ✨',
  };
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6C63FF) : Colors.black54,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF6C63FF) : Colors.white24,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
```

---

## Final Instructions for Qoder

After all files are written:

1. Replace every `<YOUR_PACKAGE_NAME>` in Kotlin files with the actual package name from `MainActivity.kt`.

2. Open `ARCameraScreen` and replace `List<SkinZoneIssue> detectedIssues` with actual skin analysis result data from your existing model class. Map each detected issue (e.g. redness → `rightCheek`, pigmentation → `leftCheek`) to a `SkinZoneIssue`.

3. Navigate to `ARCameraScreen` from wherever skin analysis result is shown, passing issues like:
```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => ARCameraScreen(
    detectedIssues: [
      SkinZoneIssue(zoneName: 'forehead', issueLabel: 'Wrinkles', severity: IssueSeverity.medium),
      SkinZoneIssue(zoneName: 'rightCheek', issueLabel: 'Redness', severity: IssueSeverity.high),
      SkinZoneIssue(zoneName: 'nose', issueLabel: 'Large Pores', severity: IssueSeverity.low),
    ],
    treatmentConfig: TreatmentConfig(rednessReduction: 0.7, brightnessBoost: 0.5),
    initialMode: ARMode.skinZones,
  ),
));
```

4. Run `flutter run` and test on a physical device (AR/camera features do not work on emulators).

5. If you get JPEG conversion issues in `_onCameraFrame`, install `image` package and add:
```dart
import 'package:image/image.dart' as img;
// Convert YUV420 to JPEG bytes before passing to MediaPipe
```
Ask Qoder to implement full YUV420 → JPEG conversion if needed.
