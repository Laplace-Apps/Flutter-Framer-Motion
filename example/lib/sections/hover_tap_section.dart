import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../widgets/demo_section.dart';
import '../widgets/preview_box.dart';

class HoverTapSection extends StatelessWidget {
  const HoverTapSection({super.key});

  static const _variants = <String, MotionVariant>{
    'rest': MotionVariant(values: MotionValues(scale: 1)),
    'hover': MotionVariant(
      values: MotionValues(scale: 1.06),
      transition: MotionTransition(duration: Duration(milliseconds: 200)),
    ),
    'pressed': MotionVariant(
      values: MotionValues(scale: 0.94),
      transition: MotionTransition(duration: Duration(milliseconds: 100)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Hover & Tap',
      description: 'whileHover and whileTap — move pointer over the box or press it.',
      snippet: "whileHover: 'hover', whileTap: 'pressed'",
      onReplay: () {},
      preview: Motion(
        variants: _variants,
        initial: 'rest',
        animate: 'rest',
        whileHover: 'hover',
        whileTap: 'pressed',
        child: const PreviewBox('Hover / press me'),
      ),
    );
  }
}

