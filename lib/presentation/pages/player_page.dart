import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../viewmodels/player_vm.dart';
import '../../core/tv/tv_shortcuts.dart';
import '../../core/tv/tv_focusable.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/movie_entity.dart';

class PlayerPage extends StatefulWidget {
  final String movieId;

  const PlayerPage({
    super.key,
    required this.movieId,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void initState() {
    super.initState();
    // Load movie when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerViewModel>().loadMovie(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TvShortcuts(
      onBack: () => context.pop(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<PlayerViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            if (viewModel.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${viewModel.errorMessage}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
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
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            if (movie is Error) {
              return Center(
                child: Text(
                  'Error: ${(movie as Error).message}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final movieData = (movie as Success<MovieEntity?>).data;
            if (movieData == null) {
              return const Center(
                child: Text(
                  'Movie not found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Stack(
              children: [
                // Video player
                if (viewModel.isInitialized && viewModel.controller != null)
                  Center(
                    child: AspectRatio(
                      aspectRatio: viewModel.controller!.value.aspectRatio,
                      child: VideoPlayer(viewModel.controller!),
                    ),
                  )
                else
                  const Center(
                    child: Text(
                      'Loading video...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                // Video controls overlay
                if (viewModel.isInitialized)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Progress bar
                          Slider(
                            value: viewModel.position.inSeconds.toDouble(),
                            max: viewModel.duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              viewModel.seekTo(Duration(seconds: value.toInt()));
                            },
                            activeColor: Theme.of(context).colorScheme.primary,
                            inactiveColor: Colors.white.withOpacity(0.3),
                          ),

                          // Time and controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Time display
                              Text(
                                '${_formatDuration(viewModel.position)} / ${_formatDuration(viewModel.duration)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),

                              // Control buttons
                              Row(
                                children: [
                                  TvFocusable(
                                    onSelect: () => viewModel.seekBackward(),
                                    child: IconButton(
                                      onPressed: () => viewModel.seekBackward(),
                                      icon: const Icon(
                                        Icons.replay_10,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      tooltip: 'Rewind 10s',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  TvFocusable(
                                    onSelect: () => viewModel.togglePlayPause(),
                                    child: IconButton(
                                      onPressed: () => viewModel.togglePlayPause(),
                                      icon: Icon(
                                        viewModel.isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 48,
                                      ),
                                      tooltip: viewModel.isPlaying ? 'Pause' : 'Play',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  TvFocusable(
                                    onSelect: () => viewModel.seekForward(),
                                    child: IconButton(
                                      onPressed: () => viewModel.seekForward(),
                                      icon: const Icon(
                                        Icons.forward_10,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      tooltip: 'Forward 10s',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // Movie title overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 32,
                          ),
                          tooltip: 'Back',
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            movieData.title,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }
}
