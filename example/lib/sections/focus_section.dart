import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../theme/demo_theme.dart';
import '../widgets/demo_section.dart';

class FocusSection extends StatelessWidget {
  const FocusSection({super.key});

  static const _variants = <String, MotionVariant>{
    'rest': MotionVariant(values: MotionValues(scale: 1)),
    'focused': MotionVariant(
      values: MotionValues(scale: 1.05),
      transition: MotionTransition(duration: Duration(milliseconds: 200)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Focus',
      description: 'whileFocus — Tab to the button below.',
      snippet: "whileFocus: 'focused'",
      onReplay: () {},
      preview: Motion(
        variants: _variants,
        initial: 'rest',
        animate: 'rest',
        whileFocus: 'focused',
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: DemoTheme.text,
            backgroundColor: DemoTheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          child: const Text('Focus me (Tab)'),
        ),
      ),
    );
  }
}
