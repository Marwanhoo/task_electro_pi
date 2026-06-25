import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';

enum MovieTabbedStatus { initial, loading, success, failure }

class MovieTabbedState {
  final MovieTabbedStatus status;
  final List<MovieModel> movies;
  final int currentTabIndex;
  final String? errorMessage;

  const MovieTabbedState({
    required this.status,
    required this.movies,
    required this.currentTabIndex,
    this.errorMessage,
  });

  factory MovieTabbedState.initial() => const MovieTabbedState(
        status: MovieTabbedStatus.initial,
        movies: <MovieModel>[],
        currentTabIndex: 0,
      );

  MovieTabbedState copyWith({
    MovieTabbedStatus? status,
    List<MovieModel>? movies,
    int? currentTabIndex,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return MovieTabbedState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
