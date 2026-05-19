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

    test('resolve fills defaults', () {
      const partial = MotionValues(opacity: 0.5);
      final resolved = partial.resolve();
      expect(resolved.opacity, 0.5);
      expect(resolved.scale, 1);
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
  });

  group('resolveVariant', () {
    test('returns identity for unknown key', () {
      const variants = <String, MotionVariant>{
        'visible': MotionVariant(values: MotionValues(opacity: 1)),
      };
      final v = resolveVariant(variants, 'missing');
      expect(v.values.opacity, 1);
    });
  });
}
