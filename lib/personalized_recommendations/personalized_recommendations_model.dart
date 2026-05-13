import '/components/button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'personalized_recommendations_widget.dart'
    show PersonalizedRecommendationsWidget;
import 'package:flutter/material.dart';

class PersonalizedRecommendationsModel
    extends FlutterFlowModel<PersonalizedRecommendationsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    buttonModel.dispose();
  }
}
