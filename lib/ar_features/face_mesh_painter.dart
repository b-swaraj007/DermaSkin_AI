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

    final points =
        validIndices.map((i) => landmarkToScreen(landmarks[i], canvasSize)).toList();
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }
}
