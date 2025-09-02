import 'package:flutter/material.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_home_rails.dart';
import '../../core/utils/result.dart';

/// ViewModel for Home page
class HomeViewModel extends ChangeNotifier {
  final GetHomeRails _getHomeRails;

  HomeViewModel(this._getHomeRails);

  // State
  Result<Map<String, List<MovieEntity>>> _rails = const Loading();
  bool _isLoading = false;
  String? _errorMessage;

  // Focus state
  int _focusedRailIndex = 0;
  int _focusedItemIndexPerRail = 0;

  // Getters
  Result<Map<String, List<MovieEntity>>> get rails => _rails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get focusedRailIndex => _focusedRailIndex;
  int get focusedItemIndexPerRail => _focusedItemIndexPerRail;

  /// Load home rails
  Future<void> loadHomeRails() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _getHomeRails.execute();
      _rails = result;

      if (result is Error) {
        _setError((result as Error).message);
      }
    } catch (e) {
      _setError('Unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  /// Set focused rail index
  void setFocusedRailIndex(int index) {
    if (_focusedRailIndex != index) {
      _focusedRailIndex = index;
      _focusedItemIndexPerRail = 0; // Reset item focus when changing rails
      notifyListeners();
    }
  }

  /// Set focused item index within a rail
  void setFocusedItemIndex(int index) {
    if (_focusedItemIndexPerRail != index) {
      _focusedItemIndexPerRail = index;
      notifyListeners();
    }
  }

  /// Move focus to next rail
  void focusNextRail() {
    if (_rails is Success) {
      final railsData = (_rails as Success<Map<String, List<MovieEntity>>>).data;
      final nextIndex = (_focusedRailIndex + 1) % railsData.length;
      setFocusedRailIndex(nextIndex);
    }
  }

  /// Move focus to previous rail
  void focusPreviousRail() {
    if (_rails is Success) {
      final railsData = (_rails as Success<Map<String, List<MovieEntity>>>).data;
      final prevIndex = _focusedRailIndex > 0 ? _focusedRailIndex - 1 : railsData.length - 1;
      setFocusedRailIndex(prevIndex);
    }
  }

  /// Move focus to next item in current rail
  void focusNextItem() {
    if (_rails is Success) {
      final railsData = (_rails as Success<Map<String, List<MovieEntity>>>).data;
      final railKeys = railsData.keys.toList();
      if (railKeys.isNotEmpty) {
        final currentRail = railKeys[_focusedRailIndex];
        final currentRailItems = railsData[currentRail] ?? [];
        if (currentRailItems.isNotEmpty) {
          final nextIndex = (_focusedItemIndexPerRail + 1) % currentRailItems.length;
          setFocusedItemIndex(nextIndex);
        }
      }
    }
  }

  /// Move focus to previous item in current rail
  void focusPreviousItem() {
    if (_rails is Success) {
      final railsData = (_rails as Success<Map<String, List<MovieEntity>>>).data;
      final railKeys = railsData.keys.toList();
      if (railKeys.isNotEmpty) {
        final currentRail = railKeys[_focusedRailIndex];
        final currentRailItems = railsData[currentRail] ?? [];
        if (currentRailItems.isNotEmpty) {
          final prevIndex = _focusedItemIndexPerRail > 0 ? _focusedItemIndexPerRail - 1 : currentRailItems.length - 1;
          setFocusedItemIndex(prevIndex);
        }
      }
    }
  }

  /// Get current focused movie
  MovieEntity? getCurrentFocusedMovie() {
    if (_rails is Success) {
      final railsData = (_rails as Success<Map<String, List<MovieEntity>>>).data;
      final railKeys = railsData.keys.toList();
      if (railKeys.isNotEmpty && _focusedRailIndex < railKeys.length) {
        final currentRail = railKeys[_focusedRailIndex];
        final currentRailItems = railsData[currentRail] ?? [];
        if (currentRailItems.isNotEmpty && _focusedItemIndexPerRail < currentRailItems.length) {
          return currentRailItems[_focusedItemIndexPerRail];
        }
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
