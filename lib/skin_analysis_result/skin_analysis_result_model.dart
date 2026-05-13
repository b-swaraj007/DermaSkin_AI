import '/components/parameter_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'skin_analysis_result_widget.dart' show SkinAnalysisResultWidget;

class SkinAnalysisResultModel
    extends FlutterFlowModel<SkinAnalysisResultWidget> {
  // Parameter card sub-models moved over from the old AR bottom panel so
  // those widgets keep working without changes to their API.
  late ParameterCardModel parameterCardModel1;
  late ParameterCardModel parameterCardModel2;
  late ParameterCardModel parameterCardModel3;
  late ParameterCardModel parameterCardModel4;
  late ParameterCardModel parameterCardModel5;
  late ParameterCardModel parameterCardModel6;
  late ParameterCardModel parameterCardModel7;
  late ParameterCardModel parameterCardModel8;
  late ParameterCardModel parameterCardModel9;

  @override
  void initState(BuildContext context) {
    parameterCardModel1 = createModel(context, () => ParameterCardModel());
    parameterCardModel2 = createModel(context, () => ParameterCardModel());
    parameterCardModel3 = createModel(context, () => ParameterCardModel());
    parameterCardModel4 = createModel(context, () => ParameterCardModel());
    parameterCardModel5 = createModel(context, () => ParameterCardModel());
    parameterCardModel6 = createModel(context, () => ParameterCardModel());
    parameterCardModel7 = createModel(context, () => ParameterCardModel());
    parameterCardModel8 = createModel(context, () => ParameterCardModel());
    parameterCardModel9 = createModel(context, () => ParameterCardModel());
  }

  @override
  void dispose() {
    parameterCardModel1.dispose();
    parameterCardModel2.dispose();
    parameterCardModel3.dispose();
    parameterCardModel4.dispose();
    parameterCardModel5.dispose();
    parameterCardModel6.dispose();
    parameterCardModel7.dispose();
    parameterCardModel8.dispose();
    parameterCardModel9.dispose();
  }
}
