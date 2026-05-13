import '/components/button_widget.dart';
import '/components/parameter_card2_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/ar_features/ar_camera_screen.dart';
import '/ar_features/skin_zone_overlay_painter.dart';
import '/ar_features/treatment_painter.dart';
import '/personalized_recommendations/personalized_recommendations_widget.dart';
import '/services/skin_analyzer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'skin_report_model.dart';
export 'skin_report_model.dart';

class SkinReportWidget extends StatefulWidget {
  const SkinReportWidget({super.key, this.results});

  /// Optional result map. When null, the page renders its legacy hardcoded
  /// preview so existing navigation (e.g. the bottom nav bar tapping
  /// "Reports") keeps working.
  final Map<String, SkinParameterResult>? results;

  static String routeName = 'SkinReport';
  static String routePath = '/skinReport';

  @override
  State<SkinReportWidget> createState() => _SkinReportWidgetState();
}

class _SkinReportWidgetState extends State<SkinReportWidget> {
  late SkinReportModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, SkinParameterResult>? get _results => widget.results;

  /// Convert SkinParameterResult scores to SkinZoneIssue list for ARCameraScreen.
  List<SkinZoneIssue> _convertResultsToIssues() {
    final r = _results;
    if (r == null || r.isEmpty) return [];

    // Helper: map a [score 0-100] to an [IssueSeverity], where [higherIsBetter]
    // indicates whether a higher score means healthier skin.
    IssueSeverity? scoreToSeverity(double score, {bool higherIsBetter = false}) {
      final normalized = score / 100; // 0.0 = worst, 1.0 = best
      final severityScore = higherIsBetter ? (1.0 - normalized) : normalized;
      if (severityScore < 0.15) return null;
      if (severityScore >= 0.5) return IssueSeverity.high;
      if (severityScore >= 0.3) return IssueSeverity.medium;
      return IssueSeverity.low;
    }

    final issues = <SkinZoneIssue?>[];

    // Wrinkles → forehead & under-eyes
    if (r.containsKey('wrinkles')) {
      final s = scoreToSeverity(r['wrinkles']!.score);
      if (s != null) {
        issues.add(SkinZoneIssue(zoneName: 'forehead', issueLabel: 'Wrinkles', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'leftUnderEye', issueLabel: 'Fine Lines', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'rightUnderEye', issueLabel: 'Fine Lines', severity: s));
      }
    }

    // UV Damage → forehead
    if (r.containsKey('uv_damage')) {
      final s = scoreToSeverity(r['uv_damage']!.score);
      if (s != null) {
        issues.add(SkinZoneIssue(zoneName: 'forehead', issueLabel: 'UV Damage', severity: s));
      }
    }

    // Pores → nose & jawline
    if (r.containsKey('pores')) {
      final s = scoreToSeverity(r['pores']!.score);
      if (s != null) {
        issues.add(SkinZoneIssue(zoneName: 'nose', issueLabel: 'Large Pores', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'leftJaw', issueLabel: 'Congestion', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'rightJaw', issueLabel: 'Congestion', severity: s));
      }
    }

    // Pigmentation → cheeks
    if (r.containsKey('pigmentation')) {
      final s = scoreToSeverity(r['pigmentation']!.score);
      if (s != null) {
        issues.add(SkinZoneIssue(zoneName: 'leftCheek', issueLabel: 'Spots', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'rightCheek', issueLabel: 'Spots', severity: s));
      }
    }

    // Redness → nose & cheeks
    if (r.containsKey('redness')) {
      final s = scoreToSeverity(r['redness']!.score);
      if (s != null) {
        issues.add(SkinZoneIssue(zoneName: 'nose', issueLabel: 'Redness', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'leftCheek', issueLabel: 'Redness', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'rightCheek', issueLabel: 'Redness', severity: s));
      }
    }

    // Moisture → cheeks (higher is better)
    if (r.containsKey('skin_type_moisture')) {
      final s = scoreToSeverity(r['skin_type_moisture']!.score, higherIsBetter: true);
      if (s != null) {
        issues.add(SkinZoneIssue(zoneName: 'leftCheek', issueLabel: 'Dryness', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'rightCheek', issueLabel: 'Dryness', severity: s));
      }
    }

    // Texture → chin & under-eyes (higher is better)
    if (r.containsKey('texture')) {
      final s = scoreToSeverity(r['texture']!.score, higherIsBetter: true);
      if (s != null) {
        issues.add(SkinZoneIssue(zoneName: 'chin', issueLabel: 'Texture', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'leftUnderEye', issueLabel: 'Texture', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'rightUnderEye', issueLabel: 'Texture', severity: s));
      }
    }

    // Elasticity → chin & jaw (higher is better)
    if (r.containsKey('elasticity')) {
      final s = scoreToSeverity(r['elasticity']!.score, higherIsBetter: true);
      if (s != null) {
        issues.add(SkinZoneIssue(zoneName: 'chin', issueLabel: 'Sagging', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'leftJaw', issueLabel: 'Sagging', severity: s));
        issues.add(SkinZoneIssue(zoneName: 'rightJaw', issueLabel: 'Sagging', severity: s));
      }
    }

    return issues.whereType<SkinZoneIssue>().toList();
  }

