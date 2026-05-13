import 'package:flutter/material.dart';
import 'face_mesh_painter.dart';

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
        IssueSeverity.high => const Color(0xFFFF3B30),
        IssueSeverity.medium => const Color(0xFFFF9500),
        IssueSeverity.low => const Color(0xFFFFCC00),
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
        ..color = color.withValues(alpha: 0.25 + (pulseValue * 0.15))
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      // Animated border
      final borderPaint = Paint()
        ..color = color.withValues(alpha: 0.7 + (pulseValue * 0.3))
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
    canvas.drawRRect(rect, Paint()..color = color.withValues(alpha: 0.85));

    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(SkinZoneOverlayPainter old) =>
      old.landmarks != landmarks ||
      old.pulseValue != pulseValue ||
      old.issues != issues;
}
