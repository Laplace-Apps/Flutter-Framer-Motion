import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:motion_flutter/motion_flutter.dart';

/// Runs [initial] -> [animate] and supports replay via subtree remount.
class ReplayableMotion extends StatefulWidget {
  const ReplayableMotion({
    super.key,
    required this.variants,
    required this.child,
    this.autoPlay = true,
    this.transition,
  });

  final MotionVariants variants;
  final Widget child;
  final bool autoPlay;
  final MotionTransition? transition;

  @override
  State<ReplayableMotion> createState() => ReplayableMotionState();
}

class ReplayableMotionState extends State<ReplayableMotion> {
  String _animate = 'hidden';
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _animate = 'visible');
      });
    }
  }

  /// Remounts the motion subtree so stagger/hero replay from a clean state.
  Future<void> replay() async {
    setState(() {
      _generation++;
      _animate = 'hidden';
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _animate = 'visible');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Motion(
      key: ValueKey('replay-$_generation'),
      variants: widget.variants,
      initial: 'hidden',
      animate: _animate,
      transition: widget.transition,
      child: widget.child,
    );
  }
}
