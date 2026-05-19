import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../widgets/demo_section.dart';
import '../widgets/preview_box.dart';
import '../widgets/replayable_motion.dart';

class FadeSection extends StatefulWidget {
  const FadeSection({super.key});

  @override
  State<FadeSection> createState() => _FadeSectionState();
}

class _FadeSectionState extends State<FadeSection> {
  final _motionKey = GlobalKey<ReplayableMotionState>();

  static const _variants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1),
      transition: MotionTransition(duration: Duration(milliseconds: 600)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Fade',
      description: 'Animate opacity only — ideal for subtle entrances.',
      snippet: 'MotionValues(opacity: 0) → MotionValues(opacity: 1)',
      onReplay: () => _motionKey.currentState?.replay(),
      preview: ReplayableMotion(
        key: _motionKey,
        variants: _variants,
        child: const PreviewBox('Fade in'),
      ),
    );
  }
}
