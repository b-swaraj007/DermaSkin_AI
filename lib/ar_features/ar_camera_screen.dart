import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

import 'mediapipe_channel.dart';
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
  String? _errorMessage;
  int _lastFrameTime = 0;
  static const int _frameIntervalMs = 66; // ~15fps
  final _landmarkNotifier = ValueNotifier<List<FaceLandmark>>([]);

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
    _pulseAnimation =
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);

    _treatmentController = TreatmentAnimationController(vsync: this);
    _treatmentController.onPhaseChanged = () {
      if (!mounted) return;
      setState(() => _treatmentPhase = _treatmentController.phase);
    };

    _initCamera();
    _initMediaPipe();
  }

  Future<void> _initCamera() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() => _errorMessage = 'Camera permission not granted');
        return;
      }

      final cameras = await availableCameras();
      final frontCam = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCam,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {});

      // Short delay to prevent SurfaceTexture conflict on Android
      await Future.delayed(const Duration(milliseconds: 300));

      if (_cameraController!.value.isInitialized) {
        await _cameraController!.startImageStream(_onCameraFrame);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Camera error: $e');
    }
  }

  Future<void> _initMediaPipe() async {
    try {
      await MediaPipeChannel.initialize();
      _meshSub = MediaPipeChannel.landmarkStream.listen((result) {
        _landmarkNotifier.value = result.detected ? result.landmarks : [];
        if (mounted) setState(() => _landmarks = _landmarkNotifier.value);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'MediaPipe error: $e');
    }
  }

  void _onCameraFrame(CameraImage image) {
    // DO NOT use async/await here — this runs on camera thread
    // Use a flag to skip frames, never block
    final now = DateTime.now().millisecondsSinceEpoch;

    // Skip frames to maintain ~15fps processing rate
    if (now - _lastFrameTime < _frameIntervalMs) return;
    if (_isProcessing || _errorMessage != null) return;

    _lastFrameTime = now;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          if (_cameraController?.value.isInitialized == true && _landmarks.isEmpty && _errorMessage == null)
            Center(child: _buildNoFaceMessage()),

          // Layer 4: Mode controls at bottom
          if (_errorMessage == null) _buildControls(),

          // Layer 5: Treatment UI at top
          if (_mode == ARMode.treatmentPreview && _errorMessage == null) _buildTreatmentUI(),

          // Layer 6: Skin Zones info (legend + issue count)
          if (_mode == ARMode.skinZones && _errorMessage == null) _buildSkinZonesInfo(),

          // Error / loading overlay
          if (_errorMessage != null) _buildErrorOverlay(),

          if (!(_cameraController?.value.isInitialized == true) && _errorMessage == null)
            _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildErrorOverlay() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
              child: const Text('Go Back', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Starting camera…',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

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

  Widget _buildSkinZonesInfo() {
    final issues = widget.detectedIssues;
    final hasFace = _landmarks.isNotEmpty;
    final totalIssues = issues.length;

    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Status badge
          if (hasFace)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                totalIssues > 0
                    ? '$totalIssues issue${totalIssues > 1 ? 's' : ''} detected'
                    : 'Face detected — no issues found',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          const SizedBox(height: 8),
          // Legend
          if (hasFace && totalIssues > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _legendDot(const Color(0xFFFF3B30), 'Needs care'),
                  const SizedBox(width: 12),
                  _legendDot(const Color(0xFFFF9500), 'Watch'),
                  const SizedBox(width: 12),
                  _legendDot(const Color(0xFFFFCC00), 'Mild'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
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
          if (_treatmentPhase == TreatmentPhase.idle ||
              _treatmentPhase == TreatmentPhase.result)
            GestureDetector(
              onTap: () {
                if (_treatmentPhase == TreatmentPhase.result) {
                  _treatmentController.reset();
                } else {
                  _treatmentController.start();
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  _treatmentPhase == TreatmentPhase.result
                      ? 'Reset'
                      : 'Preview Treatment',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _phaseLabel(TreatmentPhase phase) => switch (phase) {
        TreatmentPhase.idle =>
          'Tap to preview your skin after treatment',
        TreatmentPhase.showing => 'Analysing current skin condition...',
        TreatmentPhase.applying => 'Applying recommended treatment...',
        TreatmentPhase.transforming => 'Transforming skin...',
        TreatmentPhase.result => 'This is how your skin could look ✨',
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
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
