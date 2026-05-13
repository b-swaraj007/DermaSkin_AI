import '/components/button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'routine_step_widget.dart' show RoutineStepWidget;
import 'package:flutter/material.dart';

class RoutineStepModel extends FlutterFlowModel<RoutineStepWidget> {
  ///  State fields for stateful widgets in this component.

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
