# motion_flutter

[![pub package](https://img.shields.io/pub/v/motion_flutter.svg)](https://pub.dev/packages/motion_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Framer Motion–inspired animation for Flutter** — variants, gestures, stagger, exit animations, springs, drag, and layout helpers.

Inspired by [Motion for React](https://motion.dev). Not affiliated with Framer.

## Features

| Feature | API |
|---------|-----|
| Variants | `variants`, `initial`, `animate` |
| Stagger | `delayChildren`, `staggerChildren` on parent variant |
| Gestures | `whileHover`, `whileTap`, `whileFocus`, `whileDrag` |
| Exit | `exit` + `MotionPresence` |
| Scroll | `whileInView`, `viewport` |
| Springs | `MotionTransition(type: spring, stiffness: …)` |
| Properties | `opacity`, `x`, `y`, `scale`, `rotate` |
| Drag | `drag`, `dragAxis`, `dragConstraints` |
| Layout | `layout` (size), `layoutId` (shared element via `Hero`) |
| A11y | Respects `MediaQuery.disableAnimations` |

### Not 1:1 with Framer Motion

- No automatic DOM-style layout engine (Flutter uses `Hero` for `layoutId`)
- Drag is pan-offset based (not full inertia/constraints API)
- No `width`/`height`/`backgroundColor` animation yet

## Installation

```bash
flutter pub add motion_flutter
```

```yaml
dependencies:
  motion_flutter: ^1.0.0
```

## Quick start

```dart
import 'package:motion_flutter/motion_flutter.dart';

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

## Gestures

```dart
Motion(
  variants: {
    'rest': MotionVariant(values: MotionValues(scale: 1)),
    'hover': MotionVariant(values: MotionValues(scale: 1.05)),
    'pressed': MotionVariant(values: MotionValues(scale: 0.95)),
  },
  initial: 'rest',
  animate: 'rest',
  whileHover: 'hover',
  whileTap: 'pressed',
  child: MyButton(),
);
```

## Exit animation

```dart
MotionPresence(
  child: visible
      ? Motion(
          variants: variants,
          initial: 'hidden',
          animate: 'visible',
          exit: 'hidden',
          child: Card(),
        )
      : null,
);
```

## Stagger

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
      Motion(variants: itemVariants, child: Tile1()),
      Motion(variants: itemVariants, child: Tile2()),
    ],
  ),
);
```

## Spring transition

```dart
MotionVariant(
  values: MotionValues(scale: 1),
  transition: MotionTransition(
    type: MotionTransitionType.spring,
    stiffness: 400,
    damping: 25,
  ),
);
```

## Scroll-triggered (`whileInView`)

```dart
Motion(
  variants: variants,
  initial: 'hidden',
  whileInView: 'visible',
  viewport: MotionViewport(once: true, amount: 0.2),
  child: FeatureCard(),
);
```

## Drag

```dart
Motion(
  variants: variants,
  animate: 'rest',
  drag: true,
  whileDrag: 'dragging',
  dragConstraints: MotionDragConstraints(maxX: 120, maxY: 80),
  child: Handle(),
);
```

## Live demo

```bash
git clone https://github.com/Laplace-Apps/Flutter-Framer-Motion.git
cd Flutter-Framer-Motion/example
flutter run -d chrome
```

## Compare

| | [flutter_animate](https://pub.dev/packages/flutter_animate) | **motion_flutter** |
|--|--|--|
| Style | Effect chains | Variant state machines |
| Stagger | Manual | Built-in parent orchestration |
| Gestures / exit | Limited | `whileHover`, `whileTap`, `MotionPresence` |

## Documentation

- [GitHub](https://github.com/Laplace-Apps/Flutter-Framer-Motion)
- [pub.dev](https://pub.dev/packages/motion_flutter)
- [CHANGELOG](CHANGELOG.md)

## License

MIT — see [LICENSE](LICENSE).
