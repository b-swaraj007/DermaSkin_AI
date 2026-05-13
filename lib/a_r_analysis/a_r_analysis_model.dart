import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/services/camera_service.dart';
import '/services/face_detection_service.dart';
import '/services/hybrid_skin_analyzer.dart';
import '/services/skin_analyzer.dart';
import 'a_r_analysis_widget.dart' show ARAnalysisWidget;

/// Ordered steps of the guided multi-angle face capture flow.
enum ScanAngle { front, left, right }

extension ScanAngleX on ScanAngle {
  String get key => name;

  /// Instruction shown to the user while awaiting this angle.
  String get instruction {
    switch (this) {
      case ScanAngle.front:
        return 'Look straight into the camera';
      case ScanAngle.left:
        return 'Turn your face to the left';
      case ScanAngle.right:
        return 'Turn your face to the right';
    }
  }

  /// Short label shown in the step-progress pill.
  String get label {
    switch (this) {
      case ScanAngle.front:
        return 'Front';
      case ScanAngle.left:
        return 'Left';
      case ScanAngle.right:
        return 'Right';
    }
  }
}

class ARAnalysisModel extends FlutterFlowModel<ARAnalysisWidget> {
  // ── Services (singletons) ──
  final CameraService cameraService = CameraService.instance;
  final FaceDetectionService faceDetectionService =
      FaceDetectionService.instance;
  final SkinAnalyzer skinAnalyzer = SkinAnalyzer.instance;
  final HybridSkinAnalyzer hybridAnalyzer = HybridSkinAnalyzer.instance;

  /// Last good frame that passed alignment checks. Cached so we can hand it
  /// off to the analyzer at capture time — `controller.takePicture()` gives
  /// a JPEG on disk, but the ML pipeline needs the raw YUV [CameraImage].
  CameraImage? _lastGoodFrame;

  // ── Camera / torch state ──
  bool isCameraReady = false;
  bool isTorchOn = false;

  // ── Detection state ──
  bool isFaceDetected = false;
  List<Face> detectedFaces = const [];

  // ── Multi-angle capture flow ──
  static const List<ScanAngle> sequence = <ScanAngle>[
    ScanAngle.front,
    ScanAngle.left,
    ScanAngle.right,
  ];
  int currentStepIndex = 0;
  final Map<String, String> capturedPaths = {};

  bool isAligned = false;
  bool isCapturing = false;
  bool isAnalyzing = false;
  bool isAnalysisComplete = false;

  /// Human-readable hint shown near the top of the screen.
  String statusMessage = 'Position your face in the frame';

  // ── Internal throttling + concurrency guards ──
  DateTime _lastProcessedAt = DateTime.fromMillisecondsSinceEpoch(0);
  static const Duration _minProcessInterval = Duration(milliseconds: 350);
  bool _processing = false;

  /// Counts consecutive aligned frames so a capture only fires after the user
  /// has held steady — prevents triggering on a single spurious frame.
  int _stableFrames = 0;
  static const int _stableFramesRequired = 2; // ~700ms at 350 ms throttle

  /// Cached size of the **camera image** (post-rotation), populated after the
  /// camera is initialized. This is what [FaceDetectionService] needs for
  /// its readiness ratios — NOT the Flutter screen size.
  Size _imageSize = Size.zero;

  // ── Convenience getters ──
  bool get isComplete => currentStepIndex >= sequence.length;
  ScanAngle get currentAngle =>
      isComplete ? sequence.last : sequence[currentStepIndex];
  int get totalSteps => sequence.length;
  int get displayStep => (currentStepIndex + 1).clamp(1, totalSteps);

  @override
  void initState(BuildContext context) {
    // FlutterFlowModel hook — nothing to do here; camera setup happens
    // explicitly via [initializeCamera] so permission flow is widget-driven.
  }

