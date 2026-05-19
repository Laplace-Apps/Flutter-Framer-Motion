import 'motion_values.dart';
import 'transition.dart';

class MotionVariant {
  const MotionVariant({
    required this.values,
    this.transition,
  });

  final MotionValues values;
  final MotionTransition? transition;
}

typedef MotionVariants = Map<String, MotionVariant>;

MotionVariant resolveVariant(MotionVariants variants, String key) {
  return variants[key] ??
      const MotionVariant(values: MotionValues.identity);
}
