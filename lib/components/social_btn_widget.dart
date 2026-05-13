import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'social_btn_model.dart';
export 'social_btn_model.dart';

class SocialBtnWidget extends StatefulWidget {
  const SocialBtnWidget({
    super.key,
    String? name,
    String? provider,
  })  : name = name ?? 'Google',
        provider =
            provider ?? 'https://cdn.simpleicons.org/google/0a2540.svg';

  final String name;
  final String provider;

  @override
  State<SocialBtnWidget> createState() => _SocialBtnWidgetState();
}

class _SocialBtnWidgetState extends State<SocialBtnWidget> {
  late SocialBtnModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SocialBtnModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        child: Container(
          height: 56.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(50.0),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.network(
                valueOrDefault<String>(
                  widget.provider,
                  'https://cdn.simpleicons.org/google/0a2540.svg',
                ),
                width: 20.0,
                height: 20.0,
                fit: BoxFit.contain,
              ),
              Text(
                'Continue with ${widget.name}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      lineHeight: 1.47,
                    ),
              ),
            ].divide(const SizedBox(width: 16.0)),
          ),
        ),
      ),
    );
  }
}
