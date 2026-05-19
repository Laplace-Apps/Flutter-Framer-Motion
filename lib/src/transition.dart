import 'package:flutter/animation.dart';

class MotionTransition {
  const MotionTransition({
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.delay = Duration.zero,
    this.staggerChildren,
    this.delayChildren,
  });

  final Duration duration;
  final Curve curve;
  final Duration delay;
  final double? staggerChildren;
  final double? delayChildren;

  Duration staggerDelayForChild(int childIndex) {
    final staggerSec = staggerChildren ?? 0;
    final delaySec = delayChildren ?? 0;
    final orchestration = Duration(
      milliseconds: ((delaySec + childIndex * staggerSec) * 1000).round(),
    );
    return delay + orchestration;
  }

  MotionTransition merge(MotionTransition? other) {
    if (other == null) return this;
    return MotionTransition(
      duration: other.duration,
      curve: other.curve,
      delay: other.delay,
      staggerChildren: other.staggerChildren ?? staggerChildren,
      delayChildren: other.delayChildren ?? delayChildren,
    );
  }
}
