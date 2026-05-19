import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../theme/demo_theme.dart';
import '../widgets/demo_section.dart';
import '../widgets/replayable_motion.dart';

class StaggerSection extends StatefulWidget {
  const StaggerSection({super.key});

  @override
  State<StaggerSection> createState() => _StaggerSectionState();
}

class _StaggerSectionState extends State<StaggerSection> {
  final _motionKey = GlobalKey<ReplayableMotionState>();

  static const _parentVariants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1),
      transition: MotionTransition(
        duration: Duration(milliseconds: 300),
        delayChildren: 0.1,
        staggerChildren: 0.14,
      ),
    ),
  };

  static const _itemVariants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0, x: -24)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1, x: 0),
      transition: MotionTransition(duration: Duration(milliseconds: 400)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Stagger',
      description:
          'Parent orchestrates children with delayChildren and staggerChildren.',
      snippet: 'delayChildren: 0.1, staggerChildren: 0.14',
      onReplay: () => _motionKey.currentState?.replay(),
      preview: ReplayableMotion(
        key: _motionKey,
        variants: _parentVariants,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            4,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Motion(
                variants: _itemVariants,
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: DemoTheme.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: DemoTheme.border),
                  ),
                  child: Text(
                    'Item ${i + 1}',
                    style: const TextStyle(color: DemoTheme.text, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
