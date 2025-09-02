import 'package:flutter/material.dart';
import '../../domain/entities/movie_entity.dart';
import '../../data/repositories/movie_repository.dart';
import '../../core/utils/result.dart';

/// ViewModel for Detail page
class DetailViewModel extends ChangeNotifier {
  final MovieRepository _repository;

  DetailViewModel(this._repository);

  // State
  Result<MovieEntity?> _movie = const Loading();
  bool _isLoading = false;
  String? _errorMessage;

  // Focus state
  int _focusedActionIndex = 0;

  // Getters
  Result<MovieEntity?> get movie => _movie;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get focusedActionIndex => _focusedActionIndex;

  /// Load movie by ID
  Future<void> loadMovie(String id) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.getMovieById(id);
      _movie = result;

      if (result is Error) {
        _setError((result as Error).message);
      }
    } catch (e) {
      _setError('Unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  /// Set focused action index
  void setFocusedActionIndex(int index) {
    if (_focusedActionIndex != index) {
      _focusedActionIndex = index;
      notifyListeners();
    }
  }

  /// Move focus to next action
  void focusNextAction() {
    const actionCount = 3; // Play, Add to List, More Info
    final nextIndex = (_focusedActionIndex + 1) % actionCount;
    setFocusedActionIndex(nextIndex);
  }

  /// Move focus to previous action
  void focusPreviousAction() {
    const actionCount = 3; // Play, Add to List, More Info
    final prevIndex = _focusedActionIndex > 0 ? _focusedActionIndex - 1 : actionCount - 1;
    setFocusedActionIndex(prevIndex);
  }

  /// Get current focused action
  String getCurrentFocusedAction() {
    const actions = ['Play', 'Add to List', 'More Info'];
    if (_focusedActionIndex < actions.length) {
      return actions[_focusedActionIndex];
    }
    return 'Play';
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
