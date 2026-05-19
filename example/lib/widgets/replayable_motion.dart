import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _animate = 'visible');
      });
    }
  }

  Future<void> replay() async {
    setState(() => _animate = 'hidden');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (mounted) setState(() => _animate = 'visible');
  }

  @override
  Widget build(BuildContext context) {
    return Motion(
      variants: widget.variants,
      initial: 'hidden',
      animate: _animate,
      transition: widget.transition,
      child: widget.child,
    );
  }
}
