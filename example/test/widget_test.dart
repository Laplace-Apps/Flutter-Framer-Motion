import 'package:flutter_test/flutter_test.dart';
import 'package:motion_flutter_example/main.dart';

void main() {
  testWidgets('gallery shows all motion sections', (tester) async {
    await tester.pumpWidget(const MotionFlutterDemoApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('motion_flutter'), findsOneWidget);
    expect(find.text('Fade'), findsOneWidget);
    expect(find.text('Slide'), findsOneWidget);
    expect(find.text('Scale'), findsOneWidget);
    expect(find.text('Stagger'), findsOneWidget);
    expect(find.text('Replay'), findsWidgets);
  });
}
