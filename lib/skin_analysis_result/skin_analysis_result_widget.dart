import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/ar_features/ar_camera_screen.dart';
import '/ar_features/skin_zone_overlay_painter.dart';
import '/ar_features/treatment_painter.dart';
import '/components/parameter_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'skin_analysis_result_model.dart';
export 'skin_analysis_result_model.dart';

/// Result screen shown after the guided multi-angle AR scan completes.
/// This hosts the "Scanning Parameters" UI that used to live as a bottom
/// sheet inside the AR scanning screen. Showing it here keeps the scanning
/// experience distraction-free.
class SkinAnalysisResultWidget extends StatefulWidget {
  const SkinAnalysisResultWidget({
    super.key,
    this.capturedPaths = const {},
  });

  static const String routeName = 'SkinAnalysisResult';
  static const String routePath = '/skinAnalysisResult';

  /// Map of angle key -> file path of the captured still image.
  /// Example: { 'front': '/tmp/front.jpg', 'left': ..., 'right': ... }
  final Map<String, String> capturedPaths;

  @override
  State<SkinAnalysisResultWidget> createState() =>
      _SkinAnalysisResultWidgetState();
}

class _SkinAnalysisResultWidgetState extends State<SkinAnalysisResultWidget> {
  late SkinAnalysisResultModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Placeholder score — real pipelines should compute this from captured
  // images in isolates and pass it in.
  static const double _overallScore = 0.68;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SkinAnalysisResultModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.background97,
      appBar: AppBar(
        backgroundColor: theme.background97,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => context.safePop(),
        ),
        title: Text(
          'Skin Analysis',
          style: theme.titleMedium.override(
            font: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.bold),
            color: theme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.capturedPaths.isNotEmpty) ...[
                _buildCaptureStrip(),
                const SizedBox(height: 20),
              ],
              _buildHeader(theme),
              const SizedBox(height: 20),
              _buildParameterGrid(theme),
              const SizedBox(height: 20),
              _buildArCta(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureStrip() {
    const angles = ['front', 'left', 'right'];
    return SizedBox(
      height: 96,
      child: Row(
        children: [
          for (final a in angles)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildThumbnail(a, widget.capturedPaths[a]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String label, String? path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (path != null)
            Image.file(File(path), fit: BoxFit.cover)
          else
            Container(color: Colors.black12),
          Positioned(
            left: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scanning Parameters',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.titleMedium.override(
                  font:
                      GoogleFonts.cormorantGaramond(fontWeight: FontWeight.bold),
                  color: theme.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Analysis complete — review your scores',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.bodySmall.override(
                  font: GoogleFonts.dmSans(),
                  color: theme.secondaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${(_overallScore * 100).toInt()}%',
          style: theme.titleMedium.override(
            font: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.bold),
            color: theme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildParameterGrid(FlutterFlowTheme theme) {
    // Rows of two cards each, mirroring the original bottom-panel layout.
    final cards = <Widget>[
      _card(_model.parameterCardModel1, theme.error, 'Acne', 0.12, '12'),
      _card(_model.parameterCardModel2, theme.primary, 'Pores', 0.45, '45'),
      _card(_model.parameterCardModel3, theme.success, 'Moisture', 0.78, '78'),
      _card(_model.parameterCardModel4, theme.tertiary, 'Wrinkles', 0.22, '22'),
      _card(_model.parameterCardModel5, theme.tertiary, 'Pigmentation', 0.35,
          '35'),
      _card(
          _model.parameterCardModel6, theme.tertiary, 'UV Damage', 0.55, '55'),
      _card(_model.parameterCardModel7, theme.error, 'Redness', 0.18, '18'),
      _card(_model.parameterCardModel8, theme.success, 'Texture', 0.72, '72'),
      _card(_model.parameterCardModel9, theme.primary, 'Skin Age', 0.30, '0',
          pending: true),
    ];

    final rows = <Widget>[];
    for (var i = 0; i < cards.length; i += 2) {
      final left = Expanded(child: cards[i]);
      final right = i + 1 < cards.length
          ? Expanded(child: cards[i + 1])
          : const Expanded(child: SizedBox());
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            left,
            const SizedBox(width: 10),
            right,
          ]),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _card(
    ParameterCardModel model,
    Color color,
    String name,
    double progress,
    String value, {
    bool pending = false,
  }) {
    return wrapWithModel(
      model: model,
      updateCallback: () => safeSetState(() {}),
      child: ParameterCardWidget(
        color: color,
        name: name,
        progress: progress,
        value: value,
        is_pending: pending,
      ),
    );
  }

  // --- AR integration -------------------------------------------------------

  /// Translate the current parameter scores into `SkinZoneIssue` entries that
  /// the MediaPipe overlay can render on the live camera feed.
  List<SkinZoneIssue> _buildDetectedIssues() {
    SkinZoneIssue? issue(String zone, String label, double score,
        {bool higherIsBetter = false}) {
      // For negative parameters (acne, wrinkles…) higher score means worse.
      // For positive parameters (moisture, texture…) invert the score so the
      // severity scale is consistent.
      final severityScore = higherIsBetter ? (1.0 - score) : score;
      if (severityScore < 0.15) return null; // skip near-clean zones

      final IssueSeverity severity;
      if (severityScore >= 0.5) {
        severity = IssueSeverity.high;
      } else if (severityScore >= 0.3) {
        severity = IssueSeverity.medium;
      } else {
        severity = IssueSeverity.low;
      }
      return SkinZoneIssue(
          zoneName: zone, issueLabel: label, severity: severity);
    }

    final issues = <SkinZoneIssue?>[
      issue('forehead', 'Wrinkles', 0.22),
      issue('forehead', 'UV Damage', 0.55),
      issue('nose', 'Large Pores', 0.45),
      issue('leftCheek', 'Pigmentation', 0.35),
      issue('rightCheek', 'Redness', 0.18),
      issue('chin', 'Acne', 0.12),
      issue('leftUnderEye', 'Texture', 0.72, higherIsBetter: true),
    ].whereType<SkinZoneIssue>().toList();

    return issues;
  }

  Widget _buildArCta(FlutterFlowTheme theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ARCameraScreen(
                detectedIssues: _buildDetectedIssues(),
                treatmentConfig: const TreatmentConfig(
                  rednessReduction: 0.7,
                  brightnessBoost: 0.5,
                  pigmentationCorrection: 0.55,
                  wrinkleSmoothing: 0.4,
                ),
                initialMode: ARMode.skinZones,
              ),
            ),
          );
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'View in AR',
                      style: theme.titleSmall.override(
                        font: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'See problem zones and preview treatment results live',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodySmall.override(
                        font: GoogleFonts.dmSans(),
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
