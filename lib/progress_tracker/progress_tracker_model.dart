import '/components/history_node_widget.dart';
import '/components/parameter_progress_row_widget.dart';
import '/components/tab_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'progress_tracker_widget.dart' show ProgressTrackerWidget;
import 'package:flutter/material.dart';

class ProgressTrackerModel extends FlutterFlowModel<ProgressTrackerWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TabItem.
  late TabItemModel tabItemModel1;
  // Model for TabItem.
  late TabItemModel tabItemModel2;
  // Model for TabItem.
  late TabItemModel tabItemModel3;
  // Model for TabItem.
  late TabItemModel tabItemModel4;
  // Model for ParameterProgressRow.
  late ParameterProgressRowModel parameterProgressRowModel1;
  // Model for ParameterProgressRow.
  late ParameterProgressRowModel parameterProgressRowModel2;
  // Model for ParameterProgressRow.
  late ParameterProgressRowModel parameterProgressRowModel3;
  // Model for ParameterProgressRow.
  late ParameterProgressRowModel parameterProgressRowModel4;
  // Model for HistoryNode.
  late HistoryNodeModel historyNodeModel1;
  // Model for HistoryNode.
  late HistoryNodeModel historyNodeModel2;
  // Model for HistoryNode.
  late HistoryNodeModel historyNodeModel3;

  @override
  void initState(BuildContext context) {
    tabItemModel1 = createModel(context, () => TabItemModel());
    tabItemModel2 = createModel(context, () => TabItemModel());
    tabItemModel3 = createModel(context, () => TabItemModel());
    tabItemModel4 = createModel(context, () => TabItemModel());
    parameterProgressRowModel1 =
        createModel(context, () => ParameterProgressRowModel());
    parameterProgressRowModel2 =
        createModel(context, () => ParameterProgressRowModel());
    parameterProgressRowModel3 =
        createModel(context, () => ParameterProgressRowModel());
    parameterProgressRowModel4 =
        createModel(context, () => ParameterProgressRowModel());
    historyNodeModel1 = createModel(context, () => HistoryNodeModel());
    historyNodeModel2 = createModel(context, () => HistoryNodeModel());
    historyNodeModel3 = createModel(context, () => HistoryNodeModel());
  }

  @override
  void dispose() {
    tabItemModel1.dispose();
    tabItemModel2.dispose();
    tabItemModel3.dispose();
    tabItemModel4.dispose();
    parameterProgressRowModel1.dispose();
    parameterProgressRowModel2.dispose();
    parameterProgressRowModel3.dispose();
    parameterProgressRowModel4.dispose();
    historyNodeModel1.dispose();
    historyNodeModel2.dispose();
    historyNodeModel3.dispose();
  }
}
