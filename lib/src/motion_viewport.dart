/// Options for [Motion.whileInView] (Framer `viewport` prop).
class MotionViewport {
  const MotionViewport({
    this.once = false,
    this.amount = 0.1,
  });

  final bool once;
  final double amount;
}
