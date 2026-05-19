import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../theme/demo_theme.dart';
import '../widgets/demo_section.dart';
import '../widgets/preview_box.dart';

class InViewSection extends StatelessWidget {
  const InViewSection({super.key});

  static const _variants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0, y: 40)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1, y: 0),
      transition: MotionTransition(duration: Duration(milliseconds: 600)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'While in view',
      description: 'Scroll this into view — fires once (viewport.once).',
      snippet: "whileInView: 'visible'",
      onReplay: () {},
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Scroll the gallery to reveal ↓',
            style: TextStyle(fontSize: 12, color: DemoTheme.muted),
          ),
          const SizedBox(height: 12),
          Motion(
            variants: _variants,
            initial: 'hidden',
            whileInView: 'visible',
            viewport: const MotionViewport(once: true, amount: 0.35),
            child: const PreviewBox('In view'),
          ),
        ],
      ),
    );
  }
}
