import '/components/button_widget.dart';
import '/components/onboarding_slide_widget.dart';
import '/components/pagination_dot_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'onboarding_carousel_widget.dart' show OnboardingCarouselWidget;
import 'package:flutter/material.dart';

class OnboardingCarouselModel
    extends FlutterFlowModel<OnboardingCarouselWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for OnboardingSlide.
  late OnboardingSlideModel onboardingSlideModel;
  // Model for PaginationDot.
  late PaginationDotModel paginationDotModel1;
  // Model for PaginationDot.
  late PaginationDotModel paginationDotModel2;
  // Model for PaginationDot.
  late PaginationDotModel paginationDotModel3;
  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    onboardingSlideModel = createModel(context, () => OnboardingSlideModel());
    paginationDotModel1 = createModel(context, () => PaginationDotModel());
    paginationDotModel2 = createModel(context, () => PaginationDotModel());
    paginationDotModel3 = createModel(context, () => PaginationDotModel());
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    onboardingSlideModel.dispose();
    paginationDotModel1.dispose();
    paginationDotModel2.dispose();
    paginationDotModel3.dispose();
    buttonModel.dispose();
  }
}
