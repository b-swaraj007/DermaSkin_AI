import '/components/button_widget.dart';
import '/components/metric_card2_widget.dart';
import '/components/product_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'skin_report_detail_model.dart';
export 'skin_report_detail_model.dart';

class SkinReportDetailWidget extends StatefulWidget {
  const SkinReportDetailWidget({super.key});

  static String routeName = 'SkinReportDetail';
  static String routePath = '/skinReportDetail';

  @override
  State<SkinReportDetailWidget> createState() => _SkinReportDetailWidgetState();
}

class _SkinReportDetailWidgetState extends State<SkinReportDetailWidget> {
  late SkinReportDetailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SkinReportDetailModel());
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
            Image.asset(
              'assets/images/close%20up%20of%20clear%20healthy%20skin%20texture%20with%20soft%20lighting',
              fit: BoxFit.fitHeight,
              alignment: const Alignment(0.0, 0.0),
            ),
            const Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: SizedBox(
                width: 0.0,
                height: 0.0,
              ),
            ),
            SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 60.0, 24.0, 16.0),
                              child: Container(
                                child: Container(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Your',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineLarge
                                                .override(
                                                  font: GoogleFonts
                                                      .cormorantGaramond(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineLarge
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineLarge
                                                          .fontStyle,
                                                  lineHeight: 1.2,
                                                ),
                                          ),
                                          Text(
                                            'Skin Report',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineLarge
                                                .override(
                                                  font: GoogleFonts
                                                      .cormorantGaramond(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineLarge
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineLarge
                                                          .fontStyle,
                                                  lineHeight: 1.2,
                                                ),
                                          ),
                                        ],
                                      ),
                                      FlutterFlowIconButton(
                                        borderRadius: 50.0,
                                        buttonSize: 40.0,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .surface40,
                                        icon: Icon(
                                          Icons.close_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24.0,
                                        ),
                                        onPressed: () => context.safePop(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 16.0),
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24.0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 15.0,
                                    sigmaY: 15.0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .surface90,
                                      borderRadius: BorderRadius.circular(24.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Overall Health Score',
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
                                                                .secondaryText,
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
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '78',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .cormorantGaramond(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineLarge
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 48.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineLarge
                                                                    .fontStyle,
                                                                lineHeight: 1.2,
                                                              ),
                                                    ),
                                                    Text(
                                                      '%',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .cormorantGaramond(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                                lineHeight:
                                                                    1.35,
                                                              ),
                                                    ),
                                                  ].divide(
                                                      const SizedBox(width: 4.0)),
                                                ),
                                              ].divide(const SizedBox(height: 4.0)),
                                            ),
                                            SizedBox(
                                              width: 64.0,
                                              height: 64.0,
                                              child: Stack(
                                                alignment: const AlignmentDirectional(
                                                    0.0, 0.0),
                                                children: [
                                                  CircularPercentIndicator(
                                                    percent: 0.78,
                                                    radius: 32.0,
                                                    lineWidth: 6.0,
                                                    animation: true,
                                                    animateFromLastPercent:
                                                        true,
                                                    progressColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .tertiary,
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .alternate,
                                                  ),
                                                  Icon(
                                                    Icons.auto_awesome_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .onSurface,
                                                    size: 24.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: wrapWithModel(
                                    model: _model.metricCard2Model1,
                                    updateCallback: () => safeSetState(() {}),
                                    child: MetricCard2Widget(
                                      color:
                                          FlutterFlowTheme.of(context).success,
                                      icon: Icon(
                                        Icons.face_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 16.0,
                                      ),
                                      label: 'Acne',
                                      level: 'Low',
                                      progress: 0.25,
                                      value: '25',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: wrapWithModel(
                                    model: _model.metricCard2Model2,
                                    updateCallback: () => safeSetState(() {}),
                                    child: MetricCard2Widget(
                                      color: FlutterFlowTheme.of(context).error,
                                      icon: Icon(
                                        Icons.water_drop_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 16.0,
                                      ),
                                      label: 'Dryness',
                                      level: 'High',
                                      progress: 0.53,
                                      value: '53',
                                    ),
                                  ),
                                ),
                              ].divide(const SizedBox(width: 16.0)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24.0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 20.0,
                                    sigmaY: 20.0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .surface40,
                                      borderRadius: BorderRadius.circular(24.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Recommended Routine',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .cormorantGaramond(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontStyle,
                                                        lineHeight: 1.35,
                                                      ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => context.push('/personalizedRecommendations'),
                                                  child: Text(
                                                  'See All',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.dmSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .fontStyle,
                                                        lineHeight: 1.33,
                                                      ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                wrapWithModel(
                                                  model:
                                                      _model.productItemModel1,
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child: GestureDetector(
                                                    onTap: () => context.push(
                                                      '/ingredientDetail',
                                                      extra: {
                                                        'ingredientName': 'Organic Cleanser Ethernal',
                                                        kTransitionInfoKey: const TransitionInfo(
                                                          hasTransition: true,
                                                          transitionType: PageTransitionType.rightToLeft,
                                                          duration: Duration(milliseconds: 300),
                                                        ),
                                                      },
                                                    ),
                                                    child: const ProductItemWidget(
                                                    img_desc:
                                                        'https://dimg.dreamflow.cloud/v1/image/minimalist%20pink%20skincare%20bottle',
                                                    name:
                                                        'Organic Cleanser Ethernal',
                                                    usage: 'Morning & Evening',
                                                  ),
                                                  ),
                                                ),
                                                wrapWithModel(
                                                  model:
                                                      _model.productItemModel2,
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child: GestureDetector(
                                                    onTap: () => context.push(
                                                      '/ingredientDetail',
                                                      extra: {
                                                        'ingredientName': 'Vitamin C Glow Serum',
                                                        kTransitionInfoKey: const TransitionInfo(
                                                          hasTransition: true,
                                                          transitionType: PageTransitionType.rightToLeft,
                                                          duration: Duration(milliseconds: 300),
                                                        ),
                                                      },
                                                    ),
                                                    child: const ProductItemWidget(
                                                    img_desc:
                                                        'https://dimg.dreamflow.cloud/v1/image/glass%20serum%20dropper%20bottle',
                                                    name:
                                                        'Vitamin C Glow Serum',
                                                    usage: 'Morning only',
                                                  ),
                                                  ),
                                                ),
                                                wrapWithModel(
                                                  model:
                                                      _model.productItemModel3,
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child: GestureDetector(
                                                    onTap: () => context.push(
                                                      '/ingredientDetail',
                                                      extra: {
                                                        'ingredientName': 'Deep Hydration Barrier',
                                                        kTransitionInfoKey: const TransitionInfo(
                                                          hasTransition: true,
                                                          transitionType: PageTransitionType.rightToLeft,
                                                          duration: Duration(milliseconds: 300),
                                                        ),
                                                      },
                                                    ),
                                                    child: const ProductItemWidget(
                                                    img_desc:
                                                        'https://dimg.dreamflow.cloud/v1/image/white%20luxury%20cream%20jar',
                                                    name:
                                                        'Deep Hydration Barrier',
                                                    usage: 'Evening only',
                                                  ),
                                                  ),
                                                ),
                                              ].divide(const SizedBox(height: 8.0)),
                                            ),
                                          ].divide(const SizedBox(height: 16.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            child: Container(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Container(
                                    child: Container(
                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('✓ Report saved to your skin history'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                          Future.delayed(const Duration(milliseconds: 1500), () {
                                            if (context.mounted) context.go('/homeDashboard');
                                          });
                                        },
                                        child: wrapWithModel(
                                        model: _model.buttonModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: ButtonWidget(
                                          content: 'Save to History',
                                          icon: Icon(
                                            Icons.history_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .onPrimary,
                                            size: 16.0,
                                          ),
                                          iconPresent: true,
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
                                    ),
                                  ),
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
          ],
        ),
      ),
    );
  }
}
