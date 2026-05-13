import '/components/button_widget.dart';
import '/components/profile_stat_widget.dart';
import '/components/section_header_widget.dart';
import '/components/settings_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile_settings_model.dart';
export 'user_profile_settings_model.dart';

class UserProfileSettingsWidget extends StatefulWidget {
  const UserProfileSettingsWidget({super.key});

  static String routeName = 'UserProfileSettings';
  static String routePath = '/userProfileSettings';

  @override
  State<UserProfileSettingsWidget> createState() =>
      _UserProfileSettingsWidgetState();
}

class _UserProfileSettingsWidgetState extends State<UserProfileSettingsWidget> {
  late UserProfileSettingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserProfileSettingsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _handleSignOut() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out?'),
        content: const Text(
            'You will need to sign in again to access your skin data'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (result == true && mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      if (mounted) {
        context.go('/signIn');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              fillColor: Colors.transparent,
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                              onPressed: () => context.safePop(),
                            ),
                            Text(
                              'Profile',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.cormorantGaramond(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                    lineHeight: 1.27,
                                  ),
                            ),
                            FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              fillColor: Colors.transparent,
                              icon: Icon(
                                Icons.edit_rounded,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                              onPressed: () => context.push(
                                '/editProfile',
                                extra: {
                                  kTransitionInfoKey: const TransitionInfo(
                                    hasTransition: true,
                                    transitionType:
                                        PageTransitionType.bottomToTop,
                                    duration: Duration(milliseconds: 300),
                                  ),
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => context.push(
                                '/editProfile',
                                extra: {
                                  kTransitionInfoKey: const TransitionInfo(
                                    hasTransition: true,
                                    transitionType:
                                        PageTransitionType.bottomToTop,
                                    duration: Duration(milliseconds: 300),
                                  ),
                                },
                              ),
                              child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  width: 3.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  child: Container(
                                    width: 92.0,
                                    height: 92.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'VS',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.dmSans(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .onPrimary,
                                            fontSize: 34.96,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                            lineHeight: 1.38,
                                          ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Vaishnavi Sharma',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Member since Oct 2023',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.dmSans(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                        lineHeight: 1.38,
                                      ),
                                ),
                              ].divide(const SizedBox(height: 4.0)),
                            ),
                          ].divide(const SizedBox(height: 16.0)),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              wrapWithModel(
                                model: _model.profileStatModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: GestureDetector(
                                  onTap: () => context.push('/scanHistory'),
                                  child: const ProfileStatWidget(
                                    label: 'Total Scans',
                                    value: '24',
                                  ),
                                ),
                              ),
                              Container(
                                width: 1.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.profileStatModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: GestureDetector(
                                  onTap: () => context.push('/skinReport'),
                                  child: const ProfileStatWidget(
                                    label: 'Skin Score',
                                    value: '74',
                                  ),
                                ),
                              ),
                              Container(
                                width: 1.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.profileStatModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: GestureDetector(
                                  onTap: () => context.push('/skincareRoutine'),
                                  child: const ProfileStatWidget(
                                    label: 'Routine',
                                    value: '85%',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ].divide(const SizedBox(height: 24.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        wrapWithModel(
                          model: _model.sectionHeaderModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: const SectionHeaderWidget(
                            title: 'ACCOUNT SETTINGS',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingsItemModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: GestureDetector(
                            onTap: () => context.push('/editProfile'),
                            child: SettingsItemWidget(
                              icon: Icon(
                                Icons.person_outline_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                              show_subtitle: true,
                              subtitle: 'Name, Email, Phone',
                              title: 'Personal Information',
                            ),
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingsItemModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: GestureDetector(
                            onTap: () => context.push('/scanHistory'),
                            child: SettingsItemWidget(
                              icon: Icon(
                                Icons.history_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                              show_subtitle: true,
                              subtitle: 'View all 24 previous reports',
                              title: 'Scan History',
                            ),
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingsItemModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: GestureDetector(
                            onTap: () => context.push('/skincareRoutine'),
                            child: SettingsItemWidget(
                              icon: Icon(
                                Icons.favorite_border_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                              show_subtitle: true,
                              subtitle: 'Personalized product list',
                              title: 'My Routine',
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 8.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        wrapWithModel(
                          model: _model.sectionHeaderModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: const SectionHeaderWidget(
                            title: 'PRIVACY & SECURITY',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingsItemModel4,
                          updateCallback: () => safeSetState(() {}),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Your skin data is encrypted and securely stored'),
                                ),
                              );
                            },
                            child: SettingsItemWidget(
                              icon: Icon(
                                Icons.lock_outline_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                              show_subtitle: true,
                              subtitle: 'Manage your encrypted skin data',
                              title: 'Data Encryption',
                            ),
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingsItemModel5,
                          updateCallback: () => safeSetState(() {}),
                          child: GestureDetector(
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final current =
                                  prefs.getBool('privacy_mode') ?? false;
                              await prefs.setBool('privacy_mode', !current);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(!current
                                        ? 'Privacy Mode enabled'
                                        : 'Privacy Mode disabled'),
                                  ),
                                );
                              }
                            },
                            child: SettingsItemWidget(
                              icon: Icon(
                                Icons.visibility_off_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                              show_subtitle: false,
                              subtitle: 'Name, Email, Phone',
                              title: 'Privacy Mode',
                            ),
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingsItemModel6,
                          updateCallback: () => safeSetState(() {}),
                          child: GestureDetector(
                            onTap: () => context.push('/notifications'),
                            child: SettingsItemWidget(
                              icon: Icon(
                                Icons.notifications_none_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                              show_subtitle: true,
                              subtitle: 'Scan reminders and insights',
                              title: 'Notifications',
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 8.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        wrapWithModel(
                          model: _model.sectionHeaderModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: const SectionHeaderWidget(
                            title: 'SUPPORT',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingsItemModel7,
                          updateCallback: () => safeSetState(() {}),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Help Center coming soon'),
                                ),
                              );
                            },
                            child: SettingsItemWidget(
                              icon: Icon(
                                Icons.help_outline_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                              show_subtitle: false,
                              subtitle: 'Name, Email, Phone',
                              title: 'Help Center',
                            ),
                          ),
                        ),
                        wrapWithModel(
                          model: _model.settingsItemModel8,
                          updateCallback: () => safeSetState(() {}),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Terms of Service coming soon'),
                                ),
                              );
                            },
                            child: SettingsItemWidget(
                              icon: Icon(
                                Icons.description_outlined,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                              show_subtitle: false,
                              subtitle: 'Name, Email, Phone',
                              title: 'Terms of Service',
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 8.0)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                      child: Container(
                        child: Container(
                          child: GestureDetector(
                            onTap: _handleSignOut,
                            child: wrapWithModel(
                              model: _model.buttonModel,
                              updateCallback: () => safeSetState(() {}),
                              child: ButtonWidget(
                                content: 'Sign Out',
                                icon: Icon(
                                  Icons.logout_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 16.0,
                                ),
                                iconPresent: true,
                                iconEndPresent: false,
                                radius: 50.0,
                                variant: 'outline',
                                size: 'medium',
                                fullWidth: true,
                                loading: false,
                                disabled: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'DermaScan AI v2.4.0',
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                              font: GoogleFonts.dmSans(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).onSurface,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .fontStyle,
                              lineHeight: 1.27,
                            ),
                      ),
                    ),
                    Container(
                      height: 40.0,
                    ),
                  ].divide(const SizedBox(height: 24.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
