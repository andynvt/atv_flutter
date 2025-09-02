import 'package:flutter/material.dart';
import 'tv_keys.dart';

// Custom intent for back navigation
class BackIntent extends Intent {
  const BackIntent();
}

class TvShortcuts extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBack;

  const TvShortcuts({
    super.key,
    required this.child,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        // Arrow keys for navigation
        SingleActivator(TvKeys.left): DirectionalFocusIntent(TraversalDirection.left),
        SingleActivator(TvKeys.right): DirectionalFocusIntent(TraversalDirection.right),
        SingleActivator(TvKeys.up): DirectionalFocusIntent(TraversalDirection.up),
        SingleActivator(TvKeys.down): DirectionalFocusIntent(TraversalDirection.down),

        // Select/Activate
        SingleActivator(TvKeys.select): ActivateIntent(),
        SingleActivator(TvKeys.enter): ActivateIntent(),
        SingleActivator(TvKeys.space): ActivateIntent(),

        // Back
        SingleActivator(TvKeys.back): BackIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            // This will be handled by individual widgets
            return null;
          }),
          BackIntent: CallbackAction<BackIntent>(onInvoke: (_) {
            onBack?.call();
            return null;
          }),
        },
        child: child,
      ),
    );
  }
}
