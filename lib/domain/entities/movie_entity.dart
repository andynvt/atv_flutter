/// Movie entity for the domain layer
class MovieEntity {
  final String id;
  final String title;
  final String overview;
  final String posterUrl;
  final String backdropUrl;
  final int year;
  final int duration; // in minutes
  final List<String> genres;
  final double rating;
  final String director;
  final List<String> cast;

  const MovieEntity({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MovieEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MovieEntity(id: $id, title: $title, year: $year)';
  }
}
