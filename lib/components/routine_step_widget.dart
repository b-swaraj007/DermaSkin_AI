import '/components/button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routine_step_model.dart';
export 'routine_step_model.dart';

// ignore_for_file: non_constant_identifier_names

class RoutineStepWidget extends StatefulWidget {
  const RoutineStepWidget({
    super.key,
    String? category,
    String? description,
    String? img_desc,
    bool? is_expanded,
    String? product_name,
    String? time,
    bool? completed,
    bool? is_last,
  })  : category = category ?? 'Cleansing',
        description = description ??
            'Start with a clean base. Gently massage into damp skin for 60 seconds.',
        img_desc = img_desc ??
            'https://dimg.dreamflow.cloud/v1/image/white%20bottle%20of%20facial%20cleanser',
        is_expanded = is_expanded ?? false,
        product_name = product_name ?? 'Gentle Cleanser',
        time = time ?? '07:30 AM',
        completed = completed ?? true,
        is_last = is_last ?? false;

  final String category;
  final String description;
  final String img_desc;
  final bool is_expanded;
  final String product_name;
  final String time;
  final bool completed;
  final bool is_last;

  @override
  State<RoutineStepWidget> createState() => _RoutineStepWidgetState();
}

class _RoutineStepWidgetState extends State<RoutineStepWidget> {
  late RoutineStepModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RoutineStepModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                color: widget.completed
                    ? FlutterFlowTheme.of(context).success
                    : FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(50.0),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: widget.completed
                      ? FlutterFlowTheme.of(context).success
                      : FlutterFlowTheme.of(context).alternate,
                  width: widget.completed ? 2.0 : 2.0,
                ),
              ),
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: SizedBox(
                width: 14.0,
                height: 14.0,
                child: Stack(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  children: [
                    if (widget.completed ? true : false)
                      Icon(
                        Icons.check_rounded,
                        color: widget.completed
                            ? FlutterFlowTheme.of(context).onSurface
                            : FlutterFlowTheme.of(context).alternate,
                        size: 14.0,
                      ),
                    if (widget.completed ? false : true)
                      Icon(
                        Icons.circle_rounded,
                        color: widget.completed
                            ? FlutterFlowTheme.of(context).onSurface
                            : FlutterFlowTheme.of(context).alternate,
                        size: 14.0,
                      ),
                  ],
                ),
              ),
            ),
            if (widget.is_last ? false : true)
              Container(
                width: 2.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  shape: BoxShape.rectangle,
                ),
              ),
          ],
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
            child: Container(
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(20.0),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                width: 56.0,
                                height: 56.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(16.0),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: CachedNetworkImage(
                                      fadeInDuration: const Duration(milliseconds: 0),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 0),
                                      imageUrl: valueOrDefault<String>(
                                        widget.img_desc,
                                        'https://dimg.dreamflow.cloud/v1/image/white%20bottle%20of%20facial%20cleanser',
                                      ),
                                      fit: BoxFit.contain,
                                      alignment: const Alignment(0.0, 0.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    valueOrDefault<String>(
                                      widget.time,
                                      '07:30 AM',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          font: GoogleFonts.dmSans(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelSmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                          lineHeight: 1.27,
                                        ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      widget.product_name,
                                      'Gentle Cleanser',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.cormorantGaramond(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                          lineHeight: 1.35,
                                        ),
                                  ),
                                ].divide(const SizedBox(height: 4.0)),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 20.0,
                            ),
                          ].divide(const SizedBox(width: 16.0)),
                        ),
                        if (valueOrDefault<bool>(
                          widget.is_expanded,
                          false,
                        ))
                          Container(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Divider(
                                      height: 16.0,
                                      thickness: 1.0,
                                      indent: 0.0,
                                      endIndent: 0.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                    Text(
                                      valueOrDefault<String>(
                                        widget.description,
                                        'Start with a clean base. Gently massage into damp skin for 60 seconds.',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.dmSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
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
                                            lineHeight: 1.4,
                                          ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 34.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 1.0,
                                            ),
                                          ),
                                          alignment:
                                              const AlignmentDirectional(0.0, 0.0),
                                          child: Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(
                                                    widget.category,
                                                    'Cleansing',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.dmSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontStyle,
                                                        lineHeight: 1.38,
                                                      ),
                                                ),
                                              ].divide(const SizedBox(width: 6.0)),
                                            ),
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.buttonModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const ButtonWidget(
                                            content: 'Check-In',
                                            iconPresent: false,
                                            iconEndPresent: false,
                                            radius: 50.0,
                                            variant: 'primary',
                                            size: 'small',
                                            fullWidth: false,
                                            loading: false,
                                            disabled: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ].divide(const SizedBox(height: 8.0)),
                                ),
                              ),
                            ),
                          ),
                      ].divide(const SizedBox(height: 8.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ].divide(const SizedBox(width: 16.0)),
    );
  }
}
