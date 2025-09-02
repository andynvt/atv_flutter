import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/grid_vm.dart';
import '../widgets/poster_card.dart';
import '../widgets/tv_app_bar.dart';
import '../../core/tv/tv_shortcuts.dart';
import '../../core/tv/tv_focusable.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/movie_entity.dart';

class GridPage extends StatefulWidget {
  const GridPage({super.key});

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  @override
  void initState() {
    super.initState();
    // Load data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GridViewModel>().loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TvShortcuts(
      onBack: () => context.pop(),
      child: Scaffold(
        appBar: const TvAppBar(title: 'Grid View'),
        body: Consumer<GridViewModel>(
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

            return GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: moviesData.length,
              itemBuilder: (context, index) {
                final movie = moviesData[index];

                return TvFocusable(
                  autofocus: index == 0,
                  onSelect: () {
                    context.go('/detail/${movie.id}');
                  },
                  child: PosterCard(
                    title: movie.title,
                    imageUrl: movie.posterUrl,
                    onTap: () {
                      context.go('/detail/${movie.id}');
                    },
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
