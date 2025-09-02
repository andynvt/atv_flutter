import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TvFocusable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSelect;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final double focusedScale;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final String? semanticsLabel;

  const TvFocusable({
    super.key,
    required this.child,
    this.onSelect,
    this.onFocusChange,
    this.autofocus = false,
    this.focusedScale = 1.04,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding = const EdgeInsets.all(6),
    this.semanticsLabel,
  });

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  final _node = FocusNode(debugLabel: 'TvFocusable');
  bool _focused = false;

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.select || key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      widget.onSelect?.call();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = _focused
        ? Border.all(width: 3, color: Theme.of(context).colorScheme.primary)
        : Border.all(color: Colors.transparent);

    return Focus(
      focusNode: _node,
      autofocus: widget.autofocus,
      onKeyEvent: _handleKey,
      onFocusChange: (hasFocus) {
        setState(() => _focused = hasFocus);
        widget.onFocusChange?.call(hasFocus);
      },
      child: AnimatedScale(
        scale: _focused ? widget.focusedScale : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: widget.padding,
          decoration: BoxDecoration(
            border: border,
            borderRadius: widget.borderRadius,
            boxShadow: _focused
                ? const [
                    BoxShadow(
                      blurRadius: 16,
                      offset: Offset(0, 8),
                      spreadRadius: 1,
                    )
                  ]
                : const [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
