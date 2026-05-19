import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../widgets/demo_section.dart';
import '../widgets/preview_box.dart';
import '../widgets/replayable_motion.dart';

class SpringSection extends StatefulWidget {
  const SpringSection({super.key});

  @override
  State<SpringSection> createState() => _SpringSectionState();
}

class _SpringSectionState extends State<SpringSection> {
  final _motionKey = GlobalKey<ReplayableMotionState>();

  static const _variants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0, scale: 0.6)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1, scale: 1),
      transition: MotionTransition(
        type: MotionTransitionType.spring,
        stiffness: 380,
        damping: 18,
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Spring',
      description: 'Physics spring — MotionTransitionType.spring.',
      snippet: 'type: spring, stiffness: 380, damping: 18',
      onReplay: () => _motionKey.currentState?.replay(),
      preview: ReplayableMotion(
        key: _motionKey,
        variants: _variants,
        child: const PreviewBox('Spring bounce'),
      ),
    );
  }
}
