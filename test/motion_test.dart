import 'package:flutter_test/flutter_test.dart';
import 'package:motion_flutter/motion_flutter.dart';

void main() {
  group('MotionValues', () {
    test('lerp interpolates toward target', () {
      const a = MotionValues(opacity: 0, y: 20);
      const b = MotionValues(opacity: 1, y: 0);
      final mid = MotionValues.lerp(a, b, 0.5);
      expect(mid.opacity, 0.5);
      expect(mid.y, 10);
    });

    test('lerp rotate', () {
      const a = MotionValues(rotate: 0);
      const b = MotionValues(rotate: 1.57);
      final mid = MotionValues.lerp(a, b, 0.5);
      expect(mid.rotate, closeTo(0.785, 0.001));
    });
  });

  group('MotionTransition', () {
    test('staggerDelayForChild accumulates delay', () {
      const t = MotionTransition(
        delayChildren: 0.2,
        staggerChildren: 0.1,
      );
      expect(t.staggerDelayForChild(0), const Duration(milliseconds: 200));
      expect(t.staggerDelayForChild(2), const Duration(milliseconds: 400));
    });

    test('spring type is configurable', () {
      const t = MotionTransition(
        type: MotionTransitionType.spring,
        stiffness: 500,
      );
      expect(t.type, MotionTransitionType.spring);
      expect(t.stiffness, 500);
    });
  });
}
