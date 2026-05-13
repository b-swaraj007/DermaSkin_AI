import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_util.dart';

import '/ar_features/ar_camera_screen.dart';
import '/index.dart';
import '/services/skin_analyzer.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => const SplashScreenWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => const SplashScreenWidget(),
        ),
        FFRoute(
          name: SplashScreenWidget.routeName,
          path: SplashScreenWidget.routePath,
          builder: (context, params) => const SplashScreenWidget(),
        ),
        FFRoute(
          name: OnboardingCarouselWidget.routeName,
          path: OnboardingCarouselWidget.routePath,
          builder: (context, params) => const OnboardingCarouselWidget(),
        ),
        FFRoute(
          name: SignUpWidget.routeName,
          path: SignUpWidget.routePath,
          builder: (context, params) => const SignUpWidget(),
        ),
        FFRoute(
          name: SignInWidget.routeName,
          path: SignInWidget.routePath,
          builder: (context, params) => const SignInWidget(),
        ),
        FFRoute(
          name: HomeDashboardWidget.routeName,
          path: HomeDashboardWidget.routePath,
          builder: (context, params) => const HomeDashboardWidget(),
        ),
        FFRoute(
          name: PreScanSetupWidget.routeName,
          path: PreScanSetupWidget.routePath,
          builder: (context, params) => const PreScanSetupWidget(),
        ),
        FFRoute(
          name: ARAnalysisWidget.routeName,
          path: ARAnalysisWidget.routePath,
          builder: (context, params) => const ARAnalysisWidget(),
        ),
        FFRoute(
          name: ScanProcessingWidget.routeName,
          path: ScanProcessingWidget.routePath,
          builder: (context, params) {
            // ScanProcessing is primarily entered via Navigator.pushReplacement
            // from the AR screen (which passes `analysisFuture` via
            // constructor). When landed here via deep-link we fall back to a
            // no-op resolved future so the screen can still be rendered.
            final extra = params.state.extra;
            final future = (extra is Map && extra['analysisFuture'] is Future)
                ? extra['analysisFuture']
                    as Future<Map<String, SkinParameterResult>>
                : Future<Map<String, SkinParameterResult>>.error(
                    'No analysis future supplied',
                  );
            return ScanProcessingWidget(analysisFuture: future);
          },
        ),
        FFRoute(
          name: SkinReportDetailWidget.routeName,
          path: SkinReportDetailWidget.routePath,
          builder: (context, params) => const SkinReportDetailWidget(),
        ),
        FFRoute(
          name: SkincareRoutineWidget.routeName,
          path: SkincareRoutineWidget.routePath,
          builder: (context, params) => const SkincareRoutineWidget(),
        ),
        FFRoute(
          name: UserProfileSettingsWidget.routeName,
          path: UserProfileSettingsWidget.routePath,
          builder: (context, params) => const UserProfileSettingsWidget(),
        ),
        FFRoute(
          name: SkinReportWidget.routeName,
          path: SkinReportWidget.routePath,
          builder: (context, params) => const SkinReportWidget(),
        ),
        FFRoute(
          name: PersonalizedRecommendationsWidget.routeName,
          path: PersonalizedRecommendationsWidget.routePath,
          builder: (context, params) => const PersonalizedRecommendationsWidget(),
        ),
        FFRoute(
          name: ProgressTrackerWidget.routeName,
          path: ProgressTrackerWidget.routePath,
          builder: (context, params) => const ProgressTrackerWidget(),
        ),
        FFRoute(
          name: ForgotPasswordWidget.routeName,
          path: ForgotPasswordWidget.routePath,
          builder: (context, params) => const ForgotPasswordWidget(),
        ),
        FFRoute(
          name: OtpVerificationWidget.routeName,
          path: OtpVerificationWidget.routePath,
          builder: (context, params) => OtpVerificationWidget(
            source: params.getParam('source', ParamType.string) ?? 'signup',
            email: params.getParam('email', ParamType.string) ?? '',
          ),
        ),
        FFRoute(
          name: ScanHistoryWidget.routeName,
          path: ScanHistoryWidget.routePath,
          builder: (context, params) => const ScanHistoryWidget(),
        ),
        FFRoute(
          name: IngredientDetailWidget.routeName,
          path: IngredientDetailWidget.routePath,
          builder: (context, params) => IngredientDetailWidget(
            ingredientName: params.getParam('ingredientName', ParamType.string) ?? 'Ingredient',
            concentration: params.getParam('concentration', ParamType.string) ?? '',
            targets: params.getParam('targets', ParamType.string) ?? '',
            matchScore: params.getParam('matchScore', ParamType.int) ?? 0,
          ),
        ),
        FFRoute(
          name: EditProfileWidget.routeName,
          path: EditProfileWidget.routePath,
          builder: (context, params) => const EditProfileWidget(),
        ),
        FFRoute(
          name: NotificationsWidget.routeName,
          path: NotificationsWidget.routePath,
          builder: (context, params) => const NotificationsWidget(),
        ),
        FFRoute(
          name: 'ArReportView',
          path: '/arReportView',
          builder: (context, params) => const ARCameraScreen(
            detectedIssues: [],
            initialMode: ARMode.skinZones,
          ),
        ),
        FFRoute(
          name: 'ArTreatmentPreview',
          path: '/arTreatmentPreview',
          builder: (context, params) => const ARCameraScreen(
            detectedIssues: [],
            initialMode: ARMode.treatmentPreview,
          ),
        ),
        FFRoute(
          name: SkinAnalysisResultWidget.routeName,
          path: SkinAnalysisResultWidget.routePath,
          builder: (context, params) {
            // Allow captured image paths to be forwarded through the
            // `extra` map so this screen can show captured thumbnails.
            final extra = params.state.extra;
            final caps = (extra is Map && extra['capturedPaths'] is Map)
                ? Map<String, String>.from(
                    (extra['capturedPaths'] as Map).map(
                      (k, v) => MapEntry(k.toString(), v.toString()),
                    ),
                  )
                : <String, String>{};
            return SkinAnalysisResultWidget(capturedPaths: caps);
          },
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is a route to pop, pop it so the user returns to the previous
    // page. Otherwise, fall back to the home dashboard rather than the splash
    // screen so the user is never sent back to the app's initial screen.
    if (canPop()) {
      pop();
    } else {
      go('/homeDashboard');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
