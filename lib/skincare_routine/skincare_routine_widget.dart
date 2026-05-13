import '/components/routine_step_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'skincare_routine_model.dart';
export 'skincare_routine_model.dart';

class SkincareRoutineWidget extends StatefulWidget {
  const SkincareRoutineWidget({super.key});

  static String routeName = 'SkincareRoutine';
  static String routePath = '/skincareRoutine';

  @override
  State<SkincareRoutineWidget> createState() => _SkincareRoutineWidgetState();
}

class _SkincareRoutineWidgetState extends State<SkincareRoutineWidget> {
  late SkincareRoutineModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SkincareRoutineModel());
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 16.0),
                child: Container(
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
                          Icons.arrow_back_ios_new_rounded,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 20.0,
                        ),
                        onPressed: () => context.safePop(),
                      ),
                      Text(
                        'Your Routine',
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
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontStyle,
                              lineHeight: 1.27,
                            ),
                      ),
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        fillColor: Colors.transparent,
                        icon: Icon(
                          Icons.settings_outlined,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 20.0,
                        ),
                        onPressed: () => context.push('/editProfile', extra: {kTransitionInfoKey: const TransitionInfo(hasTransition: true, transitionType: PageTransitionType.bottomToTop, duration: Duration(milliseconds: 300))}),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 24.0),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(50.0),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 16.0, 0.0, 16.0),
                                              child: Container(
                                                child: Container(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    'Today',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .dmSans(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .onPrimary,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.47,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 16.0, 0.0, 16.0),
                                              child: Container(
                                                child: Container(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    'Tomorrow',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .dmSans(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.47,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(width: 4.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.light_mode_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .onSurface,
                                        size: 22.0,
                                      ),
                                      Text(
                                        'Morning Routine',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              font:
                                                  GoogleFonts.cormorantGaramond(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                              lineHeight: 1.35,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 8.0)),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      wrapWithModel(
                                        model: _model.routineStepModel1,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: const RoutineStepWidget(
                                          category: 'Cleansing',
                                          description:
                                              'Start with a clean base. Gently massage into damp skin for 60 seconds.',
                                          img_desc:
                                              'https://dimg.dreamflow.cloud/v1/image/white%20bottle%20of%20facial%20cleanser',
                                          is_expanded: false,
                                          product_name: 'Gentle Cleanser',
                                          time: '07:30 AM',
                                          completed: true,
                                          is_last: false,
                                        ),
                                      ),
                                      wrapWithModel(
                                        model: _model.routineStepModel2,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: const RoutineStepWidget(
                                          category: 'Treatment',
                                          description:
                                              'Get brighter, healthier skin now — we\'ll guide you step-by-step with personalized Vitamin C routines designed just for you.',
                                          img_desc:
                                              'https://dimg.dreamflow.cloud/v1/image/amber%20glass%20dropper%20bottle%20with%20orange',
                                          is_expanded: true,
                                          product_name: 'Vitamin C Serum',
                                          time: '07:45 AM',
                                          completed: true,
                                          is_last: false,
                                        ),
                                      ),
                                      wrapWithModel(
                                        model: _model.routineStepModel3,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: const RoutineStepWidget(
                                          category: 'Protection',
                                          description:
                                              'Apply a nickel-sized amount to face and neck. Essential for UV protection.',
                                          img_desc:
                                              'https://dimg.dreamflow.cloud/v1/image/tube%20of%20sunscreen%20cream',
                                          is_expanded: false,
                                          product_name: 'Hydrating Sunscreen',
                                          time: '08:00 AM',
                                          completed: false,
                                          is_last: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ].divide(const SizedBox(height: 16.0)),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.dark_mode_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 22.0,
                                        ),
                                        Text(
                                          'Night Routine',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                font: GoogleFonts
                                                    .cormorantGaramond(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                                lineHeight: 1.35,
                                              ),
                                        ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        wrapWithModel(
                                          model: _model.routineStepModel4,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const RoutineStepWidget(
                                            category: 'Cleansing',
                                            description:
                                                'Double cleanse to remove makeup and pollution from the day.',
                                            img_desc:
                                                'https://dimg.dreamflow.cloud/v1/image/clear%20bottle%20with%20yellow%20oil',
                                            is_expanded: false,
                                            product_name: 'Oil Cleanser',
                                            time: '09:30 PM',
                                            completed: false,
                                            is_last: false,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.routineStepModel5,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const RoutineStepWidget(
                                            category: 'Repair',
                                            description:
                                                'Powerful anti-aging treatment. Use only a pea-sized amount.',
                                            img_desc:
                                                'https://dimg.dreamflow.cloud/v1/image/purple%20tube%20of%20cream',
                                            is_expanded: false,
                                            product_name: 'Retinol Complex',
                                            time: '10:00 PM',
                                            completed: false,
                                            is_last: false,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model: _model.routineStepModel6,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: const RoutineStepWidget(
                                            category: 'Hydration',
                                            description:
                                                'Seal in moisture while you sleep with our rich recovery formula.',
                                            img_desc:
                                                'https://dimg.dreamflow.cloud/v1/image/blue%20jar%20of%20thick%20cream',
                                            is_expanded: false,
                                            product_name: 'Night Recovery Balm',
                                            time: '10:15 PM',
                                            completed: false,
                                            is_last: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ].divide(const SizedBox(height: 16.0)),
                                ),
                              ),
                            ].divide(const SizedBox(height: 24.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
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
                        const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 16.0),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.home_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            onPressed: () => context.push('/homeDashboard'),
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.analytics_outlined,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            onPressed: () => context.push('/skinReport'),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/preScanSetup', extra: {kTransitionInfoKey: const TransitionInfo(hasTransition: true, transitionType: PageTransitionType.bottomToTop, duration: Duration(milliseconds: 300))}),
                            child: Container(
                              width: 56.0,
                              height: 56.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(50.0),
                                shape: BoxShape.rectangle,
                              ),
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                color: FlutterFlowTheme.of(context).onPrimary,
                                size: 24.0,
                              ),
                            ),
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.auto_awesome_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 24.0,
                            ),
                            onPressed: () {},
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.person_outline_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            onPressed: () => context.push('/userProfileSettings'),
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
