import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/movie_entity.dart';
import '../../data/repositories/movie_repository.dart';
import '../../core/utils/result.dart';

/// ViewModel for Player page
class PlayerViewModel extends ChangeNotifier {
  final MovieRepository _repository;

  PlayerViewModel(this._repository);

  // State
  Result<MovieEntity?> _movie = const Loading();
  bool _isLoading = false;
  String? _errorMessage;

  // Video player state
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isInitialized = false;

  // Getters
  Result<MovieEntity?> get movie => _movie;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  VideoPlayerController? get controller => _controller;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isInitialized => _isInitialized;

  /// Load movie by ID
  Future<void> loadMovie(String id) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.getMovieById(id);
      _movie = result;

      if (result is Error) {
        _setError((result as Error).message);
      } else if (result is Success) {
        final movie = (result as Success<MovieEntity?>).data;
        if (movie != null) {
          await _initializeVideoPlayer(movie);
        }
      }
    } catch (e) {
      _setError('Unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  /// Initialize video player
  Future<void> _initializeVideoPlayer(MovieEntity movie) async {
    try {
      // For demo purposes, we'll use a sample video URL
      // In a real app, you'd get the actual video URL from the movie entity
      const sampleVideoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

      _controller = VideoPlayerController.networkUrl(Uri.parse(sampleVideoUrl));

      await _controller!.initialize();

      _duration = _controller!.value.duration;
      _isInitialized = true;

      // Listen to position changes
      _controller!.addListener(_onVideoPlayerUpdate);

      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize video player');
    }
  }

  /// Toggle play/pause
  void togglePlayPause() {
    if (_controller != null && _isInitialized) {
      if (_isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
      _isPlaying = !_isPlaying;
      notifyListeners();
    }
  }

  /// Seek forward
  void seekForward() {
    if (_controller != null && _isInitialized) {
      final newPosition = _position + const Duration(seconds: 10);
      final seekPosition = newPosition > _duration ? _duration : newPosition;
      _controller!.seekTo(seekPosition);
    }
  }

  /// Seek backward
  void seekBackward() {
    if (_controller != null && _isInitialized) {
      final newPosition = _position - const Duration(seconds: 10);
      final seekPosition = newPosition < Duration.zero ? Duration.zero : newPosition;
      _controller!.seekTo(seekPosition);
    }
  }

  /// Seek to specific position
  void seekTo(Duration position) {
    if (_controller != null && _isInitialized) {
      _controller!.seekTo(position);
    }
  }

  /// Video player update listener
  void _onVideoPlayerUpdate() {
    if (_controller != null && _isInitialized) {
      _position = _controller!.value.position;
      _isPlaying = _controller!.value.isPlaying;
      notifyListeners();
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _controller?.removeListener(_onVideoPlayerUpdate);
    _controller?.dispose();
    super.dispose();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
