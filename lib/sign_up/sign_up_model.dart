import '/components/form_input_widget.dart';
import '/components/social_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'sign_up_widget.dart' show SignUpWidget;
import 'package:flutter/material.dart';

class SignUpModel extends FlutterFlowModel<SignUpWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for FormInput.
  late FormInputModel formInputModel1;
  // Model for FormInput.
  late FormInputModel formInputModel2;
  // Model for FormInput.
  late FormInputModel formInputModel3;
  // Model for FormInput.
  late FormInputModel formInputModel4;
  // Model for SocialButton.
  late SocialButtonModel socialButtonModel1;
  // Model for SocialButton.
  late SocialButtonModel socialButtonModel2;

  @override
  void initState(BuildContext context) {
    formInputModel1 = createModel(context, () => FormInputModel());
    formInputModel2 = createModel(context, () => FormInputModel());
    formInputModel3 = createModel(context, () => FormInputModel());
    formInputModel4 = createModel(context, () => FormInputModel());
    socialButtonModel1 = createModel(context, () => SocialButtonModel());
    socialButtonModel2 = createModel(context, () => SocialButtonModel());
  }

  @override
  void dispose() {
    formInputModel1.dispose();
    formInputModel2.dispose();
    formInputModel3.dispose();
    formInputModel4.dispose();
    socialButtonModel1.dispose();
    socialButtonModel2.dispose();
  }
}
