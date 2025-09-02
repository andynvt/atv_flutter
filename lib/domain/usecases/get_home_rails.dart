import '../entities/movie_entity.dart';
import '../../data/repositories/movie_repository.dart';
import '../../core/utils/result.dart';

/// Use case for getting home page rails (categories with movies)
class GetHomeRails {
  final MovieRepository _repository;

  GetHomeRails(this._repository);

  /// Execute the use case
  Future<Result<Map<String, List<MovieEntity>>>> execute() async {
    try {
      // Get all movies first
      final allMoviesResult = await _repository.getAllMovies();

      if (allMoviesResult is Error) {
        return Error((allMoviesResult as Error).message);
      }

      final allMovies = (allMoviesResult as Success<List<MovieEntity>>).data;

      // Get available categories
      final categories = _repository.getAvailableCategories();

      // Group movies by category
      final Map<String, List<MovieEntity>> rails = {};

      for (final category in categories) {
        final categoryMovies = allMovies.where((movie) => movie.genres.contains(category)).toList();
        if (categoryMovies.isNotEmpty) {
          rails[category] = categoryMovies;
        }
      }

      // Add a "Featured" rail with top-rated movies
      final featuredMovies = allMovies.where((movie) => movie.rating >= 8.5).take(10).toList();

      if (featuredMovies.isNotEmpty) {
        rails['Featured'] = featuredMovies;
      }

      // Add a "Recently Added" rail (using year as proxy)
      final recentMovies = allMovies.where((movie) => movie.year >= 2010).take(10).toList();

      if (recentMovies.isNotEmpty) {
        rails['Recently Added'] = recentMovies;
      }

      return Success(rails);
    } catch (e) {
      return const Error('Failed to get home rails');
    }
  }
}
