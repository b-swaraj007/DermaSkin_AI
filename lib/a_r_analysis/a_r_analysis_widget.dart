import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/scan_processing/scan_processing_widget.dart';
import '/widgets/face_ar_overlay.dart';
import 'a_r_analysis_model.dart';
export 'a_r_analysis_model.dart';

/// Guided multi-angle AR face capture screen.
///
/// The UI is intentionally minimal: a fullscreen camera preview with a
/// center face-guide oval, a compact top bar and a single bottom action
/// button. No heavy dashboards live on this screen — the heavy skin
/// analysis happens on [ScanProcessingWidget] right after the third
/// capture completes.
class ARAnalysisWidget extends StatefulWidget {
  const ARAnalysisWidget({super.key});

  static String routeName = 'ARAnalysis';
  static String routePath = '/aRAnalysis';

  @override
  State<ARAnalysisWidget> createState() => _ARAnalysisWidgetState();
}

class _ARAnalysisWidgetState extends State<ARAnalysisWidget> {
  late ARAnalysisModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ARAnalysisModel());

    // Start camera + detection after first frame so MediaQuery is reliable.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _model.initializeCamera(
        context: context,
        onUpdate: () {
          if (mounted) safeSetState(() {});
        },
      );
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Ask the user to confirm before bailing mid-scan.
  Future<void> _confirmExit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Scan?'),
        content: const Text(
          'Your scan progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Continue Scanning'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      _model.cancelScan();
      context.safePop();
    }
  }

  void _onPrimaryAction() {
    if (_model.isCapturing || _model.isAnalyzing) return;
    // Manual override: once a face has been detected we always allow the
    // user to tap Capture. [captureCurrentAngle] internally bails if the
    // camera isn't ready, so this is safe.
    if (_model.isFaceDetected) {
      _model.captureCurrentAngle(() {
        if (!mounted) return;
        safeSetState(() {});

        // When the final angle has just been captured, hand off to the
        // ScanProcessing screen with the analysis future. We do this from
        // the widget (not the model) because navigation needs BuildContext.
        if (_model.isComplete && !_model.isAnalysisComplete) {
          _model.isAnalysisComplete = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ScanProcessingWidget(
                analysisFuture: _model.runAnalysis(),
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final controller = _model.cameraService.controller;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF0A1628),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── LAYER 1: Fullscreen camera feed ──
            if (_model.isCameraReady && controller != null)
              Positioned.fill(child: CameraPreview(controller))
            else
              Container(color: const Color(0xFF0A1628)),

            // Light dim so overlays stay legible without hiding the feed.
            Container(color: const Color(0x22000000)),

            // ── LAYER 2: Lightweight mesh overlay (only when a face exists) ──
            if (_model.isCameraReady &&
                _model.detectedFaces.isNotEmpty &&
                controller?.value.previewSize != null)
              Positioned.fill(
                child: CustomPaint(
                  painter: FaceAROverlayPainter(
                    faces: _model.detectedFaces,
                    imageSize: Size(
                      controller!.value.previewSize!.height,
                      controller.value.previewSize!.width,
                    ),
                    showMesh: true,
                    showDiagnosticZones: false,
                  ),
                ),
              ),

            // ── LAYER 3: Center face-guide oval ──
            _buildFaceGuide(theme),

            // ── LAYER 4: Top bar (back + step pill + torch) ──
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _roundGlassButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: _confirmExit,
                      theme: theme,
                    ),
                    _stepPill(theme),
                    _roundGlassButton(
                      icon: _model.isTorchOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      iconColor: _model.isTorchOn ? theme.tertiary : null,
                      onTap: () => _model.toggleTorch(() {
                        if (mounted) safeSetState(() {});
                      }),
                      theme: theme,
                    ),
                  ],
                ),
              ),
            ),

            // ── LAYER 5: Instruction text just below the top bar ──
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 76),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: _instructionChip(theme),
                ),
              ),
            ),

            // ── LAYER 6: Bottom primary action button ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: _bottomButton(theme),
                ),
              ),
            ),

            // ── LAYER 7: Analyzing overlay (blocks input while ML runs) ──
            if (_model.isAnalyzing) _buildAnalyzingOverlay(theme),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── Overlay helpers ─────────────────────────

  Widget _buildFaceGuide(FlutterFlowTheme theme) {
    // Guide colour reflects alignment state for quick feedback.
    Color border;
    if (_model.isAligned) {
      border = theme.success;
    } else if (_model.isFaceDetected) {
      border = theme.tertiary;
    } else {
      border = Colors.white.withAlpha(140);
    }

    return Align(
      alignment: const Alignment(0, -0.1),
      child: Container(
        width: 260,
        height: 340,
        decoration: BoxDecoration(
          border: Border.all(color: border, width: 2),
          borderRadius: const BorderRadius.all(Radius.elliptical(130, 170)),
          boxShadow: [
            BoxShadow(
              color: border.withAlpha(80),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    required FlutterFlowTheme theme,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.onPrimary20,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: theme.onPrimary30),
            ),
            child: Icon(
              icon,
              color: iconColor ?? theme.onSurface,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepPill(FlutterFlowTheme theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: theme.primary.withAlpha(220),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Step dots: ● ● ○
              for (var i = 0; i < _model.totalSteps; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                _dot(i < _model.currentStepIndex
                    ? theme.success
                    : i == _model.currentStepIndex
                        ? Colors.white
                        : Colors.white.withAlpha(80)),
              ],
              const SizedBox(width: 10),
              Text(
                _model.isAnalysisComplete
                    ? 'Analysis ready'
                    : 'Step ${_model.displayStep} of ${_model.totalSteps} · '
                        '${_model.currentAngle.label}',
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  Widget _instructionChip(FlutterFlowTheme theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(120),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            _model.statusMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomButton(FlutterFlowTheme theme) {
    // Visibility rules:
    //  • During analysis   → disabled spinner look
    //  • After completion  → "View Results" (primary CTA)
    //  • While aligned     → glowing "Capture <angle>" (auto-suggest)
    //  • Face detected     → dim manual-capture fallback
    //  • Otherwise         → hidden (keeps the camera view clean)
    if (_model.isAnalyzing) {
      return _ctaButton(
        label: 'Analyzing…',
        color: theme.primary,
        enabled: false,
        onTap: null,
      );
    }
    if (_model.isAnalysisComplete) {
      return _ctaButton(
        label: 'View Results',
        color: theme.success,
        icon: Icons.insights_rounded,
        onTap: _onPrimaryAction,
      );
    }
    if (_model.isCapturing) {
      return _ctaButton(
        label: 'Capturing…',
        color: theme.primary,
        enabled: false,
        onTap: null,
      );
    }
    if (!_model.isFaceDetected) {
      return const SizedBox(height: 56);
    }
    return _ctaButton(
      label: 'Capture ${_model.currentAngle.label}',
      color: _model.isAligned ? theme.primary : theme.primary.withAlpha(140),
      icon: Icons.camera_alt_rounded,
      onTap: _onPrimaryAction,
    );
  }

  Widget _ctaButton({
    required String label,
    required Color color,
    required VoidCallback? onTap,
    bool enabled = true,
    IconData? icon,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.7,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(80),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzingOverlay(FlutterFlowTheme theme) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withAlpha(160),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 52,
              height: 52,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Analyzing skin…',
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
