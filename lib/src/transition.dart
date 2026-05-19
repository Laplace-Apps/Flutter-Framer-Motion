import 'package:flutter/animation.dart';

enum MotionTransitionType { tween, spring }

/// Timing and orchestration for a variant transition.
class MotionTransition {
  const MotionTransition({
    this.type = MotionTransitionType.tween,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.delay = Duration.zero,
    this.staggerChildren,
    this.delayChildren,
    this.stiffness = 300,
    this.damping = 20,
    this.mass = 1,
  });

  final MotionTransitionType type;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final double? staggerChildren;
  final double? delayChildren;
  final double stiffness;
  final double damping;
  final double mass;

  Duration staggerDelayForChild(int childIndex) {
    final staggerSec = staggerChildren ?? 0;
    final delaySec = delayChildren ?? 0;
    final orchestration = Duration(
      milliseconds: ((delaySec + childIndex * staggerSec) * 1000).round(),
    );
    return delay + orchestration;
  }

  SpringDescription get springDescription => SpringDescription(
        mass: mass,
        stiffness: stiffness,
        damping: damping,
      );

  MotionTransition merge(MotionTransition? other) {
    if (other == null) return this;
    return MotionTransition(
      type: other.type,
      duration: other.duration,
      curve: other.curve,
      delay: other.delay,
      staggerChildren: other.staggerChildren ?? staggerChildren,
      delayChildren: other.delayChildren ?? delayChildren,
      stiffness: other.stiffness,
      damping: other.damping,
      mass: other.mass,
    );
  }
}

