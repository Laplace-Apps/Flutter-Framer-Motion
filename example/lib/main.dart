import 'package:flutter/material.dart';

import 'sections/drag_section.dart';
import 'sections/exit_section.dart';
import 'sections/fade_section.dart';
import 'sections/focus_section.dart';
import 'sections/hero_section.dart';
import 'sections/hover_tap_section.dart';
import 'sections/inview_section.dart';
import 'sections/layout_id_section.dart';
import 'sections/layout_section.dart';
import 'sections/rotate_section.dart';
import 'sections/slide_section.dart';
import 'sections/spring_section.dart';
import 'sections/stagger_section.dart';
import 'theme/demo_theme.dart';
import 'widgets/demo_section.dart';
import 'widgets/replayable_motion.dart';

void main() {
  runApp(const MotionFlutterDemoApp());
}

class MotionFlutterDemoApp extends StatelessWidget {
  const MotionFlutterDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'motion_flutter',
      debugShowCheckedModeBanner: false,
      theme: DemoTheme.materialTheme(),
      home: const MotionGalleryPage(),
    );
  }
}

class MotionGalleryPage extends StatefulWidget {
  const MotionGalleryPage({super.key});

  @override
  State<MotionGalleryPage> createState() => _MotionGalleryPageState();
}

class _MotionGalleryPageState extends State<MotionGalleryPage> {
  final _heroKey = GlobalKey<ReplayableMotionState>();

  static const _gap = SizedBox(height: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'motion_flutter',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: DemoTheme.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gallery of every v1.0 feature — Replay or interact live.',
                    style: TextStyle(fontSize: 15, color: DemoTheme.muted, height: 1.5),
                  ),
                  _gap,
                  DemoSection(
                    title: 'Hero',
                    description: 'Parent fade + staggered children on load.',
                    snippet: 'staggerChildren, delayChildren',
                    onReplay: () => _heroKey.currentState?.replay(),
                    preview: HeroSection(motionKey: _heroKey),
                  ),
                  _gap,
                  _label('Basics'),
                  const FadeSection(),
                  _gap,
                  const SlideSection(),
                  _gap,
                  const ScaleSection(),
                  _gap,
                  const RotateSection(),
                  _gap,
                  const SpringSection(),
                  _gap,
                  _label('Orchestration'),
                  const StaggerSection(),
                  _gap,
                  _label('Gestures'),
                  const HoverTapSection(),
                  _gap,
                  const FocusSection(),
                  _gap,
                  const DragSection(),
                  _gap,
                  _label('Lifecycle & scroll'),
                  const ExitSection(),
                  _gap,
                  const SizedBox(height: 320),
                  const InViewSection(),
                  _gap,
                  _label('Layout'),
                  const LayoutSection(),
                  _gap,
                  const LayoutIdSection(),
                  const SizedBox(height: 48),
                  const Center(
                    child: Text(
                      'motion_flutter v1.0',
                      style: TextStyle(fontSize: 12, color: DemoTheme.muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: DemoTheme.muted,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
