import 'package:flutter/widgets.dart';

class MotionDragConstraints {
  const MotionDragConstraints({
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  });

  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  Offset clamp(Offset offset) {
    return Offset(
      minX != null || maxX != null
          ? offset.dx.clamp(minX ?? double.negativeInfinity, maxX ?? double.infinity)
          : offset.dx,
      minY != null || maxY != null
          ? offset.dy.clamp(minY ?? double.negativeInfinity, maxY ?? double.infinity)
          : offset.dy,
    );
  }
}

enum MotionDragAxis { free, horizontal, vertical }
