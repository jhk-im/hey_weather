import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hey_weather/widgets/buttons/hey_custom_button.dart';

void main() {
  group('HeyCustomButton', () {
    testWidgets('renders text button correctly and calls onPressed',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeyCustomButton.text(
              text: const Text('Click Me'),
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      // Verify text is rendered
      expect(find.text('Click Me'), findsOneWidget);

      // Tap the button
      await tester.tap(find.text('Click Me'));
      await tester.pump();

      // Verify the callback is called
      expect(pressed, isTrue);
    });

    testWidgets('renders outlineTag button correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeyCustomButton.outlineTag(
              text: const Text('Outline'),
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify text is rendered
      expect(find.text('Outline'), findsOneWidget);

      // Verify outline is rendered
      final container = tester.widget<Container>(
        find.byType(HeyCustomButton).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });
  });
}
