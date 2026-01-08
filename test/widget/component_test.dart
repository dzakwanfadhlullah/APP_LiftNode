import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_flutter/core/shared_widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  group('PremiumButton Widget', () {
    testWidgets('should render title and handle press',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PremiumButton.primary(
                title: 'Click Me',
                onPress: () => pressed = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      // PremiumButton uses a GestureDetector or InkWell inside, not a standard ElevatedButton
      await tester.tap(find.text('Click Me'));
      await tester.pumpAndSettle();
      expect(pressed, true);
    });

    testWidgets('should show icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PremiumButton.primary(
              title: 'Icon Button',
              icon: LucideIcons.plus,
              onPress: null,
            ),
          ),
        ),
      );

      expect(find.byIcon(LucideIcons.plus), findsOneWidget);
    });
  });

  group('GlassCard Widget', () {
    testWidgets('should render child and handle tap',
        (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard.frosted(
              onTap: () => tapped = true,
              child: const Text('Inside Card'),
            ),
          ),
        ),
      );

      expect(find.text('Inside Card'), findsOneWidget);
      await tester.tap(find.text('Inside Card'));
      await tester.pumpAndSettle();
      expect(tapped, true);
    });
  });

  group('GymInput Widget', () {
    testWidgets('should handle text input', (WidgetTester tester) async {
      String value = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GymInput(
              hint: 'Search',
              onChanged: (v) => value = v,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Bench');
      await tester.pumpAndSettle();
      expect(value, 'Bench');
    });
  });

  group('GymListTile Widget', () {
    testWidgets('should render title and subtitle',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GymListTile(
              title: 'Pull Up',
              subtitle: 'Back',
            ),
          ),
        ),
      );

      expect(find.text('Pull Up'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    });
  });
}
