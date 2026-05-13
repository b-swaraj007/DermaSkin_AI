import 'dart:async';
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

  static Future<void> processFrame(Uint8List jpegBytes,
      {bool isFrontCamera = true}) async {
    await _method.invokeMethod('processFrame', {
      'bytes': jpegBytes,
      'isFrontCamera': isFrontCamera,
    });
  }

  static Stream<FaceMeshResult> get landmarkStream {
    _stream ??= _events.receiveBroadcastStream().map((event) {
      final map = Map<String, dynamic>.from(event as Map);
      final detected = map['detected'] as bool? ?? false;
      if (!detected) {
        return const FaceMeshResult(detected: false, landmarks: []);
      }

      final rawList = map['landmarks'] as List;
      final landmarks = rawList
          .map((e) => FaceLandmark.fromMap(Map.from(e as Map)))
          .toList();
      return FaceMeshResult(detected: true, landmarks: landmarks);
    });
    return _stream!;
  }

  static Future<Uint8List?> processYuvFrame({
    required Uint8List yuvBytes,
    required int width,
    required int height,
    required int numPlanes,
    required int bytesPerRowY,
    bool isFrontCamera = true,
  }) async {
    try {
      final result = await _method.invokeMethod<Uint8List>(
        'processYuvFrame',
        {
          'yuvBytes': yuvBytes,
          'width': width,
          'height': height,
          'isFrontCamera': isFrontCamera,
          'numPlanes': numPlanes,
          'bytesPerRowY': bytesPerRowY,
        },
      );
      return result;
    } catch (_) {
      return null;
    }
  }

  static Future<void> dispose() async {
    await _method.invokeMethod('dispose');
    _stream = null;
  }
}