  /// Initialize the front camera, start the throttled face-detection stream.
  Future<void> initializeCamera({
    required BuildContext context,
    required VoidCallback onUpdate,
  }) async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      statusMessage = 'Camera permission required';
      onUpdate();
      return;
    }

    await cameraService.initializeFrontCamera();
    if (!cameraService.isInitialized) {
      statusMessage = 'Unable to initialize camera';
      onUpdate();
      return;
    }

    // Compute the IMAGE-space size from the camera preview. The camera
    // plugin reports previewSize in sensor-native orientation (landscape),
    // so for portrait scanning we swap width and height.
    final preview = cameraService.controller?.value.previewSize;
    if (preview != null) {
      _imageSize = Size(preview.height, preview.width);
    }
    debugPrint('DermaScan: scan imageSize=$_imageSize');

    isCameraReady = true;
    statusMessage = currentAngle.instruction;
    onUpdate();

    await _startStream(onUpdate);
  }

  Future<void> _startStream(VoidCallback onUpdate) async {
    await cameraService.startImageStream((image) {
      // Lightweight filters — we must return immediately from most frames so
      // the camera plugin doesn't back up its buffers.
      final now = DateTime.now();
      if (_processing) return;
      if (now.difference(_lastProcessedAt) < _minProcessInterval) return;
      _lastProcessedAt = now;
      _processFrame(image, onUpdate);
    });
  }

  /// Run lightweight face detection + alignment checks. Heavy ML is NEVER
  /// invoked here — that waits until [_runAnalysis] after all angles are
  /// captured.
  Future<void> _processFrame(
    CameraImage image,
    VoidCallback onUpdate,
  ) async {
    if (isCapturing || isAnalyzing || isAnalysisComplete) return;
    _processing = true;
    try {
      final sensor =
          cameraService.controller?.description.sensorOrientation ?? 90;
      final faces = await faceDetectionService.processFrame(
        cameraImage: image,
        sensorOrientation: sensor,
      );

      detectedFaces = faces;
      isFaceDetected = faces.isNotEmpty;

      if (faces.isEmpty) {
        _stableFrames = 0;
        isAligned = false;
        statusMessage = 'No face detected — ${currentAngle.instruction}';
        onUpdate();
        return;
      }

      final face = faces.first;
      final readiness =
          faceDetectionService.checkFaceReadiness(face, _imageSize);
      final centered = readiness['face_centered'] ?? false;
      final closeEnough = readiness['face_close_enough'] ?? false;
      final eyesOpen = readiness['eyes_open'] ?? true;
      final yaw = face.headEulerAngleY ?? 0;

      final angleOk = _matchesAngle(currentAngle, yaw);

      debugPrint(
        'DermaScan: step=${currentAngle.key} yaw=${yaw.toStringAsFixed(1)} '
        'centered=$centered close=$closeEnough angleOk=$angleOk '
        'stable=$_stableFrames',
      );

      // Evaluate checks in order of severity so the hint is always useful.
      if (!closeEnough) {
        _fail('Move closer to the camera');
      } else if (!centered) {
        _fail('Center your face in the frame');
      } else if (!angleOk) {
        _fail(currentAngle.instruction);
      } else if (currentAngle == ScanAngle.front && !eyesOpen) {
        _fail('Open your eyes');
      } else {
        _stableFrames += 1;
        isAligned = _stableFrames >= _stableFramesRequired;
        _lastGoodFrame = image;
        statusMessage = isAligned
            ? 'Hold still — tap to capture'
            : 'Almost there…';
      }
      onUpdate();
    } finally {
      _processing = false;
    }
  }

  void _fail(String hint) {
    _stableFrames = 0;
    isAligned = false;
    statusMessage = hint;
  }

  bool _matchesAngle(ScanAngle a, double yaw) {
    switch (a) {
      case ScanAngle.front:
        return yaw.abs() <= 10;
      case ScanAngle.left:
        return yaw < -20;
      case ScanAngle.right:
        return yaw > 20;
    }
  }

  /// Capture the current step. Stops the stream, takes a still picture,
  /// stores its path, then either moves to the next step (restarting the
  /// stream) or kicks off the final analysis if all steps are done.
  Future<void> captureCurrentAngle(VoidCallback onUpdate) async {
    if (isCapturing || isAnalyzing || isAnalysisComplete) return;
    // Require a face in view — we no longer require full auto-alignment so
    // the user can tap Capture manually if the auto-gate is being finicky.
    if (!isFaceDetected) return;

    final controller = cameraService.controller;
    if (controller == null || !cameraService.isInitialized) return;

    isCapturing = true;
    statusMessage = 'Capturing…';
    onUpdate();

    try {
      if (controller.value.isStreamingImages) {
        await cameraService.stopImageStream();
        // Give the plugin a beat to drain its last in-flight frame so the
        // still-capture session can be created cleanly.
        await Future<void>.delayed(const Duration(milliseconds: 120));
      }
      final file = await controller.takePicture();
      capturedPaths[currentAngle.key] = file.path;

      // IMPORTANT: after `takePicture()` the native camera plugin posts
      // an `unlockAutoFocus()` task onto its CameraBackground thread that
      // re-uses the existing CameraCaptureSession. If we restart the
      // image stream too quickly (which creates a NEW session and nulls
      // the old reference), that background task dereferences a null
      // session and the whole process dies with:
      //
      //   FATAL EXCEPTION: CameraBackground
      //   NullPointerException at Camera.unlockAutoFocus(Camera.java:818)
      //
      // A ~700ms settle delay is more than enough for the plugin's AF
      // cleanup to finish on every Android device we've tested.
      await Future<void>.delayed(const Duration(milliseconds: 700));

      // Feed the captured frame into the analyzers (best-effort; failure
      // here must not block the rest of the scan flow).
      try {
        final frame = _lastGoodFrame;
        final face = detectedFaces.isNotEmpty ? detectedFaces.first : null;
        if (frame != null && face != null) {
          skinAnalyzer.addCapture(frame, face);
          if (currentAngle == ScanAngle.front) {
            hybridAnalyzer.setBestFrame(frame, face);
          }
        }
      } catch (e) {
        debugPrint('DermaScan: capture ingest failed — $e');
      }

      currentStepIndex += 1;
      _stableFrames = 0;
      isAligned = false;

      if (isComplete) {
        statusMessage = 'Analyzing skin…';
        // Stream is already stopped; don't restart it.
        onUpdate();
      } else {
        statusMessage = currentAngle.instruction;
        // Guard the restart so a plugin-side exception (e.g. user
        // backed out during the 700ms settle) can never propagate up
        // and tear down the whole AR screen.
        try {
          if (cameraService.isInitialized) {
            await _startStream(onUpdate);
          }
        } catch (e) {
          debugPrint('DermaScan: stream restart failed — $e');
          statusMessage = 'Camera busy — tap to retry';
        }
      }
    } catch (e) {
      debugPrint('DermaScan: capture failed — $e');
      statusMessage = 'Capture failed — try again';
      // If the stream is no longer running, try to bring it back so the
      // user can retry. Failure here is swallowed — the UI stays usable.
      try {
        final c = cameraService.controller;
        if (cameraService.isInitialized &&
            c != null &&
            !c.value.isStreamingImages) {
          await _startStream(onUpdate);
        }
      } catch (_) {/* best-effort */}
    } finally {
      isCapturing = false;
      onUpdate();
    }
  }

  /// Kick off the heavy hybrid skin analysis. Returns the future so callers
  /// can pass it to [ScanProcessingWidget] and await there.
  Future<Map<String, SkinParameterResult>> runAnalysis() {
    return hybridAnalyzer.analyzeAll();
  }

  /// User cancelled the scan — wipe any buffered captures and frames.
  void cancelScan() {
    try {
      skinAnalyzer.clearCaptures();
      hybridAnalyzer.clear();
    } catch (_) {/* best-effort */}
    _lastGoodFrame = null;
  }

  Future<void> toggleTorch(VoidCallback onUpdate) async {
    isTorchOn = !isTorchOn;
    onUpdate();
    await cameraService.toggleTorch(isTorchOn);
  }

  /// Stop camera and release its platform resources. The ML Kit detector is
  /// intentionally NOT closed here — it's a shared singleton so the next
  /// scan doesn't need to reload models.
  @override
  void dispose() {
    cameraService.stopImageStream();
    cameraService.dispose();
  }
}
