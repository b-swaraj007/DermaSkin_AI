import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'insight_pill_model.dart';
export 'insight_pill_model.dart';

class InsightPillWidget extends StatefulWidget {
  const InsightPillWidget({
    super.key,
    this.color,
    this.icon,
    String? text,
  })  : text = text ?? 'Pore congestion increased';

  final Color? color;
  final Widget? icon;
  final String text;

  @override
  State<InsightPillWidget> createState() => _InsightPillWidgetState();
}

class _InsightPillWidgetState extends State<InsightPillWidget> {
  late InsightPillModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InsightPillModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(50.0),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 16.0),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.icon!,
                  Text(
                    valueOrDefault<String>(
                      widget.text,
                      'Pore congestion increased',
                    ),
                    maxLines: 1,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.dmSans(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                          lineHeight: 1.38,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ].divide(const SizedBox(width: 8.0)),
              ),
            ),
          ),
    );
  }
}
