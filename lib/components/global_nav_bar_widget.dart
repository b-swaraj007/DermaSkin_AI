import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'global_nav_bar_model.dart';
export 'global_nav_bar_model.dart';

/// Reusable bottom navigation bar for the DermaskinAI app.
///
/// Presents the standard Home · Reports · Camera (center) · History ·
/// Profile entry points. Pass the caller's route via [currentRoute] so the
/// active item can be highlighted with the primary color.
///
/// Typical integration:
///
/// ```dart
/// Stack(
///   children: [
///     // ... page body ...
///     const Align(
///       alignment: AlignmentDirectional(0.0, 1.0),
///       child: GlobalNavBarWidget(currentRoute: '/homeDashboard'),
///     ),
///   ],
/// )
/// ```
class GlobalNavBarWidget extends StatefulWidget {
  const GlobalNavBarWidget({
    super.key,
    this.currentRoute,
  });

  /// The route path of the screen that embeds this nav bar. Used to render
  /// the active item in the primary color. Pass `null` for no highlight.
  final String? currentRoute;

  @override
  State<GlobalNavBarWidget> createState() => _GlobalNavBarWidgetState();
}

class _GlobalNavBarWidgetState extends State<GlobalNavBarWidget> {
  late GlobalNavBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GlobalNavBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Color _iconColor(String route) {
    final isActive = widget.currentRoute == route;
    return isActive
        ? FlutterFlowTheme.of(context).primary
        : FlutterFlowTheme.of(context).secondaryText;
  }

  void _navigate(String route) {
    if (widget.currentRoute == route) return;
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
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
            padding:
                const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            child: SizedBox(
              height: 89.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    fillColor: Colors.transparent,
                    icon: Icon(
                      Icons.home_outlined,
                      color: _iconColor('/homeDashboard'),
                      size: 24.0,
                    ),
                    onPressed: () => _navigate('/homeDashboard'),
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    fillColor: Colors.transparent,
                    icon: Icon(
                      Icons.assessment_outlined,
                      color: _iconColor('/skinReport'),
                      size: 24.0,
                    ),
                    onPressed: () => _navigate('/skinReport'),
                  ),
                  GestureDetector(
                    onTap: () => context.push(
                      '/preScanSetup',
                      extra: {
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.bottomToTop,
                          duration: Duration(milliseconds: 300),
                        ),
                      },
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 20.0),
                      child: Container(
                        width: 56.0,
                        height: 56.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(50.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Icon(
                          Icons.center_focus_strong_rounded,
                          color: FlutterFlowTheme.of(context).onPrimary,
                          size: 28.0,
                        ),
                      ),
                    ),
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    fillColor: Colors.transparent,
                    icon: Icon(
                      Icons.insights_rounded,
                      color: _iconColor('/progressTracker'),
                      size: 24.0,
                    ),
                    onPressed: () => _navigate('/progressTracker'),
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    fillColor: Colors.transparent,
                    icon: Icon(
                      Icons.person_outline_rounded,
                      color: _iconColor('/userProfileSettings'),
                      size: 24.0,
                    ),
                    onPressed: () => _navigate('/userProfileSettings'),
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
