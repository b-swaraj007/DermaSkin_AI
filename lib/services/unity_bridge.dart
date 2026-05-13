// ---------------------------------------------------------------------------
// UnityBridge
// ---------------------------------------------------------------------------
// Thin singleton wrapper around `flutter_unity_widget` that exposes a typed
// API for the two AR experiences backed by the Unity project at
// `unity/DermaScanAR/`:
//
//   1. Problem-zones heatmap overlay (ProblemZoneOverlay.cs)
//   2. After-treatment skin preview with smoothing shader
//      (TreatmentPreviewController.cs)
//
// Data contract (Flutter → Unity, UTF-8 JSON strings):
//   {
//     "mode": "problemZones" | "treatmentPreview",
//     "parameters": {
//        "<key>": { "score": <int 0..100>, "severity": "<string>" },
//        ...
//     },
//     "transitionSeconds": <double>   // treatmentPreview only
//   }
//
// Events (Unity → Flutter, also JSON strings dispatched to onUnityMessage):
//   { "event": "ready" }
//   { "event": "faceFound" }
//   { "event": "faceLost" }
//   { "event": "snapshotTaken", "payload": { "base64": "..." } }
//
// All service calls are wrapped in try/catch so Flutter screens never crash
// if the Unity runtime isn't yet attached (e.g. first boot before `Tools →
// Flutter → Export Android` has been run in Unity Editor).
// ---------------------------------------------------------------------------

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'skin_analyzer.dart';

// NOTE: `flutter_unity_widget` is intentionally NOT imported here. The plugin
// requires the exported Unity Android library at `android/unityLibrary/` to
// be present, which only exists AFTER running `Tools → Flutter → Export
// Android` inside the Unity Editor for the project at
// `unity/DermaScanAR/`. Until that export is produced, the app must build
// without the plugin, so this bridge is typed against an opaque controller
// (`Object?`) and falls back to a no-op when no Unity runtime is attached.
// After exporting Unity, re-add the import + replace the `dynamic`
// controller signatures with the real `UnityWidgetController` type.

/// Scene / mode identifiers accepted by the Unity bridge.
enum UnityScene { problemZones, treatmentPreview }

extension UnitySceneName on UnityScene {
  String get wireName {
    switch (this) {
      case UnityScene.problemZones:
        return 'problemZones';
      case UnityScene.treatmentPreview:
        return 'treatmentPreview';
    }
  }
}

/// Lightweight event envelope emitted by the Unity layer.
class UnityBridgeEvent {
  const UnityBridgeEvent({required this.name, this.payload});

  final String name;
  final Map<String, dynamic>? payload;

  @override
  String toString() => 'UnityBridgeEvent($name, $payload)';
}

typedef UnityEventListener = void Function(UnityBridgeEvent event);

class UnityBridge {
  UnityBridge._();

  static final UnityBridge instance = UnityBridge._();

  /// Unity `GameObject` name that hosts the `FlutterBridge.cs` script.
  /// Must match the name used in every Unity scene.
  static const String _bridgeGameObject = 'FlutterBridge';
  static const String _bridgeMethod = 'OnFlutterMessage';

  Object? _controller;
  final List<UnityEventListener> _listeners = <UnityEventListener>[];

  bool get isAttached => _controller != null;

  /// Called by the hosting Unity widget inside `onUnityCreated:`.
  /// Typed as [Object] so the rest of the app can compile without the
  /// `flutter_unity_widget` package being present.
  void attach(Object controller) {
    _controller = controller;
    if (kDebugMode) debugPrint('[UnityBridge] attached');
  }

  /// Called from the hosting widget's `dispose`.
  void detach() {
    _controller = null;
    _listeners.clear();
    if (kDebugMode) debugPrint('[UnityBridge] detached');
  }

  /// Subscribe to Unity → Flutter events. Returns an unsubscribe callback.
  VoidCallback addListener(UnityEventListener listener) {
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  /// Invoked by the hosting [UnityWidget]'s `onUnityMessage:` callback.
  /// Accepts either raw JSON strings or already-decoded maps.
  void handleIncoming(dynamic message) {
    try {
      Map<String, dynamic>? decoded;
      if (message is String) {
        decoded = jsonDecode(message) as Map<String, dynamic>;
      } else if (message is Map) {
        decoded = message.cast<String, dynamic>();
      }
      if (decoded == null) return;
      final event = UnityBridgeEvent(
        name: (decoded['event'] ?? 'unknown').toString(),
        payload: decoded['payload'] is Map
            ? (decoded['payload'] as Map).cast<String, dynamic>()
            : null,
      );
      for (final l in List<UnityEventListener>.from(_listeners)) {
        try {
          l(event);
        } catch (e) {
          if (kDebugMode) debugPrint('[UnityBridge] listener error: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[UnityBridge] handleIncoming error: $e');
    }
  }

  // --- high-level API ------------------------------------------------------

  /// Push the scan results to Unity and switch to the problem-zones scene.
  Future<void> sendProblemZones(Map<String, SkinParameterResult> results) {
    return _send(UnityScene.problemZones, results);
  }

  /// Push the scan results to Unity and switch to the treatment-preview scene.
  /// [transitionSeconds] controls how long Unity takes to animate the
  /// before → after blend when auto-play is triggered.
  Future<void> sendTreatmentPreview(
    Map<String, SkinParameterResult> results, {
    double transitionSeconds = 2.5,
  }) {
    return _send(
      UnityScene.treatmentPreview,
      results,
      extra: {'transitionSeconds': transitionSeconds},
    );
  }

  /// Push a manual blend factor (0.0 = original, 1.0 = fully treated) to
  /// drive the before/after slider in the treatment-preview scene.
  Future<void> setTreatmentBlend(double value) async {
    final clamped = value.clamp(0.0, 1.0).toDouble();
    await _postRaw(jsonEncode({'event': 'blend', 'value': clamped}));
  }

  /// Ask Unity to capture and return a PNG snapshot of the current AR view.
  Future<void> requestSnapshot() async {
    await _postRaw(jsonEncode({'event': 'snapshot'}));
  }

  Future<void> _send(
    UnityScene scene,
    Map<String, SkinParameterResult> results, {
    Map<String, dynamic>? extra,
  }) async {
    final payload = <String, dynamic>{
      'mode': scene.wireName,
      'parameters': _encodeParameters(results),
      if (extra != null) ...extra,
    };
    await _postRaw(jsonEncode(payload));
  }

  Future<void> _postRaw(String body) async {
    final controller = _controller;
    if (controller == null) {
      if (kDebugMode) {
        debugPrint('[UnityBridge] dropped message (no controller): $body');
      }
      return;
    }
    try {
      // Reflective invocation keeps this file free of a compile-time
      // dependency on `flutter_unity_widget`. When the plugin is enabled,
      // `controller` is a `UnityWidgetController` which exposes the
      // `postMessage(String gameObject, String method, String message)`
      // instance method matched below.
      final dynamic c = controller;
      await c.postMessage(_bridgeGameObject, _bridgeMethod, body);
    } catch (e) {
      if (kDebugMode) debugPrint('[UnityBridge] postMessage failed: $e');
    }
  }

  Map<String, Map<String, dynamic>> _encodeParameters(
      Map<String, SkinParameterResult> results) {
    return results.map(
      (key, value) => MapEntry(key, {
        'score': value.scoreInt,
        'severity': value.severity,
      }),
    );
  }
}
