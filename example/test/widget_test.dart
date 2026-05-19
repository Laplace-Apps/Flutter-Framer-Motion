import 'package:flutter_test/flutter_test.dart';
import 'package:motion_flutter_example/main.dart';

void main() {
  testWidgets('gallery lists all feature sections', (tester) async {
    await tester.pumpWidget(const MotionFlutterDemoApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    for (final title in [
      'Hero',
      'Fade',
      'Slide',
      'Scale',
      'Rotate',
      'Spring',
      'Stagger',
      'Hover & Tap',
      'Focus',
      'Drag',
      'Exit',
      'While in view',
      'Layout',
      'Layout ID',
    ]) {
      expect(find.text(title), findsOneWidget);
    }
  });
}
