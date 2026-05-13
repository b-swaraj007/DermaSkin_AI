import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'form_input_model.dart';
export 'form_input_model.dart';

class FormInputWidget extends StatefulWidget {
  const FormInputWidget({
    super.key,
    String? hint,
    this.icon,
    String? label,
  })  : hint = hint ?? 'Enter your name',
        label = label ?? 'Full Name';

  final String hint;
  final Widget? icon;
  final String label;

  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

class _FormInputWidgetState extends State<FormInputWidget> {
  late FormInputModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormInputModel());
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
          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 4.0),
          child: Text(
              valueOrDefault<String>(
                widget.label,
                'Full Name',
              ),
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primary,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    lineHeight: 1.38,
                  ),
            ),
        ),
        wrapWithModel(
          model: _model.textFieldModel,
          updateCallback: () => safeSetState(() {}),
          child: TextFieldWidget(
            label: false,
            helper: false,
            hint: valueOrDefault<String>(
              widget.hint,
              'Enter your name',
            ),
            value: '',
            leading_icon: widget.icon,
            leading_icon_present: false,
            trailing_icon_present: false,
            variant: 'outlined',
            error: false,
          ),
        ),
      ].divide(const SizedBox(height: 4.0)),
    );
  }
}
