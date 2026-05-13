import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// This is the CustomPainter that draws
// all AR overlays on top of camera feed
class FaceAROverlayPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final bool showMesh;
  final bool showDiagnosticZones;
  final Map<String, double> skinParameters;

  FaceAROverlayPainter({
    required this.faces,
    required this.imageSize,
    this.showMesh = true,
    this.showDiagnosticZones = false,
    this.skinParameters = const {},
  });

  @override
  void paint(Canvas canvas, Size screenSize) {
    if (faces.isEmpty) return;

    final face = faces.first;

    // Scale factors from image to screen
    final scaleX = screenSize.width / imageSize.width;
    final scaleY = screenSize.height / imageSize.height;

    if (showMesh) {
      _drawFaceMesh(canvas, face, scaleX, scaleY);
    }

    if (showDiagnosticZones) {
      _drawDiagnosticZones(
        canvas, face, scaleX, scaleY, screenSize
      );
    }

    _drawFaceBoundingGuide(canvas, face, scaleX, scaleY);
  }

  // Draw the teal wireframe face mesh
  void _drawFaceMesh(
    Canvas canvas, 
    Face face, 
    double scaleX, 
    double scaleY
  ) {
    final meshPaint = Paint()
      ..color = const Color(0xFF0D5C63).withValues(alpha: 0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFFC9A84C).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    // Draw contour points as dots
    for (final contour in face.contours.values) {
      if (contour == null) continue;

      final points = contour.points;

      // Draw lines connecting contour points
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(
          Offset(points[i].x * scaleX, points[i].y * scaleY),
          Offset(
            points[i + 1].x * scaleX, 
            points[i + 1].y * scaleY
          ),
          meshPaint,
        );
      }

      // Draw gold dots at each landmark point
      for (final point in points) {
        canvas.drawCircle(
          Offset(point.x * scaleX, point.y * scaleY),
          2.0,
          dotPaint,
        );
      }
    }

    // Draw landmark points (eyes, nose, ears, mouth)
    _drawLandmarks(canvas, face, scaleX, scaleY);
  }

  void _drawLandmarks(
    Canvas canvas, 
    Face face, 
    double scaleX, 
    double scaleY
  ) {
    final landmarkPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    for (final landmark in face.landmarks.values) {
      if (landmark == null) continue;
      canvas.drawCircle(
        Offset(
          landmark.position.x * scaleX,
          landmark.position.y * scaleY
        ),
        3.5,
        landmarkPaint,
      );
    }
  }

  // Draw colored diagnostic zones on face
  // This is the AR POINT 2 functionality
  void _drawDiagnosticZones(
    Canvas canvas,
    Face face,
    double scaleX,
    double scaleY,
    Size screenSize,
  ) {
    final box = face.boundingBox;
    final faceLeft = box.left * scaleX;
    final faceTop = box.top * scaleY;
    final faceWidth = box.width * scaleX;
    final faceHeight = box.height * scaleY;

    // Redness zones (cheeks)
    final rednessScore = skinParameters['redness'] ?? 0;
    if (rednessScore > 30) {
      _drawZone(
        canvas: canvas,
        // Left cheek
        rect: Rect.fromLTWH(
          faceLeft + faceWidth * 0.05,
          faceTop + faceHeight * 0.35,
          faceWidth * 0.28,
          faceHeight * 0.25,
        ),
        color: const Color(0xFFE05C5C),
        opacity: (rednessScore / 100) * 0.4,
        label: 'Redness',
      );
      _drawZone(
        canvas: canvas,
        // Right cheek
        rect: Rect.fromLTWH(
          faceLeft + faceWidth * 0.67,
          faceTop + faceHeight * 0.35,
          faceWidth * 0.28,
          faceHeight * 0.25,
        ),
        color: const Color(0xFFE05C5C),
        opacity: (rednessScore / 100) * 0.4,
        label: '',
      );
    }

    // Pigmentation zones (forehead + cheeks)
    final pigmentScore = skinParameters['pigmentation'] ?? 0;
    if (pigmentScore > 20) {
      _drawZone(
        canvas: canvas,
        rect: Rect.fromLTWH(
          faceLeft + faceWidth * 0.2,
          faceTop + faceHeight * 0.05,
          faceWidth * 0.6,
          faceHeight * 0.2,
        ),
        color: const Color(0xFF8B4513),
        opacity: (pigmentScore / 100) * 0.35,
        label: 'Pigmentation',
      );
    }

    // Pore congestion zone (nose + T-zone)
    final poreScore = skinParameters['pores'] ?? 0;
    if (poreScore > 25) {
      _drawZone(
        canvas: canvas,
        rect: Rect.fromLTWH(
          faceLeft + faceWidth * 0.35,
          faceTop + faceHeight * 0.3,
          faceWidth * 0.3,
          faceHeight * 0.35,
        ),
        color: const Color(0xFFC9A84C),
        opacity: (poreScore / 100) * 0.35,
        label: 'Pores',
      );
    }

    // Moisture zone (full face, blue tint)
    final moistureScore = skinParameters['moisture'] ?? 0;
    if (moistureScore < 50) {
      _drawZone(
        canvas: canvas,
        rect: Rect.fromLTWH(
          faceLeft,
          faceTop,
          faceWidth,
          faceHeight,
        ),
        color: const Color(0xFF4A90D9),
        opacity: 0.08,
        label: 'Low Moisture',
      );
    }
  }

  // Helper to draw a colored zone with label
  void _drawZone({
    required Canvas canvas,
    required Rect rect,
    required Color color,
    required double opacity,
    required String label,
  }) {
    // Filled zone
    final fillPaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      fillPaint,
    );

    // Zone border
    final borderPaint = Paint()
      ..color = color.withValues(alpha: opacity + 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      borderPaint,
    );

    // Label text
    if (label.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            backgroundColor: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(rect.left + 4, rect.top + 4),
      );
    }
  }

  // Draw alignment guide oval around face
  void _drawFaceBoundingGuide(
    Canvas canvas,
    Face face,
    double scaleX,
    double scaleY,
  ) {
    final box = face.boundingBox;
    final center = Offset(
      (box.left + box.right) / 2 * scaleX,
      (box.top + box.bottom) / 2 * scaleY,
    );

    final guidePaint = Paint()
      ..color = const Color(0xFF0D5C63).withValues(alpha: 0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw oval guide around face
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: box.width * scaleX * 1.1,
        height: box.height * scaleY * 1.1,
      ),
      guidePaint,
    );
  }

  @override
  bool shouldRepaint(FaceAROverlayPainter oldDelegate) {
    return oldDelegate.faces != faces ||
           oldDelegate.skinParameters != skinParameters;
  }
}