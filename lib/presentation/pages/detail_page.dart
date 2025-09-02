import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/detail_vm.dart';
import '../widgets/tv_app_bar.dart';
import '../../core/tv/tv_shortcuts.dart';
import '../../core/tv/tv_focusable.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/movie_entity.dart';

class DetailPage extends StatefulWidget {
  final String movieId;

  const DetailPage({
    super.key,
    required this.movieId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    // Load movie when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailViewModel>().loadMovie(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TvShortcuts(
      onBack: () => context.pop(),
      child: Scaffold(
        appBar: const TvAppBar(title: 'Movie Details'),
        body: Consumer<DetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (viewModel.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${viewModel.errorMessage}',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.loadMovie(widget.movieId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final movie = viewModel.movie;
            if (movie is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (movie is Error) {
              return Center(
                child: Text(
                  'Error: ${(movie as Error).message}',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              );
            }

            final movieData = (movie as Success<MovieEntity?>).data;
            if (movieData == null) {
              return const Center(
                child: Text('Movie not found'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Backdrop image
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        movieData.backdropUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: Colors.grey.shade800,
                            child: const Center(child: FlutterLogo()),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Movie info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      Container(
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            movieData.posterUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: Colors.grey.shade800,
                                child: const Center(child: FlutterLogo()),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movieData.title,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  '${movieData.year}',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${movieData.duration} min',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${movieData.rating}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              children: movieData.genres.map((genre) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    genre,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Director: ${movieData.director}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Cast: ${movieData.cast.join(', ')}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Overview',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              movieData.overview,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      TvFocusable(
                        autofocus: true,
                        onSelect: () {
                          context.go('/player/${movieData.id}');
                        },
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go('/player/${movieData.id}');
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TvFocusable(
                        onSelect: () {
                          // TODO: Implement add to list functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to list')),
                          );
                        },
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement add to list functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to list')),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add to List'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TvFocusable(
                        onSelect: () {
                          // TODO: Implement more info functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('More info coming soon')),
                          );
                        },
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement more info functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('More info coming soon')),
                            );
                          },
                          icon: const Icon(Icons.info),
                          label: const Text('More Info'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
