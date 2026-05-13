import '/components/button_widget.dart';
import '/components/onboarding_slide_widget.dart';
import '/components/pagination_dot_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_carousel_model.dart';
export 'onboarding_carousel_model.dart';

class OnboardingCarouselWidget extends StatefulWidget {
  const OnboardingCarouselWidget({super.key});

  static String routeName = 'OnboardingCarousel';
  static String routePath = '/onboardingCarousel';

  @override
  State<OnboardingCarouselWidget> createState() =>
      _OnboardingCarouselWidgetState();
}

class _OnboardingCarouselWidgetState extends State<OnboardingCarouselWidget> {
  late OnboardingCarouselModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingCarouselModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _goToSignUp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (!mounted) return;
    context.go(
      '/signUp',
      extra: {
        kTransitionInfoKey: const TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 300),
        ),
      },
    );
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
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              wrapWithModel(
                model: _model.onboardingSlideModel,
                updateCallback: () => safeSetState(() {}),
                child: const OnboardingSlideWidget(
                  description:
                      'Our AR camera reads 9 skin parameters in under 30 seconds — no filters, no guesswork.',
                  lottie_desc:
                      'https://dimg.dreamflow.cloud/v1/lottie/AR+face+scan+animation+with+teal+scanning+lines',
                  title: 'Scan in Seconds',
                ),
              ),
              Container(height: 32.0),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        wrapWithModel(
                          model: _model.paginationDotModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: const PaginationDotWidget(active: true),
                        ),
                        wrapWithModel(
                          model: _model.paginationDotModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: const PaginationDotWidget(active: false),
                        ),
                        wrapWithModel(
                          model: _model.paginationDotModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: const PaginationDotWidget(active: false),
                        ),
                      ],
                    ),
                    Container(
                      constraints: const BoxConstraints(minHeight: 80.0),
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: GestureDetector(
                        onTap: _goToSignUp,
                        child: wrapWithModel(
                          model: _model.buttonModel,
                          updateCallback: () => safeSetState(() {}),
                          child: const ButtonWidget(
                            content: 'Get Started',
                            iconPresent: false,
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
                  ].divide(const SizedBox(height: 32.0)),
                ),
              ),
              Container(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: GestureDetector(
                  onTap: _goToSignUp,
                  child: Text(
                    'Skip tour',
                    style: FlutterFlowTheme.of(context).labelLarge.override(
                          font: GoogleFonts.dmSans(
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelLarge
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).labelLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).labelLarge.fontStyle,
                          lineHeight: 1.33,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
