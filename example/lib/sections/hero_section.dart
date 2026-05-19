import 'package:flutter/material.dart';
import 'package:motion_flutter/motion_flutter.dart';

import '../theme/demo_theme.dart';
import '../widgets/replayable_motion.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({this.motionKey, super.key});

  final GlobalKey<ReplayableMotionState>? motionKey;

  static const containerVariants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1),
      transition: MotionTransition(
        duration: Duration(milliseconds: 400),
        staggerChildren: 0.1,
        delayChildren: 0.12,
      ),
    ),
  };

  static const itemVariants = <String, MotionVariant>{
    'hidden': MotionVariant(values: MotionValues(opacity: 0, y: 20)),
    'visible': MotionVariant(
      values: MotionValues(opacity: 1, y: 0),
      transition: MotionTransition(duration: Duration(milliseconds: 400)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return ReplayableMotion(
      key: motionKey,
      variants: containerVariants,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Motion(
            variants: itemVariants,
            child: const Text(
              'motion_flutter',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: DemoTheme.accent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Motion(
            variants: itemVariants,
            child: const Text(
              'Interactive motion gallery for Flutter web',
              style: TextStyle(fontSize: 14, color: DemoTheme.muted, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
