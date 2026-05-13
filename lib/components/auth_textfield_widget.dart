import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_textfield_model.dart';
export 'auth_textfield_model.dart';

class AuthTextfieldWidget extends StatefulWidget {
  const AuthTextfieldWidget({
    super.key,
    String? hint,
    this.icon,
    String? label,
    this.trailing,
    String? value,
  })  : hint = hint ?? 'name@example.com',
        label = label ?? 'Email Address',
        value = value ?? '42';

  final String hint;
  final Widget? icon;
  final String label;
  final Widget? trailing;
  final String value;

  @override
  State<AuthTextfieldWidget> createState() => _AuthTextfieldWidgetState();
}

class _AuthTextfieldWidgetState extends State<AuthTextfieldWidget> {
  late AuthTextfieldModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthTextfieldModel());
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
          child: Text(
              valueOrDefault<String>(
                widget.label,
                'Email Address',
              ),
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    lineHeight: 1.38,
                  ),
            ),
        ),
        Container(
          height: 56.0,
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
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.icon!,
                  Expanded(
                    flex: 1,
                    child: wrapWithModel(
                      model: _model.textFieldModel,
                      updateCallback: () => safeSetState(() {}),
                      child: TextFieldWidget(
                        label: false,
                        helper: false,
                        hint: valueOrDefault<String>(
                          widget.hint,
                          'name@example.com',
                        ),
                        value: valueOrDefault<String>(
                          widget.value,
                          '42',
                        ),
                        leading_icon_present: false,
                        trailing_icon: widget.trailing,
                        trailing_icon_present: false,
                        variant: 'ghost',
                        error: false,
                      ),
                    ),
                  ),
                ].divide(const SizedBox(width: 16.0)),
              ),
            ),
          ),
      ].divide(const SizedBox(height: 4.0)),
    );
  }
}
