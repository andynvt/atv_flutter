import 'package:flutter/material.dart';

/// Simple wrapper for TV navigation focus traversal
/// Uses default Flutter traversal policy for now
class TvTraversalPolicy {
  static FocusTraversalPolicy get defaultPolicy => OrderedTraversalPolicy();

  /// Helper method to create a FocusTraversalGroup with custom policy
  static Widget wrapWithTraversal({
    required Widget child,
    FocusTraversalPolicy? policy,
  }) {
    return FocusTraversalGroup(
      policy: policy ?? defaultPolicy,
      child: child,
    );
  }
}
