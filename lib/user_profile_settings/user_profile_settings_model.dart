import '/components/button_widget.dart';
import '/components/profile_stat_widget.dart';
import '/components/section_header_widget.dart';
import '/components/settings_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_profile_settings_widget.dart' show UserProfileSettingsWidget;
import 'package:flutter/material.dart';

class UserProfileSettingsModel
    extends FlutterFlowModel<UserProfileSettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ProfileStat.
  late ProfileStatModel profileStatModel1;
  // Model for ProfileStat.
  late ProfileStatModel profileStatModel2;
  // Model for ProfileStat.
  late ProfileStatModel profileStatModel3;
  // Model for SectionHeader.
  late SectionHeaderModel sectionHeaderModel1;
  // Model for SettingsItem.
  late SettingsItemModel settingsItemModel1;
  // Model for SettingsItem.
  late SettingsItemModel settingsItemModel2;
  // Model for SettingsItem.
  late SettingsItemModel settingsItemModel3;
  // Model for SectionHeader.
  late SectionHeaderModel sectionHeaderModel2;
  // Model for SettingsItem.
  late SettingsItemModel settingsItemModel4;
  // Model for SettingsItem.
  late SettingsItemModel settingsItemModel5;
  // Model for SettingsItem.
  late SettingsItemModel settingsItemModel6;
  // Model for SectionHeader.
  late SectionHeaderModel sectionHeaderModel3;
  // Model for SettingsItem.
  late SettingsItemModel settingsItemModel7;
  // Model for SettingsItem.
  late SettingsItemModel settingsItemModel8;
  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    profileStatModel1 = createModel(context, () => ProfileStatModel());
    profileStatModel2 = createModel(context, () => ProfileStatModel());
    profileStatModel3 = createModel(context, () => ProfileStatModel());
    sectionHeaderModel1 = createModel(context, () => SectionHeaderModel());
    settingsItemModel1 = createModel(context, () => SettingsItemModel());
    settingsItemModel2 = createModel(context, () => SettingsItemModel());
    settingsItemModel3 = createModel(context, () => SettingsItemModel());
    sectionHeaderModel2 = createModel(context, () => SectionHeaderModel());
    settingsItemModel4 = createModel(context, () => SettingsItemModel());
    settingsItemModel5 = createModel(context, () => SettingsItemModel());
    settingsItemModel6 = createModel(context, () => SettingsItemModel());
    sectionHeaderModel3 = createModel(context, () => SectionHeaderModel());
    settingsItemModel7 = createModel(context, () => SettingsItemModel());
    settingsItemModel8 = createModel(context, () => SettingsItemModel());
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    profileStatModel1.dispose();
    profileStatModel2.dispose();
    profileStatModel3.dispose();
    sectionHeaderModel1.dispose();
    settingsItemModel1.dispose();
    settingsItemModel2.dispose();
    settingsItemModel3.dispose();
    sectionHeaderModel2.dispose();
    settingsItemModel4.dispose();
    settingsItemModel5.dispose();
    settingsItemModel6.dispose();
    sectionHeaderModel3.dispose();
    settingsItemModel7.dispose();
    settingsItemModel8.dispose();
    buttonModel.dispose();
  }
}