  /// Derive a TreatmentConfig from scan results so the AR treatment overlay
  /// has meaningful default strengths.
  TreatmentConfig _deriveTreatmentConfig() {
    final r = _results;
    if (r == null || r.isEmpty) {
      return const TreatmentConfig();
    }

    // Higher score = healthier skin = less treatment needed.
    // Treatment strength is inverse: (100 - score) / 100.
    double inverse(double score) => ((100 - score) / 100).clamp(0.0, 1.0);

    return TreatmentConfig(
      rednessReduction: r.containsKey('redness') ? inverse(r['redness']!.score) : 0.6,
      brightnessBoost: r.containsKey('skin_type_moisture') ? inverse(r['skin_type_moisture']!.score) : 0.4,
      pigmentationCorrection: r.containsKey('pigmentation') ? inverse(r['pigmentation']!.score) : 0.5,
      wrinkleSmoothing: r.containsKey('wrinkles') ? inverse(r['wrinkles']!.score) : 0.3,
    );
  }

  /// Average of all nine parameter scores, 0 if no data.
  double get _overallScore {
    final r = _results;
    if (r == null || r.isEmpty) return 0;
    return r.values.map((v) => v.score).reduce((a, b) => a + b) / r.length;
  }

  String _overallLabel(double score) {
    if (score >= 80) return 'Excellent Skin Health';
    if (score >= 65) return 'Good Skin Health';
    if (score >= 50) return 'Fair Skin Health';
    return 'Needs Attention';
  }

