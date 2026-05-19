import 'package:flutter/material.dart';

import '../theme/demo_theme.dart';

class DemoSection extends StatelessWidget {
  const DemoSection({
    super.key,
    required this.title,
    required this.description,
    required this.snippet,
    required this.preview,
    required this.onReplay,
  });

  final String title;
  final String description;
  final String snippet;
  final Widget preview;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DemoTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DemoTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: DemoTheme.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: DemoTheme.muted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DemoTheme.codeBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: DemoTheme.border),
            ),
            child: Text(
              snippet,
              style: const TextStyle(
                fontSize: 12,
                color: DemoTheme.accentMuted,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 120),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: DemoTheme.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: DemoTheme.border),
                  ),
                  alignment: Alignment.center,
                  child: preview,
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: DemoTheme.border,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: onReplay,
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.replay_rounded, color: DemoTheme.accent, size: 22),
                        SizedBox(height: 6),
                        Text(
                          'Replay',
                          style: TextStyle(
                            fontSize: 11,
                            color: DemoTheme.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
