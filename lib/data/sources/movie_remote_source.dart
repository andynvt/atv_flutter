import '../dtos/movie_dto.dart';
import '../../core/utils/logger.dart';

/// Mock remote data source for movies
class MovieRemoteSource {
  /// Get all movies (mock data)
  Future<List<MovieDTO>> getAllMovies() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    Logger.info('Fetching movies from remote source');

    return _mockMovies;
  }

  /// Get movies by category
  Future<List<MovieDTO>> getMoviesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));

    Logger.info('Fetching movies for category: $category');

    // Filter by category (genre)
    return _mockMovies.where((movie) => movie.genres.contains(category)).toList();
  }

  /// Get movie by ID
  Future<MovieDTO?> getMovieById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    Logger.info('Fetching movie with ID: $id');

    try {
      return _mockMovies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      Logger.error('Movie not found with ID: $id', e);
      return null;
    }
  }

  /// Mock movie data
  static const List<MovieDTO> _mockMovies = [
    MovieDTO(
      id: '1',
      title: 'The Dark Knight',
      overview:
          'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
      posterUrl: 'https://picsum.photos/seed/darkknight/400/600',
      backdropUrl: 'https://picsum.photos/seed/darkknight/1920/1080',
      year: 2008,
      duration: 152,
      genres: ['Action', 'Crime', 'Drama'],
      rating: 9.0,
      director: 'Christopher Nolan',
      cast: ['Christian Bale', 'Heath Ledger', 'Aaron Eckhart'],
    ),
    MovieDTO(
      id: '2',
      title: 'Inception',
      overview:
          'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
      posterUrl: 'https://picsum.photos/seed/inception/400/600',
      backdropUrl: 'https://picsum.photos/seed/inception/1920/1080',
      year: 2010,
      duration: 148,
      genres: ['Action', 'Adventure', 'Sci-Fi'],
      rating: 8.8,
      director: 'Christopher Nolan',
      cast: ['Leonardo DiCaprio', 'Joseph Gordon-Levitt', 'Ellen Page'],
    ),
    MovieDTO(
      id: '3',
      title: 'Interstellar',
      overview: 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
      posterUrl: 'https://picsum.photos/seed/interstellar/400/600',
      backdropUrl: 'https://picsum.photos/seed/interstellar/1920/1080',
      year: 2014,
      duration: 169,
      genres: ['Adventure', 'Drama', 'Sci-Fi'],
      rating: 8.6,
      director: 'Christopher Nolan',
      cast: ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'],
    ),
    MovieDTO(
      id: '4',
      title: 'The Matrix',
      overview:
          'A computer programmer discovers that reality as he knows it is a simulation created by machines, and joins a rebellion to break free.',
      posterUrl: 'https://picsum.photos/seed/matrix/400/600',
      backdropUrl: 'https://picsum.photos/seed/matrix/1920/1080',
      year: 1999,
      duration: 136,
      genres: ['Action', 'Sci-Fi'],
      rating: 8.7,
      director: 'Lana Wachowski',
      cast: ['Keanu Reeves', 'Laurence Fishburne', 'Carrie-Anne Moss'],
    ),
    MovieDTO(
      id: '5',
      title: 'Pulp Fiction',
      overview:
          'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.',
      posterUrl: 'https://picsum.photos/seed/pulpfiction/400/600',
      backdropUrl: 'https://picsum.photos/seed/pulpfiction/1920/1080',
      year: 1994,
      duration: 154,
      genres: ['Crime', 'Drama'],
      rating: 8.9,
      director: 'Quentin Tarantino',
      cast: ['John Travolta', 'Uma Thurman', 'Samuel L. Jackson'],
    ),
    MovieDTO(
      id: '6',
      title: 'Fight Club',
      overview:
          'An insomniac office worker and a devil-may-care soapmaker form an underground fight club that evolves into something much, much more.',
      posterUrl: 'https://picsum.photos/seed/fightclub/400/600',
      backdropUrl: 'https://picsum.photos/seed/fightclub/1920/1080',
      year: 1999,
      duration: 139,
      genres: ['Drama'],
      rating: 8.8,
      director: 'David Fincher',
      cast: ['Brad Pitt', 'Edward Norton', 'Helena Bonham Carter'],
    ),
    MovieDTO(
      id: '7',
      title: 'Forrest Gump',
      overview:
          'The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal and other historical events unfold from the perspective of an Alabama man with an IQ of 75.',
      posterUrl: 'https://picsum.photos/seed/forrestgump/400/600',
      backdropUrl: 'https://picsum.photos/seed/forrestgump/1920/1080',
      year: 1994,
      duration: 142,
      genres: ['Drama', 'Romance'],
      rating: 8.8,
      director: 'Robert Zemeckis',
      cast: ['Tom Hanks', 'Robin Wright', 'Gary Sinise'],
    ),
    MovieDTO(
      id: '8',
      title: 'The Shawshank Redemption',
      overview:
          'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
      posterUrl: 'https://picsum.photos/seed/shawshank/400/600',
      backdropUrl: 'https://picsum.photos/seed/shawshank/1920/1080',
      year: 1994,
      duration: 142,
      genres: ['Drama'],
      rating: 9.3,
      director: 'Frank Darabont',
      cast: ['Tim Robbins', 'Morgan Freeman', 'Bob Gunton'],
    ),
    MovieDTO(
      id: '9',
      title: 'The Godfather',
      overview:
          'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
      posterUrl: 'https://picsum.photos/seed/godfather/400/600',
      backdropUrl: 'https://picsum.photos/seed/godfather/1920/1080',
      year: 1972,
      duration: 175,
      genres: ['Crime', 'Drama'],
      rating: 9.2,
      director: 'Francis Ford Coppola',
      cast: ['Marlon Brando', 'Al Pacino', 'James Caan'],
    ),
    MovieDTO(
      id: '10',
      title: '12 Angry Men',
      overview:
          'A jury holdout attempts to prevent a miscarriage of justice by forcing his colleagues to reconsider the evidence.',
      posterUrl: 'https://picsum.photos/seed/12angrymen/400/600',
      backdropUrl: 'https://picsum.photos/seed/12angrymen/1920/1080',
      year: 1957,
      duration: 96,
      genres: ['Crime', 'Drama'],
      rating: 8.9,
      director: 'Sidney Lumet',
      cast: ['Henry Fonda', 'Lee J. Cobb', 'Martin Balsam'],
    ),
  ];
}
