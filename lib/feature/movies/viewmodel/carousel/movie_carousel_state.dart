import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';

enum MovieCarouselStatus { initial, loading, success, failure }

class MovieCarouselState {
  final MovieCarouselStatus status;
  final List<MovieModel> movies;
  final String? errorMessage;

  const MovieCarouselState({
    required this.status,
    required this.movies,
    this.errorMessage,
  });

  factory MovieCarouselState.initial() => const MovieCarouselState(
        status: MovieCarouselStatus.initial,
        movies: <MovieModel>[],
      );

  MovieModel? get featuredMovie => movies.isNotEmpty ? movies.first : null;

  MovieCarouselState copyWith({
    MovieCarouselStatus? status,
    List<MovieModel>? movies,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return MovieCarouselState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
