import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../widgets/demo_section.dart';
import '../widgets/preview_box.dart';
import '../widgets/replayable_motion.dart';

class RotateSection extends StatefulWidget {
  const RotateSection({super.key});

  @override
  State<RotateSection> createState() => _RotateSectionState();
}

class _RotateSectionState extends State<RotateSection> {
  final _motionKey = GlobalKey<ReplayableMotionState>();

  static const _variants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0, rotate: -0.25)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1, rotate: 0),
      transition: MotionTransition(duration: Duration(milliseconds: 500)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Rotate',
      description: 'Animate rotation in radians with fade.',
      snippet: 'MotionValues(rotate: -0.25) → rotate: 0',
      onReplay: () => _motionKey.currentState?.replay(),
      preview: ReplayableMotion(
        key: _motionKey,
        variants: _variants,
        child: const PreviewBox('Rotate in'),
      ),
    );
  }
}
