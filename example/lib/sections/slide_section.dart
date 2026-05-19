import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../widgets/demo_section.dart';
import '../widgets/preview_box.dart';
import '../widgets/replayable_motion.dart';

class SlideSection extends StatefulWidget {
  const SlideSection({super.key});

  @override
  State<SlideSection> createState() => _SlideSectionState();
}

class _SlideSectionState extends State<SlideSection> {
  final _motionKey = GlobalKey<ReplayableMotionState>();

  static const _variants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0, y: 32)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1, y: 0),
      transition: MotionTransition(duration: Duration(milliseconds: 500)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Slide',
      description: 'Combine vertical offset with fade for classic reveal motion.',
      snippet: 'MotionValues(opacity: 0, y: 32) → opacity: 1, y: 0',
      onReplay: () => _motionKey.currentState?.replay(),
      preview: ReplayableMotion(
        key: _motionKey,
        variants: _variants,
        child: const PreviewBox('Slide up'),
      ),
    );
  }
}

class ScaleSection extends StatefulWidget {
  const ScaleSection({super.key});

  @override
  State<ScaleSection> createState() => _ScaleSectionState();
}

class _ScaleSectionState extends State<ScaleSection> {
  final _motionKey = GlobalKey<ReplayableMotionState>();

  static const _variants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0, scale: 0.85)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1, scale: 1),
      transition: MotionTransition(
        duration: Duration(milliseconds: 450),
        curve: Curves.easeOutBack,
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Scale',
      description: 'Scale and fade together — good for cards and modals.',
      snippet: 'MotionValues(opacity: 0, scale: 0.85) → scale: 1',
      onReplay: () => _motionKey.currentState?.replay(),
      preview: ReplayableMotion(
        key: _motionKey,
        variants: _variants,
        child: const PreviewBox('Scale in'),
      ),
    );
  }
}
