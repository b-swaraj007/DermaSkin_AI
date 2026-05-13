import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class FaceDetectionService {
  static FaceDetectionService? _instance;

  static FaceDetectionService get instance {
    _instance ??= FaceDetectionService._();
    return _instance!;
  }

  FaceDetectionService._();

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true,
      // enableContours intentionally OFF:
      // - contour detection allocates a large native buffer per frame
      //   (~1.5MB of Point<int> arrays) which, combined with the
      //   YUV frame bytes below, causes Android to OOM-kill the
      //   process mid-scan on mid-range devices.
      // - we don't use `face.contours` anywhere in the scan pipeline,
      //   so turning this off is free.
      enableContours: false,
      // `fast` is still highly accurate for our readiness checks
      // (centered / close / eyes open / head yaw) and roughly 2x
      // faster than `accurate`, which reduces the time each frame
      // holds a CameraImage buffer.
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool _isProcessing = false;
  List<Face> _detectedFaces = [];

  List<Face> get detectedFaces => _detectedFaces;
  bool get isFaceDetected => _detectedFaces.isNotEmpty;

  // ===============================
  // Process Camera Frame
  // ===============================
  Future<List<Face>> processFrame({
    required CameraImage cameraImage,
    required int sensorOrientation,
  }) async {
    if (_isProcessing) return _detectedFaces;
    _isProcessing = true;

    try {
      final inputImage = _convertCameraImageToInputImage(
        cameraImage,
        sensorOrientation,
      );

      if (inputImage == null) return [];

      final faces = await _faceDetector.processImage(inputImage);
      _detectedFaces = faces;

      if (faces.isNotEmpty) {
        debugPrint(
          'DermaScan: Face detected! '
          'Landmarks: ${faces[0].landmarks.length}',
        );
      }

      return faces;
    } catch (e) {
      debugPrint('DermaScan: Face detection error: $e');
      return [];
    } finally {
      _isProcessing = false; // ✅ always reset
    }
  }

  // ===============================
  // Convert CameraImage → InputImage
  // ===============================
  InputImage? _convertCameraImageToInputImage(
    CameraImage image,
    int sensorOrientation,
  ) {
    try {
      final imageRotation = _getImageRotation(sensorOrientation);

      final inputImageFormat =
          InputImageFormatValue.fromRawValue(image.format.raw);
      if (inputImageFormat == null) return null;

      final bytes = _concatenatePlanes(image.planes);

      return InputImage.fromBytes(
        bytes: bytes, // ✅ already Uint8List
        metadata: InputImageMetadata(
          size: Size(
            image.width.toDouble(),
            image.height.toDouble(),
          ),
          rotation: imageRotation,
          format: inputImageFormat,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );
    } catch (e) {
      debugPrint('DermaScan: Image conversion error: $e');
      return null;
    }
  }

  // ===============================
  // Efficient byte concatenation
  //
  // IMPORTANT: do NOT use `List<int>` + `addAll` here. Dart boxes each
  // byte in `List<int>` as a heap `int` object (~8 bytes), so a single
  // ~1.4 MB YUV frame balloons to ~11 MB of live allocations. Repeating
  // this at ~3 fps saturates the process heap within seconds and Android
  // kills the app ("app closed automatically while scanning"). Allocating
  // one pre-sized `Uint8List` and blitting the plane bytes in keeps the
  // per-frame cost flat at exactly the frame size.
  // ===============================
  Uint8List _concatenatePlanes(List<Plane> planes) {
    int total = 0;
    for (final plane in planes) {
      total += plane.bytes.length;
    }
    final out = Uint8List(total);
    int offset = 0;
    for (final plane in planes) {
      out.setRange(offset, offset + plane.bytes.length, plane.bytes);
      offset += plane.bytes.length;
    }
    return out;
  }

  // ===============================
  // Rotation mapping
  // ===============================
  InputImageRotation _getImageRotation(int sensorOrientation) {
    switch (sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation90deg;
    }
  }

  // ===============================
  // Landmark position → screen
  // ===============================
  Offset? getLandmarkPosition(
    Face face,
    FaceLandmarkType landmarkType,
    Size screenSize,
    Size imageSize,
  ) {
    final landmark = face.landmarks[landmarkType];
    if (landmark == null) return null;

    final scaleX = screenSize.width / imageSize.width;
    final scaleY = screenSize.height / imageSize.height;

    return Offset(
      landmark.position.x * scaleX,
      landmark.position.y * scaleY,
    );
  }

  // ===============================
  // Bounding box scaling
  // ===============================
  Rect getScaledBoundingBox(
    Face face,
    Size screenSize,
    Size imageSize,
  ) {
    final scaleX = screenSize.width / imageSize.width;
    final scaleY = screenSize.height / imageSize.height;

    return Rect.fromLTRB(
      face.boundingBox.left * scaleX,
      face.boundingBox.top * scaleY,
      face.boundingBox.right * scaleX,
      face.boundingBox.bottom * scaleY,
    );
  }

  // ===============================
  // Face readiness checks
  //
  // IMPORTANT: [face.boundingBox] is in the **camera image** coordinate space
  // (pixels of the sensor frame after rotation), NOT Flutter logical pixels.
  // Callers MUST pass the image size from the camera (e.g.
  // `controller.value.previewSize`, swapped for portrait), not
  // `MediaQuery.of(context).size`, or these checks will never pass.
  // ===============================
  Map<String, bool> checkFaceReadiness(
    Face face,
    Size imageSize,
  ) {
    final box = face.boundingBox;
    final faceWidth = box.width;

    // Use ratios against the IMAGE size. The face box's center x relative
    // to the image width is the most robust "centered" signal because it's
    // independent of small crops / letterboxing between preview and sensor.
    final centerX = (box.left + box.right) / 2.0;
    final centerY = (box.top + box.bottom) / 2.0;
    final horizontallyCentered =
        centerX > imageSize.width * 0.25 &&
        centerX < imageSize.width * 0.75;
    final verticallyCentered =
        centerY > imageSize.height * 0.2 &&
        centerY < imageSize.height * 0.8;

    return {
      'face_centered': horizontallyCentered && verticallyCentered,

      // Face takes at least ~18% of the image width — loose enough to work
      // with typical selfie framing on mid-range phones.
      'face_close_enough': faceWidth > imageSize.width * 0.18,

      'face_straight':
          (face.headEulerAngleY ?? 0).abs() < 15 &&
          (face.headEulerAngleZ ?? 0).abs() < 15,

      'eyes_open':
          (face.leftEyeOpenProbability ?? 0) > 0.5 &&
          (face.rightEyeOpenProbability ?? 0) > 0.5,
    };
  }

  // ===============================
  // Dispose
  // ===============================
  Future<void> dispose() async {
    await _faceDetector.close();
    debugPrint('DermaScan: Face detector disposed');
  }
}