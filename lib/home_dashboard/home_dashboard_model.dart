import '/components/button_widget.dart';
import '/components/insight_pill_widget.dart';
import '/components/metric_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_dashboard_widget.dart' show HomeDashboardWidget;
import 'package:flutter/material.dart';

class HomeDashboardModel extends FlutterFlowModel<HomeDashboardWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Button.
  late ButtonModel buttonModel;
  // Model for MetricCard.
  late MetricCardModel metricCardModel1;
  // Model for MetricCard.
  late MetricCardModel metricCardModel2;
  // Model for MetricCard.
  late MetricCardModel metricCardModel3;
  // Model for MetricCard.
  late MetricCardModel metricCardModel4;
  // Model for InsightPill.
  late InsightPillModel insightPillModel1;
  // Model for InsightPill.
  late InsightPillModel insightPillModel2;
  // Model for InsightPill.
  late InsightPillModel insightPillModel3;

  @override
  void initState(BuildContext context) {
    buttonModel = createModel(context, () => ButtonModel());
    metricCardModel1 = createModel(context, () => MetricCardModel());
    metricCardModel2 = createModel(context, () => MetricCardModel());
    metricCardModel3 = createModel(context, () => MetricCardModel());
    metricCardModel4 = createModel(context, () => MetricCardModel());
    insightPillModel1 = createModel(context, () => InsightPillModel());
    insightPillModel2 = createModel(context, () => InsightPillModel());
    insightPillModel3 = createModel(context, () => InsightPillModel());
  }

  @override
  void dispose() {
    buttonModel.dispose();
    metricCardModel1.dispose();
    metricCardModel2.dispose();
    metricCardModel3.dispose();
    metricCardModel4.dispose();
    insightPillModel1.dispose();
    insightPillModel2.dispose();
    insightPillModel3.dispose();
  }
}
