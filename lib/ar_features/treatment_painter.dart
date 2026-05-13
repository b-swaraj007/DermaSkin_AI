import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'face_mesh_painter.dart';

class TreatmentOverlayPainter extends BaseFacePainter {
  final double progress; // 0.0 (current skin) → 1.0 (treated skin)
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

    // Unused placeholder paint retained from design (color matrix future work)
    // ignore: unused_local_variable
    final matrixPaint = Paint()
      ..colorFilter = ui.ColorFilter.matrix(_buildCorrectionMatrix())
      ..color = Colors.transparent.withValues(alpha: opacity);

    // Warm skin tone overlay
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = const Color(0xFFFFE0CC).withValues(alpha: opacity * 0.4)
        ..blendMode = BlendMode.softLight,
    );

    // Reduce redness
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = const Color(0xFFFFE4D6).withValues(alpha: opacity * 0.3)
        ..blendMode = BlendMode.luminosity,
    );
  }

  void _applyGlowEffect(Canvas canvas, Size size) {
    if (progress < 0.5) return;
    final glowOpacity = (progress - 0.5) * 2.0 * 0.15;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = Colors.white.withValues(alpha: glowOpacity)
        ..blendMode = BlendMode.overlay,
    );
  }

  List<double> _buildCorrectionMatrix() {
    // Color matrix: [R, G, B, A adjustments]
    // Progressively even skin tone and reduce spots
    final t = progress;
    return [
      1.0 + (t * 0.05), 0, 0, 0, t * 5,
      0, 1.0 + (t * 0.03), 0, 0, t * 3,
      0, 0, 1.0 - (t * 0.02), 0, t * 2,
      0, 0, 0, 1, 0,
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
