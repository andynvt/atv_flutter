import '../sources/movie_remote_source.dart';
import '../../domain/entities/movie_entity.dart';
import '../../core/utils/result.dart';
import '../../core/utils/logger.dart';

/// Repository for movie data operations
class MovieRepository {
  final MovieRemoteSource _remoteSource;

  MovieRepository({MovieRemoteSource? remoteSource}) : _remoteSource = remoteSource ?? MovieRemoteSource();

  /// Get all movies
  Future<Result<List<MovieEntity>>> getAllMovies() async {
    try {
      Logger.info('Repository: Getting all movies');
      final movies = await _remoteSource.getAllMovies();
      final entities = movies.map((dto) => dto.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      Logger.error('Repository: Error getting all movies', e);
      return const Error('Failed to fetch movies');
    }
  }

  /// Get movies by category
  Future<Result<List<MovieEntity>>> getMoviesByCategory(String category) async {
    try {
      Logger.info('Repository: Getting movies for category: $category');
      final movies = await _remoteSource.getMoviesByCategory(category);
      final entities = movies.map((dto) => dto.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      Logger.error('Repository: Error getting movies for category: $category', e);
      return Error('Failed to fetch movies for category: $category');
    }
  }

  /// Get movie by ID
  Future<Result<MovieEntity?>> getMovieById(String id) async {
    try {
      Logger.info('Repository: Getting movie with ID: $id');
      final movie = await _remoteSource.getMovieById(id);
      if (movie != null) {
        return Success(movie.toEntity());
      } else {
        return const Error('Movie not found');
      }
    } catch (e) {
      Logger.error('Repository: Error getting movie with ID: $id', e);
      return const Error('Failed to fetch movie');
    }
  }

  /// Get available categories
  List<String> getAvailableCategories() {
    return ['Action', 'Adventure', 'Comedy', 'Crime', 'Drama', 'Horror', 'Romance', 'Sci-Fi', 'Thriller'];
  }
}