  Future<void> _shareReport() async {
    final r = _results;
    if (r == null || r.isEmpty) return;
    try {
      final buffer = StringBuffer()
        ..writeln('DermaScan AI — Skin Report')
        ..writeln('Overall Score: ${_overallScore.toInt()}/100')
        ..writeln();
      for (final v in r.values) {
        buffer.writeln('${v.parameter}: ${v.severity} (${v.scoreInt}/100)');
      }
      await Share.share(buffer.toString());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to share: $e')),
      );
    }
  }

  void _openRecommendations() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PersonalizedRecommendationsWidget(results: _results),
      ),
    );
  }

  void _openProblemZonesAr() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ARCameraScreen(
          detectedIssues: _convertResultsToIssues(),
          treatmentConfig: _deriveTreatmentConfig(),
          initialMode: ARMode.skinZones,
        ),
      ),
    );
  }

  void _openTreatmentPreviewAr() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ARCameraScreen(
          detectedIssues: _convertResultsToIssues(),
          treatmentConfig: _deriveTreatmentConfig(),
          initialMode: ARMode.treatmentPreview,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SkinReportModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          alignment: const AlignmentDirectional(-1.0, -1.0),
          children: [
            SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 160.0),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 24.0, 24.0, 16.0),
                              child: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FlutterFlowIconButton(
                                      borderRadius: 8.0,
                                      buttonSize: 40.0,
                                      fillColor: Colors.transparent,
                                      icon: Icon(
                                        Icons.arrow_back_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 24.0,
                                      ),
                                      onPressed: () => context.safePop(),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your Skin Report',
                                          style: FlutterFlowTheme.of(context)
                                              .headlineMedium
                                              .override(
                                                font: GoogleFonts
                                                    .cormorantGaramond(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMedium
                                                        .fontStyle,
                                                lineHeight: 1.25,
                                              ),
                                        ),
                                        Text(
                                          'Scanned on April 22, 2026',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.dmSans(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                                lineHeight: 1.38,
                                              ),
                                        ),
                                      ].divide(const SizedBox(height: 4.0)),
                                    ),
                                  ].divide(const SizedBox(height: 16.0)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 24.0),
                            child: Container(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(24.0),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Container(
                                    child: Container(
                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 120.0,
                                            height: 120.0,
                                            child: Stack(
                                              alignment: const AlignmentDirectional(
                                                  -1.0, -1.0),
                                              children: [
                                                CircularPercentIndicator(
                                                  percent: _results != null
                                                      ? (_overallScore / 100)
                                                          .clamp(0.0, 1.0)
                                                      : 0.74,
                                                  radius: 60.0,
                                                  lineWidth: 8.0,
                                                  animation: true,
                                                  animateFromLastPercent: true,
                                                  progressColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .tertiary,
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                ),
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.09, -0.04),
                                                  child: Text(
                                                    _results != null
                                                        ? '${_overallScore.toInt()}/100'
                                                        : '74/100',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .cormorantGaramond(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.25,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            _results != null
                                                ? _overallLabel(_overallScore)
                                                : 'Good Skin Health',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts
                                                      .cormorantGaramond(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                  lineHeight: 1.35,
                                                ),
                                          ),
                                        ].divide(const SizedBox(height: 16.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 24.0),
                            child: GestureDetector(
                              onTap: () => _openProblemZonesAr(),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 14.0, 20.0, 14.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.view_in_ar_rounded,
                                        color: FlutterFlowTheme.of(context).primary,
                                        size: 20.0,
                                      ),
                                      Text(
                                        'View Problem Zones in AR',
                                        style: FlutterFlowTheme.of(context).labelLarge.override(
                                          font: GoogleFonts.dmSans(
                                            fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context).primary,
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                        ),
                                      ),
                                    ].divide(const SizedBox(width: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                wrapWithModel(
                                  model: _model.parameterCard2Model1,
                                  updateCallback: () => safeSetState(() {}),
                                  child: GestureDetector(
                                    onTap: () => context.push('/skinReportDetail'),
                                    child: ParameterCard2Widget(
                                    badge_bg:
                                        FlutterFlowTheme.of(context).success15,
                                    badge_color:
                                        FlutterFlowTheme.of(context).success,
                                    badge_text: 'Good',
                                    icon: Icon(
                                      Icons.water_drop,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    icon_color:
                                        FlutterFlowTheme.of(context).primary,
                                    reading: 'Combination • 62% hydrated',
                                    title: 'Skin Type & Moisture',
                                  ),
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.parameterCard2Model2,
                                  updateCallback: () => safeSetState(() {}),
                                  child: GestureDetector(
                                    onTap: () => context.push('/skinReportDetail'),
                                    child: ParameterCard2Widget(
                                    badge_bg:
                                        FlutterFlowTheme.of(context).accent15,
                                    badge_color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    badge_text: 'Mild',
                                    icon: Icon(
                                      Icons.face,
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      size: 24.0,
                                    ),
                                    icon_color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    reading: 'Mild visible lines',
                                    title: 'Wrinkles & Fine Lines',
                                  ),
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.parameterCard2Model3,
                                  updateCallback: () => safeSetState(() {}),
                                  child: GestureDetector(
                                    onTap: () => context.push('/skinReportDetail'),
                                    child: ParameterCard2Widget(
                                    badge_bg:
                                        FlutterFlowTheme.of(context).accent15,
                                    badge_color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    badge_text: 'Moderate',
                                    icon: Icon(
                                      Icons.grain,
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      size: 24.0,
                                    ),
                                    icon_color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    reading: 'Moderate sun spots',
                                    title: 'Pigmentation & Spots',
                                  ),
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.parameterCard2Model4,
                                  updateCallback: () => safeSetState(() {}),
                                  child: GestureDetector(
                                    onTap: () => context.push('/skinReportDetail'),
                                    child: ParameterCard2Widget(
                                    badge_bg:
                                        FlutterFlowTheme.of(context).error15,
                                    badge_color:
                                        FlutterFlowTheme.of(context).error,
                                    badge_text: 'Action',
                                    icon: Icon(
                                      Icons.texture,
                                      color: FlutterFlowTheme.of(context).error,
                                      size: 24.0,
                                    ),
                                    icon_color:
                                        FlutterFlowTheme.of(context).error,
                                    reading: 'Congested around T-zone',
                                    title: 'Pore Size & Congestion',
                                  ),
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.parameterCard2Model5,
                                  updateCallback: () => safeSetState(() {}),
                                  child: GestureDetector(
                                    onTap: () => context.push('/skinReportDetail'),
                                    child: ParameterCard2Widget(
                                    badge_bg:
                                        FlutterFlowTheme.of(context).success15,
                                    badge_color:
                                        FlutterFlowTheme.of(context).success,
                                    badge_text: 'Healthy',
                                    icon: Icon(
                                      Icons.error_outline,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    icon_color:
                                        FlutterFlowTheme.of(context).primary,
                                    reading: 'Low sensitivity detected',
                                    title: 'Redness & Sensitivity',
                                  ),
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.parameterCard2Model6,
                                  updateCallback: () => safeSetState(() {}),
                                  child: GestureDetector(
                                    onTap: () => context.push('/skinReportDetail'),
                                    child: ParameterCard2Widget(
                                    badge_bg:
                                        FlutterFlowTheme.of(context).accent15,
                                    badge_color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    badge_text: 'Moderate',
                                    icon: Icon(
                                      Icons.wb_sunny,
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      size: 24.0,
                                    ),
                                    icon_color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    reading: 'Moderate exposure',
                                    title: 'UV Damage',
                                  ),
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.parameterCard2Model7,
                                  updateCallback: () => safeSetState(() {}),
                                  child: GestureDetector(
                                    onTap: () => context.push('/skinReportDetail'),
                                    child: ParameterCard2Widget(
                                    badge_bg:
                                        FlutterFlowTheme.of(context).success15,
                                    badge_color:
                                        FlutterFlowTheme.of(context).success,
                                    badge_text: 'Good',
                                    icon: Icon(
                                      Icons.grid_view,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    icon_color:
                                        FlutterFlowTheme.of(context).primary,
                                    reading: 'Good surface uniformity',
                                    title: 'Skin Texture & Smoothness',
                                  ),
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.parameterCard2Model8,
                                  updateCallback: () => safeSetState(() {}),
                                  child: GestureDetector(
                                    onTap: () => context.push('/skinReportDetail'),
                                    child: ParameterCard2Widget(
                                    badge_bg:
                                        FlutterFlowTheme.of(context).success15,
                                    badge_color:
                                        FlutterFlowTheme.of(context).success,
                                    badge_text: 'High',
                                    icon: Icon(
                                      Icons.bolt,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    icon_color:
                                        FlutterFlowTheme.of(context).primary,
                                    reading: 'Good rebound capacity',
                                    title: 'Elasticity & Firmness',
                                  ),
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.parameterCard2Model9,
                                  updateCallback: () => safeSetState(() {}),
                                  child: GestureDetector(
                                    onTap: () => context.push('/skinReportDetail'),
                                    child: ParameterCard2Widget(
                                    badge_bg:
                                        FlutterFlowTheme.of(context).success15,
                                    badge_color:
                                        FlutterFlowTheme.of(context).success,
                                    badge_text: 'Young',
                                    icon: Icon(
                                      Icons.calendar_today,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    icon_color:
                                        FlutterFlowTheme.of(context).primary,
                                    reading: 'Calculated: 26 years',
                                    title: 'True Skin Age',
                                  ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0.0, 1.0),
              child: Container(
                height: 160.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).surface80,
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 1.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        child: SizedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _openProblemZonesAr,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  height: 52,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF0D5C63),
                                        Color(0xFF1A8791),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.view_in_ar_rounded,
                                          color: Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'View Problem Zones in AR',
                                        style: GoogleFonts.dmSans(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _openTreatmentPreviewAr,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: const Color(0xFFC9A84C),
                                      width: 1.5,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.auto_fix_high_rounded,
                                          color: Color(0xFFC9A84C), size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Preview Treatment in AR',
                                        style: GoogleFonts.dmSans(
                                          color: const Color(0xFFC9A84C),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_results != null) {
                                    _openRecommendations();
                                  } else {
                                    context.push(
                                      '/personalizedRecommendations',
                                      extra: {
                                        kTransitionInfoKey: const TransitionInfo(
                                          hasTransition: true,
                                          transitionType: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 300),
                                        ),
                                      },
                                    );
                                  }
                                },
                                child: wrapWithModel(
                                model: _model.buttonModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: const ButtonWidget(
                                  content:
                                      'View Personalized Recommendations →',
                                  iconPresent: false,
                                  iconEndPresent: false,
                                  radius: 50.0,
                                  variant: 'primary',
                                  size: 'large',
                                  fullWidth: true,
                                  loading: false,
                                  disabled: false,
                                ),
                              ),
                              ),
                              GestureDetector(
                                onTap: _shareReport,
                                child: wrapWithModel(
                                model: _model.buttonModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: const ButtonWidget(
                                  content: 'Share Report',
                                  iconPresent: false,
                                  iconEndPresent: false,
                                  radius: 50.0,
                                  variant: 'outline',
                                  size: 'medium',
                                  fullWidth: true,
                                  loading: false,
                                  disabled: false,
                                ),
                              ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Results are AI-estimated and not a clinical '
                                  'diagnosis. Consult a dermatologist for '
                                  'medical advice.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11.0,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ].divide(const SizedBox(height: 12.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
