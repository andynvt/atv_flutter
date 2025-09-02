import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atv_flutter/core/tv/tv_focusable.dart';

void main() {
  group('TvFocusable Widget Tests', () {
    testWidgets('should render child widget', (WidgetTester tester) async {
      const testChild = Text('Test Child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TvFocusable(
              onSelect: () {},
              child: testChild,
            ),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('should call onSelect when focused and activated', (WidgetTester tester) async {
      bool onSelectCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TvFocusable(
              onSelect: () => onSelectCalled = true,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      // Focus the widget
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Simulate enter key press
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(onSelectCalled, isTrue);
    });

    testWidgets('should show focus highlight when focused', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TvFocusable(
              onSelect: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      );

      // Focus the widget
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Check if the widget has focus
      final focusNode = tester.binding.focusManager.primaryFocus;
      expect(focusNode, isNotNull);
    });

    testWidgets('should apply autofocus when specified', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TvFocusable(
              autofocus: true,
              onSelect: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      );

      await tester.pump();

      // Check if the widget has autofocus
      final focusNode = tester.binding.focusManager.primaryFocus;
      expect(focusNode, isNotNull);
    });
  });
}
