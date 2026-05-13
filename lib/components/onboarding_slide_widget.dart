import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_slide_model.dart';
export 'onboarding_slide_model.dart';

// ignore_for_file: non_constant_identifier_names

class OnboardingSlideWidget extends StatefulWidget {
  const OnboardingSlideWidget({
    super.key,
    String? description,
    String? lottie_desc,
    String? title,
  })  : description = description ??
            'Our AR camera reads 9 skin parameters in under 30 seconds — no filters, no guesswork.',
        lottie_desc = lottie_desc ??
            'https://dimg.dreamflow.cloud/v1/lottie/AR+face+scan+animation+with+teal+scanning+lines',
        title = title ?? 'Scan in Seconds';

  final String description;
  final String lottie_desc;
  final String title;

  @override
  State<OnboardingSlideWidget> createState() => _OnboardingSlideWidgetState();
}

class _OnboardingSlideWidgetState extends State<OnboardingSlideWidget> {
  late OnboardingSlideModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingSlideModel());
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 420.0,
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Stack(
            alignment: const AlignmentDirectional(0.0, 0.0),
            children: [
              ClipRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 40.0,
                    sigmaY: 40.0,
                  ),
                  child: Container(
                    width: 280.0,
                    height: 280.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary5,
                      borderRadius: BorderRadius.circular(50.0),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ),
              ),
              Lottie.network(
                valueOrDefault<String>(
                  widget.lottie_desc,
                  'https://dimg.dreamflow.cloud/v1/lottie/AR+face+scan+animation+with+teal+scanning+lines',
                ),
                width: 320.0,
                height: 320.0,
                fit: BoxFit.contain,
                animate: true,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                valueOrDefault<String>(
                  widget.title,
                  'Scan in Seconds',
                ),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                      font: GoogleFonts.cormorantGaramond(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineLarge
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineLarge
                            .fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).headlineLarge.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                      lineHeight: 1.2,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  widget.description,
                  'Our AR camera reads 9 skin parameters in under 30 seconds — no filters, no guesswork.',
                ),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.dmSans(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      lineHeight: 1.5,
                    ),
              ),
            ].divide(const SizedBox(height: 16.0)),
          ),
        ),
      ].divide(const SizedBox(height: 32.0)),
    );
  }
}
