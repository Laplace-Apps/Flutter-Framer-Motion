import 'dart:math' as math;

import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'motion_drag.dart';
import 'motion_presence.dart';
import 'motion_scope.dart';
import 'motion_values.dart';
import 'motion_viewport.dart';
import 'transition.dart';
import 'variants.dart';

/// Framer Motion-inspired widget with variants, gestures, and orchestration.
class Motion extends StatefulWidget {
  const Motion({
    super.key,
    required this.variants,
    this.initial,
    this.initialDisabled = false,
    this.animate,
    this.exit,
    this.whileHover,
    this.whileTap,
    this.whileFocus,
    this.whileDrag,
    this.whileInView,
    this.viewport = const MotionViewport(),
    this.transition,
    this.layout = false,
    this.layoutId,
    this.drag = false,
    this.dragAxis = MotionDragAxis.free,
    this.dragConstraints,
    this.onAnimationStart,
    this.onAnimationComplete,
    required this.child,
  });

  final MotionVariants variants;
  final String? initial;
  final bool initialDisabled;
  final String? animate;
  final String? exit;
  final String? whileHover;
  final String? whileTap;
  final String? whileFocus;
  final String? whileDrag;
  final String? whileInView;
  final MotionViewport viewport;
  final MotionTransition? transition;
  final bool layout;
  final String? layoutId;
  final bool drag;
  final MotionDragAxis dragAxis;
  final MotionDragConstraints? dragConstraints;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationComplete;
  final Widget child;

  @override
  State<Motion> createState() => MotionState();
}

