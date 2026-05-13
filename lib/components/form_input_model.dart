import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'form_input_widget.dart' show FormInputWidget;
import 'package:flutter/material.dart';

class FormInputModel extends FlutterFlowModel<FormInputWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for TextField.
  late TextFieldModel textFieldModel;

  @override
  void initState(BuildContext context) {
    textFieldModel = createModel(context, () => TextFieldModel());
  }

  @override
  void dispose() {
    textFieldModel.dispose();
  }
}
