import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../theme/demo_theme.dart';
import '../widgets/demo_section.dart';

class DragSection extends StatelessWidget {
  const DragSection({super.key});

  static const _variants = <String, MotionVariant>{
    'rest': MotionVariant(values: MotionValues(scale: 1)),
    'dragging': MotionVariant(
      values: MotionValues(scale: 1.05),
      transition: MotionTransition(duration: Duration(milliseconds: 150)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Drag',
      description: 'drag + whileDrag — pan within constraints.',
      snippet: 'drag: true, dragConstraints: MotionDragConstraints(...)',
      onReplay: () {},
      preview: Motion(
        variants: _variants,
        initial: 'rest',
        animate: 'rest',
        drag: true,
        whileDrag: 'dragging',
        dragConstraints: const MotionDragConstraints(
          minX: -80,
          maxX: 80,
          minY: -40,
          maxY: 40,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: DemoTheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: DemoTheme.accent),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.drag_indicator, color: DemoTheme.accent, size: 20),
              SizedBox(width: 8),
              Text('Drag me', style: TextStyle(color: DemoTheme.text)),
            ],
          ),
        ),
      ),
    );
  }
}
