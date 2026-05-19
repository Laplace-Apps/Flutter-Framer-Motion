import 'dart:ui' show lerpDouble;

class MotionValues {
  const MotionValues({
    this.opacity,
    this.x,
    this.y,
    this.scale,
  });

  static const MotionValues identity = MotionValues(
    opacity: 1,
    x: 0,
    y: 0,
    scale: 1,
  );

  final double? opacity;
  final double? x;
  final double? y;
  final double? scale;

  static MotionValues lerp(MotionValues a, MotionValues b, double t) {
    return MotionValues(
      opacity: _lerpField(a.opacity, b.opacity, t),
      x: _lerpField(a.x, b.x, t),
      y: _lerpField(a.y, b.y, t),
      scale: _lerpField(a.scale, b.scale, t),
    );
  }

  MotionValues resolve() {
    return MotionValues(
      opacity: opacity ?? identity.opacity,
      x: x ?? identity.x,
      y: y ?? identity.y,
      scale: scale ?? identity.scale,
    );
  }

  static double? _lerpField(double? from, double? to, double t) {
    if (to == null) return from;
    final start = from ?? to;
    return lerpDouble(start, to, t);
  }
}
