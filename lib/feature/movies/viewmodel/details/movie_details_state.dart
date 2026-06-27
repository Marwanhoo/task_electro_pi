import 'package:task_electro_pi/feature/movies/data/model/cast_member_model.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/data/model/watch_provider_model.dart';

enum MovieDetailsStatus { initial, loading, success, failure }

class MovieDetailsState {
  final MovieDetailsStatus status;
  final List<CastMemberModel> cast;
  final String? trailerKey;
  final List<MovieModel> similarMovies;
  final List<MovieModel> recommendedMovies;
  final MovieWatchProvidersModel watchProviders;
  final String? errorMessage;

  const MovieDetailsState({
    required this.status,
    required this.cast,
    required this.similarMovies,
    required this.recommendedMovies,
    required this.watchProviders,
    this.trailerKey,
    this.errorMessage,
  });

  factory MovieDetailsState.initial() => MovieDetailsState(
        status: MovieDetailsStatus.initial,
        cast: <CastMemberModel>[],
        similarMovies: <MovieModel>[],
        recommendedMovies: <MovieModel>[],
        watchProviders: MovieWatchProvidersModel.empty(),
      );

  MovieDetailsState copyWith({
    MovieDetailsStatus? status,
    List<CastMemberModel>? cast,
    String? trailerKey,
    List<MovieModel>? similarMovies,
    List<MovieModel>? recommendedMovies,
    MovieWatchProvidersModel? watchProviders,
    String? errorMessage,
    bool clearTrailerKey = false,
    bool clearErrorMessage = false,
  }) {
    return MovieDetailsState(
      status: status ?? this.status,
      cast: cast ?? this.cast,
      similarMovies: similarMovies ?? this.similarMovies,
      recommendedMovies: recommendedMovies ?? this.recommendedMovies,
      watchProviders: watchProviders ?? this.watchProviders,
      trailerKey: clearTrailerKey ? null : (trailerKey ?? this.trailerKey),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
