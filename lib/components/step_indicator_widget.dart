import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'step_indicator_model.dart';
export 'step_indicator_model.dart';

class StepIndicatorWidget extends StatefulWidget {
  const StepIndicatorWidget({
    super.key,
    String? text,
    bool? active,
  })  : text = text ?? 'Setup',
        active = active ?? true;

  final String text;
  final bool active;

  @override
  State<StepIndicatorWidget> createState() => _StepIndicatorWidgetState();
}

class _StepIndicatorWidgetState extends State<StepIndicatorWidget> {
  late StepIndicatorModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StepIndicatorModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: widget.active
                ? FlutterFlowTheme.of(context).tertiary
                : FlutterFlowTheme.of(context).onPrimary30,
            borderRadius: BorderRadius.circular(50.0),
            shape: BoxShape.rectangle,
          ),
        ),
        Text(
          valueOrDefault<String>(
            widget.text,
            'Setup',
          ),
          style: FlutterFlowTheme.of(context).labelSmall.override(
                font: GoogleFonts.dmSans(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                ),
                color: widget.active
                    ? FlutterFlowTheme.of(context).tertiary
                    : FlutterFlowTheme.of(context).onPrimary60,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                lineHeight: 1.27,
              ),
        ),
      ].divide(const SizedBox(height: 4.0)),
    );
  }
}
