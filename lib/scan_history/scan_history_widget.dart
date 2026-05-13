import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanHistoryWidget extends StatelessWidget {
  const ScanHistoryWidget({super.key});

  static const String routeName = 'ScanHistory';
  static const String routePath = '/scanHistory';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> scans = [
      {'date': 'Apr 22, 2026', 'score': 74, 'label': 'LATEST'},
      {'date': 'Apr 15, 2026', 'score': 70, 'label': ''},
      {'date': 'Apr 08, 2026', 'score': 72, 'label': ''},
      {'date': 'Mar 30, 2026', 'score': 68, 'label': ''},
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
                    'Scan History',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.bold),
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
                itemCount: scans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final scan = scans[i];
                  return GestureDetector(
                    onTap: () => context.push(
                      '/skinReport',
                      extra: {
                        'scanDate': scan['date'],
                        'scanId': i.toString(),
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 300),
                        ),
                      },
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${scan['score']}',
                              style: FlutterFlowTheme.of(context).labelLarge.override(
                                    font: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                                    color: FlutterFlowTheme.of(context).onPrimary,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      scan['date'] as String,
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            font: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    if ((scan['label'] as String).isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).tertiary,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Text(
                                          scan['label'] as String,
                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                                font: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                                                color: FlutterFlowTheme.of(context).primaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  'Score: ${scan['score']}/100',
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                        font: GoogleFonts.dmSans(),
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText),
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
