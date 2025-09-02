import '../../domain/entities/movie_entity.dart';

/// Movie DTO for data layer
class MovieDTO {
  final String id;
  final String title;
  final String overview;
  final String posterUrl;
  final String backdropUrl;
  final int year;
  final int duration;
  final List<String> genres;
  final double rating;
  final String director;
  final List<String> cast;

  const MovieDTO({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.year,
    required this.duration,
    required this.genres,
    required this.rating,
    required this.director,
    required this.cast,
  });

  /// Convert DTO to Entity
  MovieEntity toEntity() {
    return MovieEntity(
      id: id,
      title: title,
      overview: overview,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
      year: year,
      duration: duration,
      genres: genres,
      rating: rating,
      director: director,
      cast: cast,
    );
  }

  /// Create DTO from JSON
  factory MovieDTO.fromJson(Map<String, dynamic> json) {
    return MovieDTO(
      id: json['id'] as String,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterUrl: json['posterUrl'] as String,
      backdropUrl: json['backdropUrl'] as String,
      year: json['year'] as int,
      duration: json['duration'] as int,
      genres: List<String>.from(json['genres'] as List),
      rating: (json['rating'] as num).toDouble(),
      director: json['director'] as String,
      cast: List<String>.from(json['cast'] as List),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'year': year,
      'duration': duration,
      'genres': genres,
      'rating': rating,
      'director': director,
      'cast': cast,
    };
  }
}
