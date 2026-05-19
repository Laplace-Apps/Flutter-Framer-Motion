import 'package:flutter/material.dart';

import 'sections/fade_section.dart';
import 'sections/hero_section.dart';
import 'sections/slide_section.dart';
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
                  DemoSection(
                    title: 'Hero',
                    description:
                        'Full landing-style entrance: parent fade + staggered children on load.',
                    snippet: 'initial: hidden, animate: visible + staggerChildren',
                    onReplay: () => _heroKey.currentState?.replay(),
                    preview: HeroSection(motionKey: _heroKey),
                  ),
                  const SizedBox(height: 24),
                  const FadeSection(),
                  const SizedBox(height: 24),
                  const SlideSection(),
                  const SizedBox(height: 24),
                  const ScaleSection(),
                  const SizedBox(height: 24),
                  const StaggerSection(),
                  const SizedBox(height: 48),
                  const Center(
                    child: Text(
                      'motion_flutter · Inspired by Motion for React',
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
}

