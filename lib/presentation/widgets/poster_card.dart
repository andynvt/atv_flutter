import 'package:flutter/material.dart';
import '../../core/tv/tv_focusable.dart';

class PosterCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final bool autofocus;

  const PosterCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      autofocus: autofocus,
      onSelect: onTap,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                color: Colors.grey.shade800,
                child: const Center(
                  child: FlutterLogo(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
