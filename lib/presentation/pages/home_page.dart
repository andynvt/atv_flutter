import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/home_vm.dart';
import '../widgets/rail_section.dart';
import '../widgets/tv_app_bar.dart';
import '../../core/tv/tv_shortcuts.dart';
import '../../core/tv/tv_traversal.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/movie_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadHomeRails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TvShortcuts(
      onBack: () => context.pop(),
      child: Scaffold(
        appBar: const TvAppBar(
          title: 'ATV Flutter',
          automaticallyImplyLeading: false,
        ),
        body: Consumer<HomeViewModel>(
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
                      onPressed: () => viewModel.loadHomeRails(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final rails = viewModel.rails;
            if (rails is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (rails is Error) {
              return Center(
                child: Text(
                  'Error: ${(rails as Error).message}',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              );
            }

            final railsData = (rails as Success<Map<String, List<MovieEntity>>>).data;
            if (railsData.isEmpty) {
              return const Center(
                child: Text('No content available'),
              );
            }

            return TvTraversalPolicy.wrapWithTraversal(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 24),
                itemCount: railsData.length,
                itemBuilder: (context, index) {
                  final railTitle = railsData.keys.elementAt(index);
                  final railMovies = railsData[railTitle] ?? [];
                  final isRailFocused = index == viewModel.focusedRailIndex;
                  final focusedItemIndex = isRailFocused ? viewModel.focusedItemIndexPerRail : 0;

                  return RailSection(
                    title: railTitle,
                    movies: railMovies,
                    focusedIndex: focusedItemIndex,
                    isFocused: isRailFocused,
                    onMovieTap: (movie) {
                      context.go('/detail/${movie.id}');
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
