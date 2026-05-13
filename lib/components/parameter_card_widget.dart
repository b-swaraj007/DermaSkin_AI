import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'parameter_card_model.dart';
export 'parameter_card_model.dart';

// ignore_for_file: non_constant_identifier_names

class ParameterCardWidget extends StatefulWidget {
  const ParameterCardWidget({
    super.key,
    this.color,
    String? name,
    double? progress,
    String? value,
    bool? is_pending,
  })  : name = name ?? 'Acne',
        progress = progress ?? 0.12,
        value = value ?? '12',
        is_pending = is_pending ?? false;

  final Color? color;
  final String name;
  final double progress;
  final String value;
  final bool is_pending;

  @override
  State<ParameterCardWidget> createState() => _ParameterCardWidgetState();
}

class _ParameterCardWidgetState extends State<ParameterCardWidget> {
  late ParameterCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ParameterCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(14.0, 12.0, 12.0, 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Wrapped in Expanded so long labels (e.g. "Pigmentation") never
            // push the progress indicator out of the card's right edge.
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valueOrDefault<String>(
                      widget.name,
                      'Acne',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          font: GoogleFonts.dmSans(
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                          color: widget.is_pending
                              ? FlutterFlowTheme.of(context).secondaryText50
                              : FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                          lineHeight: 1.38,
                        ),
                  ),
                  const SizedBox(height: 6.0),
                  // Evaluate the pending flag directly instead of leaking it
                  // into the rendered string literally.
                  Text(
                    widget.is_pending ? '--' : '${widget.value}%',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.cormorantGaramond(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                          lineHeight: 1.27,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            CircularPercentIndicator(
              percent: valueOrDefault<double>(
                widget.progress,
                0.12,
              ),
              radius: 20.0,
              lineWidth: 4.0,
              animation: true,
              animateFromLastPercent: true,
              progressColor: valueOrDefault<Color>(
                widget.color,
                FlutterFlowTheme.of(context).error,
              ),
              backgroundColor: FlutterFlowTheme.of(context).alternate,
            ),
          ],
        ),
      ),
    );
  }
}
