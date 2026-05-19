import 'package:flutter/material.dart';

import '../theme/demo_theme.dart';

class PreviewBox extends StatelessWidget {
  const PreviewBox(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: BoxDecoration(
        color: DemoTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DemoTheme.accent),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: DemoTheme.text,
        ),
      ),
    );
  }
}
