import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../theme/demo_theme.dart';
import '../widgets/demo_section.dart';

class LayoutSection extends StatefulWidget {
  const LayoutSection({super.key});

  @override
  State<LayoutSection> createState() => _LayoutSectionState();
}

class _LayoutSectionState extends State<LayoutSection> {
  bool _expanded = false;

  static const _variants = <String, MotionVariant>{
    'a': MotionVariant(values: MotionValues(opacity: 1)),
    'b': MotionVariant(values: MotionValues(opacity: 1)),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Layout',
      description: 'layout: true animates size when child changes.',
      snippet: 'layout: true',
      onReplay: () => setState(() => _expanded = !_expanded),
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Motion(
            variants: _variants,
            initial: 'a',
            animate: _expanded ? 'b' : 'a',
            layout: true,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DemoTheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: DemoTheme.border),
              ),
              child: Text(
                _expanded
                    ? 'Expanded — more content.\nHeight animates.'
                    : 'Collapsed',
                style: const TextStyle(color: DemoTheme.text),
              ),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            child: const Text('Toggle', style: TextStyle(color: DemoTheme.accent)),
          ),
        ],
      ),
    );
  }
}
