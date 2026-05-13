// ---------------------------------------------------------------------------
// ArTreatmentPreviewWidget  ·  "View Skin After Treatment Preview"
// ---------------------------------------------------------------------------
// Renders the Unity `TreatmentPreview` scene. The Unity side (see
// `unity/DermaScanAR/Assets/Scripts/TreatmentPreviewController.cs` and
// `Shaders/SkinSmoothing.shader`) applies a configurable skin-smoothing
// shader whose strength per-parameter is derived from the current scan
// scores. The Flutter side exposes:
//
//   - A before/after slider bound to Unity's `_BlendAmount` uniform.
//   - A "Play transition" button that animates 0 → 1 over N seconds.
//   - A snapshot button routed through `UnityBridge.requestSnapshot`.
//
// Like the problem-zones screen, this widget is resilient to Unity not
// being attached yet: the Flutter overlay remains functional while the
// Unity `onUnityCreated` callback wires up the controller lazily.
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/skin_analyzer.dart';
import '/services/unity_bridge.dart';

// Note: the `flutter_unity_widget` import is disabled until the Unity
// Android library has been exported to `android/unityLibrary/`. The Flutter
// side (slider, play button, snapshot, bridge listeners) continues to
// operate so the screen stays demo-ready.

class ArTreatmentPreviewWidget extends StatefulWidget {
  const ArTreatmentPreviewWidget({super.key, this.results});

  static const String routeName = 'ArTreatmentPreview';
  static const String routePath = '/arTreatmentPreview';

  final Map<String, SkinParameterResult>? results;

  @override
  State<ArTreatmentPreviewWidget> createState() =>
      _ArTreatmentPreviewWidgetState();
}

class _ArTreatmentPreviewWidgetState extends State<ArTreatmentPreviewWidget>
    with SingleTickerProviderStateMixin {
  VoidCallback? _unsubscribe;
  AnimationController? _transition;

  double _blend = 0.0;
  bool _unityReady = false;
  String _status = 'Initializing Unity AR…';

  Map<String, SkinParameterResult>? get _results => widget.results;

  @override
  void initState() {
    super.initState();
    _unsubscribe = UnityBridge.instance.addListener(_onUnityEvent);
    _transition = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addListener(() {
        final v = _transition!.value;
        setState(() => _blend = v);
        UnityBridge.instance.setTreatmentBlend(v);
      });
  }

  @override
  void dispose() {
    _unsubscribe?.call();
    _transition?.dispose();
    UnityBridge.instance.detach();
    super.dispose();
  }

  void _onUnityEvent(UnityBridgeEvent event) {
    if (!mounted) return;
    switch (event.name) {
      case 'ready':
        setState(() {
          _unityReady = true;
          _status = 'Align your face with the camera';
        });
        _pushResultsToUnity();
        break;
      case 'faceFound':
        setState(() => _status = 'Tracking — drag the slider to preview');
        break;
      case 'faceLost':
        setState(() => _status = 'Face lost — reposition to continue');
        break;
      case 'snapshotTaken':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Snapshot captured')),
        );
        break;
    }
  }

  // ignore: unused_element
  Future<void> _onUnityCreated(Object controller) async {
    UnityBridge.instance.attach(controller);
    try {
      final dynamic c = controller;
      await c.postMessage('FlutterBridge', 'OnFlutterMessage',
          '{"event":"loadScene","scene":"TreatmentPreview"}');
    } catch (_) {}
    _pushResultsToUnity();
  }

  Future<void> _pushResultsToUnity() async {
    final r = _results;
    if (r == null || r.isEmpty) return;
    try {
      await UnityBridge.instance.sendTreatmentPreview(r,
          transitionSeconds: 2.5);
      await UnityBridge.instance.setTreatmentBlend(_blend);
    } catch (_) {}
  }

  void _playTransition() {
    if (_transition == null) return;
    if (_transition!.isAnimating) {
      _transition!.stop();
      return;
    }
    if (_transition!.value >= 0.999) {
      _transition!.reverse();
    } else {
      _transition!.forward(from: _transition!.value);
    }
  }

  Future<void> _takeSnapshot() async {
    await UnityBridge.instance.requestSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildUnitySurfacePlaceholder(),
          ),
          if (!_unityReady) _buildBootOverlay(),
          SafeArea(child: _buildTopBar(context)),
          Positioned(
            right: 16,
            bottom: 300,
            child: _buildSnapshotButton(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomPanel(context),
          ),
        ],
      ),
    );
  }

  /// Placeholder rendered in place of `UnityWidget` while the Unity
  /// Android library has not been exported. The before/after slider and
  /// play button below still drive `UnityBridge.setTreatmentBlend(...)`
  /// so the full interaction model is demonstrable end-to-end.
  Widget _buildUnitySurfacePlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A1628), Color(0xFF1E4A5F), Color(0xFF0A1628)],
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_fix_high_rounded,
              size: 120, color: Colors.white.withAlpha(70)),
          const SizedBox(height: 20),
          Text('Unity Treatment Preview',
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Blend: ${(_blend * 100).round()}%   — slider still drives '
              'the Unity bridge.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                  color: Colors.white.withAlpha(170), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBootOverlay() {
    return Container(
      color: const Color(0xFF0A1628),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_fix_high_rounded,
              size: 96, color: Colors.white.withAlpha(120)),
          const SizedBox(height: 16),
          Text(
            _status,
            style: GoogleFonts.dmSans(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const SizedBox(
            width: 160,
            child: LinearProgressIndicator(minHeight: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.safePop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(120),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.close_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withAlpha(230),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              _unityReady ? 'TREATMENT PREVIEW' : 'PREPARING AR',
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSnapshotButton() {
    return GestureDetector(
      onTap: _takeSnapshot,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: const Icon(Icons.camera_alt_rounded,
            color: Color(0xFF0D5C63), size: 24),
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'After Treatment Preview',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.cormorantGaramond(
                      fontWeight: FontWeight.bold),
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Drag the slider or tap Play to preview your skin after 4 weeks '
            'of the recommended routine.',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.dmSans(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Before',
                  style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: FlutterFlowTheme.of(context).secondaryText)),
              Expanded(
                child: Slider(
                  value: _blend,
                  onChanged: (v) {
                    setState(() => _blend = v);
                    UnityBridge.instance.setTreatmentBlend(v);
                  },
                  activeColor: FlutterFlowTheme.of(context).primary,
                ),
              ),
              Text('After',
                  style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: FlutterFlowTheme.of(context).secondaryText)),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _playTransition,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary,
                borderRadius: BorderRadius.circular(50),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _transition?.isAnimating == true
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: FlutterFlowTheme.of(context).onPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _transition?.isAnimating == true
                        ? 'Pause Transition'
                        : 'Play Transition',
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          font: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w600),
                          color: FlutterFlowTheme.of(context).onPrimary,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
