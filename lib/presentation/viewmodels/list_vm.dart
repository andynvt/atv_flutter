import 'package:flutter/material.dart';
import '../../domain/entities/movie_entity.dart';
import '../../data/repositories/movie_repository.dart';
import '../../core/utils/result.dart';

/// ViewModel for List page
class ListViewModel extends ChangeNotifier {
  final MovieRepository _repository;

  ListViewModel(this._repository);

  // State
  Result<List<MovieEntity>> _movies = const Loading();
  bool _isLoading = false;
  String? _errorMessage;

  // Focus state
  int _focusedIndex = 0;

  // Getters
  Result<List<MovieEntity>> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get focusedIndex => _focusedIndex;

  /// Load all movies
  Future<void> loadMovies() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.getAllMovies();
      _movies = result;

      if (result is Error) {
        _setError((result as Error).message);
      }
    } catch (e) {
      _setError('Unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  /// Set focused index
  void setFocusedIndex(int index) {
    if (_focusedIndex != index) {
      _focusedIndex = index;
      notifyListeners();
    }
  }

  /// Move focus to next item
  void focusNext() {
    if (_movies is Success) {
      final moviesData = (_movies as Success<List<MovieEntity>>).data;
      if (moviesData.isNotEmpty) {
        final nextIndex = (_focusedIndex + 1) % moviesData.length;
        setFocusedIndex(nextIndex);
      }
    }
  }

  /// Move focus to previous item
  void focusPrevious() {
    if (_movies is Success) {
      final moviesData = (_movies as Success<List<MovieEntity>>).data;
      if (moviesData.isNotEmpty) {
        final prevIndex = _focusedIndex > 0 ? _focusedIndex - 1 : moviesData.length - 1;
        setFocusedIndex(prevIndex);
      }
    }
  }

  /// Get current focused movie
  MovieEntity? getCurrentFocusedMovie() {
    if (_movies is Success) {
      final moviesData = (_movies as Success<List<MovieEntity>>).data;
      if (moviesData.isNotEmpty && _focusedIndex < moviesData.length) {
        return moviesData[_focusedIndex];
      }
    }
    return null;
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
