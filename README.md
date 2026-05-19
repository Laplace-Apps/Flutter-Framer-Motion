# motion_flutter

Framer Motion-inspired **variants** and **stagger orchestration** for Flutter.

Inspired by [Motion for React](https://motion.dev). Not affiliated with Framer.

## Scope (v0.1)

| Supported | Not yet |
|-----------|---------|
| Named variants (`initial` / `animate`) | Layout / shared-element transitions |
| `opacity`, `x`, `y`, `scale` | `whileDrag`, `whileHover` |
| `delayChildren`, `staggerChildren` | 1:1 Motion React API parity |
| Reduced motion (`MediaQuery.disableAnimations`) | |

## Usage

```dart
Motion(
  variants: {
    'hidden': MotionVariant(values: MotionValues(opacity: 0, y: 24)),
    'visible': MotionVariant(values: MotionValues(opacity: 1, y: 0)),
  },
  initial: 'hidden',
  animate: 'visible',
  child: Text('Hello'),
);
```

Parent stagger:

```dart
Motion(
  variants: {
    'visible': MotionVariant(
      values: MotionValues(opacity: 1),
      transition: MotionTransition(
        delayChildren: 0.15,
        staggerChildren: 0.12,
      ),
    ),
  },
  animate: 'visible',
  child: Column(
    children: [
      Motion(variants: itemVariants, child: Card1()),
      Motion(variants: itemVariants, child: Card2()),
    ],
  ),
);
```

## Example

Developer-tools landing demo (Flutter web):

```bash
cd example
flutter run -d chrome
```

## Compare

- **[flutter_animate](https://pub.dev/packages/flutter_animate)** — effect chains on any widget
- **motion_flutter** — variant state machines + parent/child stagger propagation
