import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

/// Animatable visual properties for a [Motion] widget.
class MotionValues {
  const MotionValues({
    this.opacity,
    this.x,
    this.y,
    this.scale,
    this.rotate,
  });

  static const MotionValues identity = MotionValues(
    opacity: 1,
    x: 0,
    y: 0,
    scale: 1,
    rotate: 0,
  );

  final double? opacity;
  final double? x;
  final double? y;
  final double? scale;

  /// Rotation in radians.
  final double? rotate;

  static MotionValues lerp(MotionValues a, MotionValues b, double t) {
    return MotionValues(
      opacity: _lerpField(a.opacity, b.opacity, t),
      x: _lerpField(a.x, b.x, t),
      y: _lerpField(a.y, b.y, t),
      scale: _lerpField(a.scale, b.scale, t),
      rotate: _lerpAngle(a.rotate, b.rotate, t),
    );
  }

  MotionValues resolve() {
    return MotionValues(
      opacity: opacity ?? identity.opacity,
      x: x ?? identity.x,
      y: y ?? identity.y,
      scale: scale ?? identity.scale,
      rotate: rotate ?? identity.rotate,
    );
  }

  static double? _lerpField(double? from, double? to, double t) {
    if (to == null) return from;
    final start = from ?? to;
    return lerpDouble(start, to, t);
  }

  static double? _lerpAngle(double? from, double? to, double t) {
    if (to == null) return from;
    final start = from ?? to;
    return start + (to - start) * t;
  }

  double rotateDegrees() => (rotate ?? 0) * 180 / math.pi;
}
