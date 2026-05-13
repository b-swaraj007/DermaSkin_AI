import '/components/auth_textfield_widget.dart';
import '/components/button_widget.dart';
import '/components/social_btn_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'sign_in_widget.dart' show SignInWidget;
import 'package:flutter/material.dart';

class SignInModel extends FlutterFlowModel<SignInWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AuthTextfield.
  late AuthTextfieldModel authTextfieldModel1;
  // Model for AuthTextfield.
  late AuthTextfieldModel authTextfieldModel2;
  // Model for Button.
  late ButtonModel buttonModel;
  // Model for SocialBtn.
  late SocialBtnModel socialBtnModel1;
  // Model for SocialBtn.
  late SocialBtnModel socialBtnModel2;

  @override
  void initState(BuildContext context) {
    authTextfieldModel1 = createModel(context, () => AuthTextfieldModel());
    authTextfieldModel2 = createModel(context, () => AuthTextfieldModel());
    buttonModel = createModel(context, () => ButtonModel());
    socialBtnModel1 = createModel(context, () => SocialBtnModel());
    socialBtnModel2 = createModel(context, () => SocialBtnModel());
  }

  @override
  void dispose() {
    authTextfieldModel1.dispose();
    authTextfieldModel2.dispose();
    buttonModel.dispose();
    socialBtnModel1.dispose();
    socialBtnModel2.dispose();
  }
}
