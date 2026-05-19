import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'motion_scope.dart';
import 'motion_values.dart';
import 'transition.dart';
import 'variants.dart';

/// Framer Motion-inspired widget with named [variants], [initial], and [animate].
class Motion extends StatefulWidget {
  const Motion({
    super.key,
    required this.variants,
    this.initial,
    this.animate,
    this.transition,
    required this.child,
  });

  final MotionVariants variants;
  final String? initial;
  final String? animate;
  final MotionTransition? transition;
  final Widget child;

  @override
  State<Motion> createState() => _MotionState();
}

class _MotionState extends State<Motion> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final MotionStaggerRegistry _registry = MotionStaggerRegistry();

  MotionValues _display = MotionValues.identity;
  String? _lastTargetKey;
  int? _staggerIndex;
  bool _registeredStagger = false;
  CurvedAnimation? _curved;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _applyInitialDisplay();
    SchedulerBinding.instance.addPostFrameCallback((_) => _syncAnimation());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_registeredStagger) {
      final scope = MotionScope.maybeOf(context);
      if (scope != null) {
        _staggerIndex = scope.registry.register();
        _registeredStagger = true;
      }
    }
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant Motion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate ||
        oldWidget.initial != widget.initial) {
      _syncAnimation();
    }
  }

  @override
  void dispose() {
    _curved?.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool get _disableAnimations {
    final scope = MotionScope.maybeOf(context);
    return (scope?.disableAnimations ?? false) ||
        (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
  }

  String? get _effectiveAnimateKey =>
      widget.animate ?? MotionScope.maybeOf(context)?.animate;

  void _applyInitialDisplay() {
    final initialKey = widget.initial;
    if (initialKey != null) {
      _display =
          resolveVariant(widget.variants, initialKey).values.resolve();
    }
  }

  void _syncAnimation() {
    if (!mounted || widget.variants.isEmpty) return;

    final targetKey = _effectiveAnimateKey ?? widget.initial;
    if (targetKey == null) return;
    if (targetKey == _lastTargetKey) return;
    if (_controller.isAnimating) return;

    final targetVariant = resolveVariant(widget.variants, targetKey);
    final targetValues = targetVariant.values.resolve();

    if (_disableAnimations) {
      setState(() {
        _display = targetValues;
        _lastTargetKey = targetKey;
        _controller.value = 1;
      });
      return;
    }

    final startValues = _lastTargetKey == null
        ? (widget.initial != null
            ? resolveVariant(widget.variants, widget.initial!)
                .values
                .resolve()
            : _display)
        : _display;

    final transition = _resolveTransition(targetVariant);
    final delay = _staggerDelay(transition);

    _curved?.dispose();
    _controller.duration = transition.duration;
    _curved = CurvedAnimation(parent: _controller, curve: transition.curve);

    void onTick() {
      if (!mounted) return;
      setState(() {
                final lerped =
            MotionValues.lerp(startValues, targetValues, _curved!.value);
        _display = MotionValues(
          opacity: lerped.opacity != null
              ? _clampOpacity(lerped.opacity!)
              : null,
          x: lerped.x,
          y: lerped.y,
          scale: lerped.scale,
        );
      });
    }

    _curved!.addListener(onTick);
    _controller.reset();

    Future<void>.delayed(delay, () {
      if (!mounted) return;
      _controller.forward().whenComplete(() {
        if (!mounted) return;
        _curved?.removeListener(onTick);
        setState(() {
          _display = targetValues;
          _lastTargetKey = targetKey;
        });
      });
    });
  }

  MotionTransition _resolveTransition(MotionVariant targetVariant) {
    final defaults = widget.transition ?? const MotionTransition();
    return defaults.merge(targetVariant.transition);
  }

  Duration _staggerDelay(MotionTransition transition) {
    final scope = MotionScope.maybeOf(context);
    if (scope?.orchestration != null && _staggerIndex != null) {
      return scope!.orchestration!
          .staggerDelayForChild(_staggerIndex!);
    }
    return transition.delay;
  }


  double _clampOpacity(double value) => value.clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    _registry.reset();

    final resolved = _display.resolve();
    final activeKey = _effectiveAnimateKey;
    final activeVariant =
        activeKey != null ? resolveVariant(widget.variants, activeKey) : null;

    Widget child = widget.child;
    if (activeKey != null) {
      child = MotionScope(
        animate: activeKey,
        orchestration: activeVariant?.transition,
        registry: _registry,
        disableAnimations: _disableAnimations,
        child: child,
      );
    }

    return Opacity(
      opacity: _clampOpacity(resolved.opacity!),
      child: Transform.translate(
        offset: Offset(resolved.x!, resolved.y!),
        child: Transform.scale(
          scale: resolved.scale!,
          child: child,
        ),
      ),
    );
  }
}




