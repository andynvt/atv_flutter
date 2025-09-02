import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atv_flutter/core/tv/tv_traversal.dart';

void main() {
  group('TvTraversalPolicy Tests', () {
    test('should return default policy', () {
      final policy = TvTraversalPolicy.defaultPolicy;
      expect(policy, isA<OrderedTraversalPolicy>());
    });

    test('should wrap with traversal', () {
      const testWidget = Text('Test');

      final wrappedWidget = TvTraversalPolicy.wrapWithTraversal(
        child: testWidget,
      );

      expect(wrappedWidget, isA<FocusTraversalGroup>());
    });

    test('should wrap with custom policy', () {
      const testWidget = Text('Test');
      final customPolicy = OrderedTraversalPolicy();

      final wrappedWidget = TvTraversalPolicy.wrapWithTraversal(
        child: testWidget,
        policy: customPolicy,
      );

      expect(wrappedWidget, isA<FocusTraversalGroup>());
    });
  });
}
