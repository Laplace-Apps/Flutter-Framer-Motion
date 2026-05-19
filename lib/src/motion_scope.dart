import 'package:flutter/widgets.dart';

import 'transition.dart';

class MotionStaggerRegistry {
  int _nextIndex = 0;

  void reset() => _nextIndex = 0;

  int register() => _nextIndex++;
}

class MotionScope extends InheritedWidget {
  const MotionScope({
    super.key,
    required this.animate,
    required this.orchestration,
    required this.registry,
    required this.disableAnimations,
    required super.child,
  });

  final String? animate;
  final MotionTransition? orchestration;
  final MotionStaggerRegistry registry;
  final bool disableAnimations;

  static MotionScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MotionScope>();
  }

  @override
  bool updateShouldNotify(MotionScope oldWidget) {
    return animate != oldWidget.animate ||
        orchestration != oldWidget.orchestration ||
        disableAnimations != oldWidget.disableAnimations;
  }
}
