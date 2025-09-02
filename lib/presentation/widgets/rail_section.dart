import 'package:flutter/material.dart';
import '../../domain/entities/movie_entity.dart';
import 'poster_card.dart';

class RailSection extends StatelessWidget {
  final String title;
  final List<MovieEntity> movies;
  final Function(MovieEntity) onMovieTap;
  final int focusedIndex;
  final bool isFocused;

  const RailSection({
    super.key,
    required this.title,
    required this.movies,
    required this.onMovieTap,
    this.focusedIndex = 0,
    this.isFocused = false,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isFocused ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return SizedBox(
                width: 180,
                child: PosterCard(
                  autofocus: isFocused && index == focusedIndex,
                  title: movie.title,
                  imageUrl: movie.posterUrl,
                  onTap: () => onMovieTap(movie),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
