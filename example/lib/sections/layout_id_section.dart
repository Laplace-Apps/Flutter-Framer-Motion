import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../theme/demo_theme.dart';
import '../widgets/demo_section.dart';

class LayoutIdSection extends StatefulWidget {
  const LayoutIdSection({super.key});

  @override
  State<LayoutIdSection> createState() => _LayoutIdSectionState();
}

class _LayoutIdSectionState extends State<LayoutIdSection> {
  bool _showA = true;

  static const _variants = <String, MotionVariant>{
    'show': MotionVariant(values: MotionValues(opacity: 1)),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Layout ID',
      description: 'layoutId shared element (Flutter Hero). Toggle to morph.',
      snippet: "layoutId: 'shared-card'",
      onReplay: () => setState(() => _showA = !_showA),
      preview: Column(
        children: [
          SizedBox(
            height: 72,
            child: Center(
              child: Motion(
                variants: _variants,
                initial: 'show',
                animate: 'show',
                layoutId: 'demo-shared-card',
                child: Container(
                  width: _showA ? 140 : 200,
                  height: _showA ? 44 : 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _showA ? DemoTheme.accent : DemoTheme.accentMuted,
                    borderRadius: BorderRadius.circular(_showA ? 8 : 20),
                  ),
                  child: Text(
                    _showA ? 'A' : 'B',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _showA = !_showA),
            child: const Text('Morph', style: TextStyle(color: DemoTheme.accent)),
          ),
        ],
      ),
    );
  }
}
