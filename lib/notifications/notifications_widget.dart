import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({super.key});

  static const String routeName = 'Notifications';
  static const String routePath = '/notifications';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'icon': Icons.face_retouching_natural_rounded,
        'title': 'Scan Reminder',
        'body': 'Time for your weekly skin analysis!',
        'time': '2h ago',
        'route': '/preScanSetup',
      },
      {
        'icon': Icons.auto_awesome_rounded,
        'title': 'Routine Update',
        'body': 'New ingredients recommended based on your latest scan.',
        'time': '1d ago',
        'route': '/personalizedRecommendations',
      },
      {
        'icon': Icons.bar_chart_rounded,
        'title': 'Progress Milestone',
        'body': 'Your skin score improved by 6 points this week! 🎉',
        'time': '3d ago',
        'route': '/progressTracker',
      },
      {
        'icon': Icons.info_outline_rounded,
        'title': 'Tip of the Day',
        'body': 'Remember to apply SPF every morning for best results.',
        'time': '5d ago',
        'route': '/skincareRoutine',
      },
    ];

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
              child: Row(
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    fillColor: Colors.transparent,
                    icon: Icon(Icons.arrow_back_rounded,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24),
                    onPressed: () => context.safePop(),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Notifications',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.cormorantGaramond(
                              fontWeight: FontWeight.bold),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final notif = notifications[i];
                  return GestureDetector(
                    onTap: () => context.push(
                      notif['route'] as String,
                      extra: {
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 300),
                        ),
                      },
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color:
                                FlutterFlowTheme.of(context).alternate),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary
                                  .withAlpha(26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(notif['icon'] as IconData,
                                color:
                                    FlutterFlowTheme.of(context).primary,
                                size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      notif['title'] as String,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.dmSans(
                                                fontWeight: FontWeight.w600),
                                            color: FlutterFlowTheme.of(
                                                    context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    Text(
                                      notif['time'] as String,
                                      style: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .override(
                                            font: GoogleFonts.dmSans(),
                                            color: FlutterFlowTheme.of(
                                                    context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif['body'] as String,
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.dmSans(),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