class MotionState extends State<Motion> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final MotionStaggerRegistry _registry = MotionStaggerRegistry();

  MotionValues _display = MotionValues.identity;
  String? _lastTargetKey;
  int? _staggerIndex;
  bool _registeredStagger = false;
  bool _appliedScopeInitial = false;

  bool _hovering = false;
  bool _pressing = false;
  bool _focused = false;
  bool _dragging = false;
  bool _inView = false;
  bool _inViewTriggered = false;
  Offset _dragOffset = Offset.zero;

  final GlobalKey _inViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    if (!widget.initialDisabled && widget.initial != null) {
      _display = resolveVariant(widget.variants, widget.initial!)
          .values
          .resolve();
    } else if (widget.initialDisabled) {
      final key = widget.animate ?? widget.initial;
      if (key != null) {
        _display = resolveVariant(widget.variants, key).values.resolve();
        _lastTargetKey = key;
      }
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkInView();
      _syncAnimation();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_appliedScopeInitial && widget.initial == null) {
      _appliedScopeInitial = true;
      final scopeInitial = MotionScope.maybeOf(context)?.initial;
      if (scopeInitial != null && !widget.initialDisabled) {
        _display =
            resolveVariant(widget.variants, scopeInitial).values.resolve();
      }
    }
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
        oldWidget.initial != widget.initial ||
        oldWidget.exit != widget.exit ||
        oldWidget.whileHover != widget.whileHover ||
        oldWidget.whileTap != widget.whileTap ||
        oldWidget.whileFocus != widget.whileFocus ||
        oldWidget.whileDrag != widget.whileDrag ||
        oldWidget.whileInView != widget.whileInView) {
      _syncAnimation();
    }
  }

  @override
  void dispose() {
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

  String? get _effectiveInitialKey =>
      widget.initial ?? MotionScope.maybeOf(context)?.initial;

  String? _resolveTargetKey() {
    final presence = MotionPresenceScope.maybeOf(context);
    if (presence?.exiting == true && widget.exit != null) {
      return widget.exit;
    }
    if (_dragging && widget.whileDrag != null) return widget.whileDrag;
    if (_pressing && widget.whileTap != null) return widget.whileTap;
    if (_hovering && widget.whileHover != null) return widget.whileHover;
    if (_focused && widget.whileFocus != null) return widget.whileFocus;
    if (_inView && widget.whileInView != null) return widget.whileInView;
    return _effectiveAnimateKey ?? widget.initial;
  }

  
  void _checkInView() {
    if (widget.whileInView == null || !mounted) return;
    if (widget.viewport.once && _inViewTriggered) return;

    final box = _inViewKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final offset = box.localToGlobal(Offset.zero);
    final size = MediaQuery.sizeOf(context);
    final visibleHeight = math.max(
      0.0,
      math.min(offset.dy + box.size.height, size.height) -
          math.max(offset.dy, 0.0),
    );
    final ratio = visibleHeight / box.size.height;
    final visible = ratio >= widget.viewport.amount;

    if (visible != _inView) {
      setState(() => _inView = visible);
      if (visible) _inViewTriggered = true;
      _syncAnimation();
    }
  }

  void _syncAnimation() {
    if (!mounted || widget.variants.isEmpty) return;

    final targetKey = _resolveTargetKey();
    if (targetKey == null) return;
    if (targetKey == _lastTargetKey && _controller.isCompleted) return;

    final targetVariant = resolveVariant(widget.variants, targetKey);
    final targetValues = _applyDragOffset(targetVariant.values.resolve());

    if (_disableAnimations) {
      setState(() {
        _display = targetValues;
        _lastTargetKey = targetKey;
        _controller.value = 1;
      });
      _notifyComplete(targetKey);
      return;
    }

    // Start from the previous variant's resolved values (not stale end state
    // during stagger delay).
    final MotionValues startValues;
    if (_lastTargetKey != null) {
      startValues =
          resolveVariant(widget.variants, _lastTargetKey!).values.resolve();
    } else if (_effectiveInitialKey != null && !widget.initialDisabled) {
      startValues = resolveVariant(widget.variants, _effectiveInitialKey!)
          .values
          .resolve();
    } else {
      startValues = _display.resolve();
    }

    final transition = _resolveTransition(targetVariant);
    final delay = _staggerDelay(transition);

    widget.onAnimationStart?.call();
    _controller.stop();
    _controller.reset();

    // Hold at animation start during orchestration delay (stagger).
    setState(() => _display = startValues);

    Future<void>.delayed(delay, () {
      if (!mounted) return;

      void applyProgress(double t) {
        if (!mounted) return;
        final clamped = t.clamp(0.0, 1.0);
        final lerped = MotionValues.lerp(startValues, targetValues, clamped);
        setState(() {
          _display = MotionValues(
            opacity: lerped.opacity != null
                ? _clampOpacity(lerped.opacity!)
                : null,
            x: lerped.x,
            y: lerped.y,
            scale: lerped.scale,
            rotate: lerped.rotate,
          );
        });
      }

      if (transition.type == MotionTransitionType.spring) {
        void springTick() => applyProgress(_controller.value);
        _controller.addListener(springTick);
        _controller.animateWith(
          SpringSimulation(transition.springDescription, 0, 1, 0),
        ).whenComplete(() {
          if (!mounted) return;
          _controller.removeListener(springTick);
          setState(() {
            _display = targetValues;
            _lastTargetKey = targetKey;
          });
          _notifyComplete(targetKey);
        });
      } else {
        _controller.duration = transition.duration;
        final curved = CurvedAnimation(
          parent: _controller,
          curve: transition.curve,
        );
        void curvedTick() => applyProgress(curved.value);
        curved.addListener(curvedTick);
        _controller.forward().whenComplete(() {
          if (!mounted) return;
          curved.removeListener(curvedTick);
          curved.dispose();
          setState(() {
            _display = targetValues;
            _lastTargetKey = targetKey;
          });
          _notifyComplete(targetKey);
        });
      }
    });
  }

  void _notifyComplete(String targetKey) {
    widget.onAnimationComplete?.call();
    final presence = MotionPresenceScope.maybeOf(context);
    if (presence?.exiting == true && targetKey == widget.exit) {
      presence?.onExitComplete();
    }
  }

  MotionValues _applyDragOffset(MotionValues values) {
    if (!_dragging) return values;
    return MotionValues(
      opacity: values.opacity,
      x: (values.x ?? 0) + _dragOffset.dx,
      y: (values.y ?? 0) + _dragOffset.dy,
      scale: values.scale,
      rotate: values.rotate,
    );
  }

  MotionTransition _resolveTransition(MotionVariant targetVariant) {
    final defaults = widget.transition ?? const MotionTransition();
    return defaults.merge(targetVariant.transition);
  }

  Duration _staggerDelay(MotionTransition transition) {
    final scope = MotionScope.maybeOf(context);
    if (scope?.orchestration != null && _staggerIndex != null) {
      return scope!.orchestration!.staggerDelayForChild(_staggerIndex!);
    }
    return transition.delay;
  }

  double _clampOpacity(double value) => value.clamp(0.0, 1.0);

  void _onPanUpdate(DragUpdateDetails details) {
    var delta = details.delta;
    switch (widget.dragAxis) {
      case MotionDragAxis.horizontal:
        delta = Offset(delta.dx, 0);
      case MotionDragAxis.vertical:
        delta = Offset(0, delta.dy);
      case MotionDragAxis.free:
        break;
    }
    setState(() {
      _dragOffset += delta;
      final constraints = widget.dragConstraints;
      if (constraints != null) {
        _dragOffset = constraints.clamp(_dragOffset);
      }
      _dragging = true;
    });
    _syncAnimation();
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _dragging = false;
      _dragOffset = Offset.zero;
    });
    _syncAnimation();
  }

  @override
  Widget build(BuildContext context) {
    _registry.reset();

    final resolved = _applyDragOffset(_display.resolve());
    final activeKey = _resolveTargetKey();
    final activeVariant =
        activeKey != null ? resolveVariant(widget.variants, activeKey) : null;

    Widget child = widget.child;
    if (activeKey != null) {
      child = MotionScope(
        animate: activeKey,
        initial: widget.initial,
        orchestration: activeVariant?.transition,
        registry: _registry,
        disableAnimations: _disableAnimations,
        child: child,
      );
    }

    if (widget.layout) {
      child = AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: child,
      );
    }

    if (widget.layoutId != null) {
      child = Hero(tag: widget.layoutId!, child: child);
    }

    child = Opacity(
      opacity: _clampOpacity(resolved.opacity!),
      child: Transform.translate(
        offset: Offset(resolved.x!, resolved.y!),
        child: Transform.rotate(
          angle: resolved.rotate!,
          child: Transform.scale(
            scale: resolved.scale!,
            child: child,
          ),
        ),
      ),
    );

    child = KeyedSubtree(key: _inViewKey, child: child);

    if (widget.drag) {
      child = GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onPanCancel: () => _onPanEnd(DragEndDetails(velocity: Velocity.zero)),
        child: child,
      );
    }

    child = MouseRegion(
      onEnter: (_) {
        if (widget.whileHover == null) return;
        setState(() => _hovering = true);
        _syncAnimation();
      },
      onExit: (_) {
        if (widget.whileHover == null) return;
        setState(() => _hovering = false);
        _syncAnimation();
      },
      child: child,
    );

    child = Listener(
      onPointerDown: (_) {
        if (widget.whileTap == null) return;
        setState(() => _pressing = true);
        _syncAnimation();
      },
      onPointerUp: (_) {
        if (widget.whileTap == null) return;
        setState(() => _pressing = false);
        _syncAnimation();
      },
      onPointerCancel: (_) {
        if (widget.whileTap == null) return;
        setState(() => _pressing = false);
        _syncAnimation();
      },
      child: child,
    );

    child = Focus(
      onFocusChange: (focused) {
        if (widget.whileFocus == null) return;
        setState(() => _focused = focused);
        _syncAnimation();
      },
      child: child,
    );

    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        _checkInView();
        return false;
      },
      child: child,
    );
  }
}






