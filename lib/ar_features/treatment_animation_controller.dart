import 'package:flutter/material.dart';

enum TreatmentPhase { idle, showing, applying, transforming, result }

class TreatmentAnimationController {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  TreatmentPhase phase = TreatmentPhase.idle;
  VoidCallback? onPhaseChanged;

  TreatmentAnimationController({required TickerProvider vsync}) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 6),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        phase = TreatmentPhase.result;
        onPhaseChanged?.call();
      }
    });

    _controller.addListener(() {
      final value = _controller.value;
      TreatmentPhase newPhase;

      if (value < 0.15) {
        newPhase = TreatmentPhase.showing; // 0–0.9s: show current skin
      } else if (value < 0.45) {
        newPhase = TreatmentPhase.applying; // 0.9–2.7s: applying animation
      } else {
        newPhase = TreatmentPhase.transforming; // 2.7–6s: skin transforms
      }

      if (newPhase != phase) {
        phase = newPhase;
        onPhaseChanged?.call();
      }
    });
  }

  Animation<double> get animation => _animation;
  AnimationController get controller => _controller;

  /// Returns 0.0–1.0 progress for the transformation effect only
  double get transformProgress {
    if (_controller.value < 0.45) return 0.0;
    return ((_controller.value - 0.45) / 0.55).clamp(0.0, 1.0);
  }

  void start() {
    phase = TreatmentPhase.showing;
    _controller.forward(from: 0.0);
    onPhaseChanged?.call();
  }

  void reset() {
    _controller.reset();
    phase = TreatmentPhase.idle;
    onPhaseChanged?.call();
  }

  void dispose() => _controller.dispose();
}
