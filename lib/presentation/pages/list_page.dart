import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/list_vm.dart';
import '../widgets/tv_app_bar.dart';
import '../../core/tv/tv_shortcuts.dart';
import '../../core/tv/tv_focusable.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/movie_entity.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  void initState() {
    super.initState();
    // Load data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListViewModel>().loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TvShortcuts(
      onBack: () => context.pop(),
      child: Scaffold(
        appBar: const TvAppBar(title: 'List View'),
        body: Consumer<ListViewModel>(
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
                      onPressed: () => viewModel.loadMovies(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final movies = viewModel.movies;
            if (movies is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (movies is Error) {
              return Center(
                child: Text(
                  'Error: ${(movies as Error).message}',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              );
            }

            final moviesData = (movies as Success<List<MovieEntity>>).data;
            if (moviesData.isEmpty) {
              return const Center(
                child: Text('No movies available'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: moviesData.length,
              itemBuilder: (context, index) {
                final movie = moviesData[index];
                // final isFocused = index == viewModel.focusedIndex;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TvFocusable(
                    autofocus: index == 0,
                    onSelect: () {
                      context.go('/detail/${movie.id}');
                    },
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: AspectRatio(
                              aspectRatio: 2 / 3,
                              child: Image.network(
                                movie.posterUrl,
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
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    movie.title,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${movie.year} • ${movie.duration} min',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    movie.genres.join(', '),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
