import '/components/button_widget.dart';
import '/components/checklist_item_widget.dart';
import '/components/step_indicator_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'pre_scan_setup_widget.dart' show PreScanSetupWidget;
import 'package:flutter/material.dart';

class PreScanSetupModel extends FlutterFlowModel<PreScanSetupWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ChecklistItem.
  late ChecklistItemModel checklistItemModel1;
  // Model for ChecklistItem.
  late ChecklistItemModel checklistItemModel2;
  // Model for ChecklistItem.
  late ChecklistItemModel checklistItemModel3;
  // Model for Button.
  late ButtonModel buttonModel;
  // Model for StepIndicator.
  late StepIndicatorModel stepIndicatorModel1;
  // Model for StepIndicator.
  late StepIndicatorModel stepIndicatorModel2;
  // Model for StepIndicator.
  late StepIndicatorModel stepIndicatorModel3;

  @override
  void initState(BuildContext context) {
    checklistItemModel1 = createModel(context, () => ChecklistItemModel());
    checklistItemModel2 = createModel(context, () => ChecklistItemModel());
    checklistItemModel3 = createModel(context, () => ChecklistItemModel());
    buttonModel = createModel(context, () => ButtonModel());
    stepIndicatorModel1 = createModel(context, () => StepIndicatorModel());
    stepIndicatorModel2 = createModel(context, () => StepIndicatorModel());
    stepIndicatorModel3 = createModel(context, () => StepIndicatorModel());
  }

  @override
  void dispose() {
    checklistItemModel1.dispose();
    checklistItemModel2.dispose();
    checklistItemModel3.dispose();
    buttonModel.dispose();
    stepIndicatorModel1.dispose();
    stepIndicatorModel2.dispose();
    stepIndicatorModel3.dispose();
  }
}
