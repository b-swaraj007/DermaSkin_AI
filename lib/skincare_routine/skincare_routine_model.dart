import '/components/routine_step_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'skincare_routine_widget.dart' show SkincareRoutineWidget;
import 'package:flutter/material.dart';

class SkincareRoutineModel extends FlutterFlowModel<SkincareRoutineWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for RoutineStep.
  late RoutineStepModel routineStepModel1;
  // Model for RoutineStep.
  late RoutineStepModel routineStepModel2;
  // Model for RoutineStep.
  late RoutineStepModel routineStepModel3;
  // Model for RoutineStep.
  late RoutineStepModel routineStepModel4;
  // Model for RoutineStep.
  late RoutineStepModel routineStepModel5;
  // Model for RoutineStep.
  late RoutineStepModel routineStepModel6;

  @override
  void initState(BuildContext context) {
    routineStepModel1 = createModel(context, () => RoutineStepModel());
    routineStepModel2 = createModel(context, () => RoutineStepModel());
    routineStepModel3 = createModel(context, () => RoutineStepModel());
    routineStepModel4 = createModel(context, () => RoutineStepModel());
    routineStepModel5 = createModel(context, () => RoutineStepModel());
    routineStepModel6 = createModel(context, () => RoutineStepModel());
  }

  @override
  void dispose() {
    routineStepModel1.dispose();
    routineStepModel2.dispose();
    routineStepModel3.dispose();
    routineStepModel4.dispose();
    routineStepModel5.dispose();
    routineStepModel6.dispose();
  }
}
