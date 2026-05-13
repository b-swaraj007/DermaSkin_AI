import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService {
  static CameraService? _instance;
  static CameraService get instance {
    _instance ??= CameraService._();
    return _instance!;
  }
  CameraService._();

  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  // Initialize front camera for face scanning
  Future<void> initializeFrontCamera() async {
    try {
      // Get all available cameras
      _cameras = await availableCameras();

      // Find front camera
      CameraDescription? frontCamera;
      for (var camera in _cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          frontCamera = camera;
          break;
        }
      }

      if (frontCamera == null) {
        debugPrint('DermaScan: No front camera found');
        return;
      }

      // Initialize controller.
      //
      // ResolutionPreset.medium (~720x480) is the sweet spot for our
      // pipeline:
      //   - face detection / readiness checks only need the face bounding
      //     box + head-yaw angle, which are rock-solid at 720x480.
      //   - HIGH (1920x1080) produces ~3MB NV21 frames, and at the ~3fps
      //     detection cadence this saturates the Dart heap within seconds
      //     and Android OOM-kills the process mid-scan.
      //   - The final still for Face++ still uses `controller.takePicture()`
      //     which captures at the sensor's native resolution, so product
      //     quality is unaffected.
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21, // Best for ML Kit on Android
      );

      await _controller!.initialize();
      _isInitialized = true;
      debugPrint('DermaScan: Front camera initialized ✅');

    } catch (e) {
      debugPrint('DermaScan: Camera init error: $e');
      _isInitialized = false;
    }
  }

  // Toggle torch/flashlight
  Future<void> toggleTorch(bool enable) async {
    try {
      if (_controller != null && _isInitialized) {
        await _controller!.setFlashMode(
          enable ? FlashMode.torch : FlashMode.off
        );
      }
    } catch (e) {
      debugPrint('DermaScan: Torch error: $e');
    }
  }

  // Start image stream for real-time ML Kit analysis
  Future<void> startImageStream(
    Function(CameraImage image) onImage
  ) async {
    if (_controller != null && _isInitialized) {
      await _controller!.startImageStream(onImage);
      debugPrint('DermaScan: Image stream started ✅');
    }
  }

  // Stop image stream
  Future<void> stopImageStream() async {
    if (_controller != null && 
        _controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
      debugPrint('DermaScan: Image stream stopped');
    }
  }

  // Release camera resources
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
    debugPrint('DermaScan: Camera disposed');
  }
}