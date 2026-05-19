import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../theme/demo_theme.dart';
import '../widgets/demo_section.dart';
import '../widgets/preview_box.dart';

class ExitSection extends StatefulWidget {
  const ExitSection({super.key});

  @override
  State<ExitSection> createState() => _ExitSectionState();
}

class _ExitSectionState extends State<ExitSection> {
  bool _visible = true;

  static const _variants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0, scale: 0.9)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1, scale: 1),
      transition: MotionTransition(duration: Duration(milliseconds: 350)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Exit',
      description: 'MotionPresence + exit — toggle visibility to fade out.',
      snippet: "exit: 'hidden' wrapped in MotionPresence",
      onReplay: () => setState(() {
        _visible = false;
        Future<void>.delayed(const Duration(milliseconds: 50), () {
          if (mounted) setState(() => _visible = true);
        });
      }),
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MotionPresence(
            child: _visible
                ? Motion(
                    variants: _variants,
                    initial: 'hidden',
                    animate: 'visible',
                    exit: 'hidden',
                    child: const PreviewBox('Dismiss me'),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => setState(() => _visible = !_visible),
            child: const Text('Toggle', style: TextStyle(color: DemoTheme.accent)),
          ),
        ],
      ),
    );
  }
}
