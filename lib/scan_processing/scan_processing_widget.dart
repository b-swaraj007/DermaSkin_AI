import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/services/hybrid_skin_analyzer.dart';
import '/services/scan_storage.dart';
import '/services/skin_analyzer.dart';
import '/skin_report/skin_report_widget.dart';

/// Full-screen "Analyzing your skin…" stage, sitting between the AR capture
/// flow and the final Skin Report. It simply awaits a future returned by
/// [HybridSkinAnalyzer.analyzeAll] while cycling progress messages and
/// animating a 16-second progress bar for user comfort.
class ScanProcessingWidget extends StatefulWidget {
  const ScanProcessingWidget({super.key, required this.analysisFuture});

  /// Produced by the AR screen; resolves to the 9-parameter result map.
  final Future<Map<String, SkinParameterResult>> analysisFuture;

  static String routeName = 'ScanProcessing';
  static String routePath = '/scanProcessing';

  @override
  State<ScanProcessingWidget> createState() => _ScanProcessingWidgetState();
}

class _ScanProcessingWidgetState extends State<ScanProcessingWidget>
    with SingleTickerProviderStateMixin {
  static const List<String> _statusMessages = [
    'Reading moisture levels...',
    'Detecting pigmentation...',
    'Mapping pore congestion...',
    'Measuring UV damage...',
    'Analyzing wrinkles...',
    'Assessing elasticity...',
    'Evaluating redness...',
    'Calculating texture score...',
    'Estimating skin age...',
  ];

  late final AnimationController _progressController;
  Timer? _messageTimer;
  int _messageIndex = 0;
  bool _failed = false;
  bool _complete = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..forward();

    _messageTimer = Timer.periodic(const Duration(milliseconds: 1800), (_) {
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) % _statusMessages.length;
      });
    });

    _awaitResults();
  }

  Future<void> _awaitResults() async {
    try {
      final results = await widget.analysisFuture;
      if (!mounted) return;

      // Persist to local storage for the progress tracker.
      if (results.isNotEmpty) {
        final overall = results.values
                .map((r) => r.score)
                .fold<double>(0, (a, b) => a + b) /
            results.length;
        unawaited(ScanStorage.instance.saveScan(
          results: results,
          overallScore: overall,
        ));
      }

      _messageTimer?.cancel();
      setState(() => _complete = true);

      await Future<void>.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;

      // Clean up capture buffers before leaving.
      SkinAnalyzer.instance.clearCaptures();
      HybridSkinAnalyzer.instance.clear();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SkinReportWidget(results: results),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _messageTimer?.cancel();
      setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _progressController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: _failed ? _buildFailState(theme) : _buildProgress(theme),
          ),
        ),
      ),
    );
  }

  // ───────────────────── Progress state ─────────────────────

  Widget _buildProgress(FlutterFlowTheme theme) {
    final label = _complete ? 'Analysis Complete!' : _statusMessages[_messageIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Center(
          child: SizedBox(
            width: 140,
            height: 140,
            child: AnimatedBuilder(
              animation: _progressController,
              builder: (context, _) {
                final value = _complete ? 1.0 : _progressController.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 6,
                        backgroundColor: theme.primary.withAlpha(40),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(theme.primary),
                      ),
                    ),
                    Text(
                      '${(value * 100).toInt()}%',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: theme.primary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          _complete ? 'All Done' : 'Analyzing Your Skin',
          textAlign: TextAlign.center,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.primary,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            label,
            key: ValueKey(label),
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: theme.primaryText,
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Please keep your device steady while we process your scan.',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: theme.secondaryText,
          ),
        ),
      ],
    );
  }

  // ───────────────────── Failure state ─────────────────────

  Widget _buildFailState(FlutterFlowTheme theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline_rounded, size: 72, color: theme.error),
        const SizedBox(height: 16),
        Text(
          'Scan Incomplete',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "We couldn't complete your analysis. Please ensure good lighting "
          'and try again.',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(fontSize: 14, color: theme.secondaryText),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: () {
              SkinAnalyzer.instance.clearCaptures();
              HybridSkinAnalyzer.instance.clear();
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Try Again',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
