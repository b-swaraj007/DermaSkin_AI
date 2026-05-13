import '/components/button_widget.dart';
import '/components/metric_card2_widget.dart';
import '/components/product_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'skin_report_detail_widget.dart' show SkinReportDetailWidget;
import 'package:flutter/material.dart';

class SkinReportDetailModel extends FlutterFlowModel<SkinReportDetailWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MetricCard2.
  late MetricCard2Model metricCard2Model1;
  // Model for MetricCard2.
  late MetricCard2Model metricCard2Model2;
  // Model for ProductItem.
  late ProductItemModel productItemModel1;
  // Model for ProductItem.
  late ProductItemModel productItemModel2;
  // Model for ProductItem.
  late ProductItemModel productItemModel3;
  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    metricCard2Model1 = createModel(context, () => MetricCard2Model());
    metricCard2Model2 = createModel(context, () => MetricCard2Model());
    productItemModel1 = createModel(context, () => ProductItemModel());
    productItemModel2 = createModel(context, () => ProductItemModel());
    productItemModel3 = createModel(context, () => ProductItemModel());
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    metricCard2Model1.dispose();
    metricCard2Model2.dispose();
    productItemModel1.dispose();
    productItemModel2.dispose();
    productItemModel3.dispose();
    buttonModel.dispose();
  }
}
