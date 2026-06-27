import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/errors/failure.dart';
import 'package:task_electro_pi/feature/movies/data/model/cast_member_model.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/data/model/video_model.dart';
import 'package:task_electro_pi/feature/movies/data/repository/movie_repository.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/details/movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  static const int maxCastMembers = 15;
  static const int maxRelatedMovies = 10;

  final MovieRepository movieRepository;

  MovieDetailsCubit({required this.movieRepository})
      : super(MovieDetailsState.initial());

  Future<void> loadDetails(int movieId) async {
    emit(state.copyWith(
      status: MovieDetailsStatus.loading,
      clearErrorMessage: true,
      clearTrailerKey: true,
      similarMovies: <MovieModel>[],
      recommendedMovies: <MovieModel>[],
    ));

    late Either<Failure, List<CastMemberModel>> creditsResult;
    late Either<Failure, List<VideoModel>> videosResult;
    late Either<Failure, List<MovieModel>> similarResult;
    late Either<Failure, List<MovieModel>> recommendationsResult;

    await Future.wait([
      movieRepository.getMovieCredits(movieId).then((value) {
        creditsResult = value;
      }),
      movieRepository.getMovieVideos(movieId).then((value) {
        videosResult = value;
      }),
      movieRepository.getSimilarMovies(movieId).then((value) {
        similarResult = value;
      }),
      movieRepository.getRecommendedMovies(movieId).then((value) {
        recommendationsResult = value;
      }),
    ]);

    String? errorMessage;
    List<CastMemberModel> cast = <CastMemberModel>[];
    VideoModel? trailer;
    List<MovieModel> similarMovies = <MovieModel>[];
    List<MovieModel> recommendedMovies = <MovieModel>[];

    creditsResult.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (members) {
        cast = members.take(maxCastMembers).toList();
      },
    );

    videosResult.fold(
      (failure) {
        errorMessage ??= failure.message;
      },
      (videos) {
        trailer = VideoModel.selectYoutubeTrailer(videos);
      },
    );

    similarResult.fold(
      (failure) {
        errorMessage ??= failure.message;
      },
      (movies) {
        similarMovies = filterRelatedMovies(movies, movieId);
      },
    );

    recommendationsResult.fold(
      (failure) {
        errorMessage ??= failure.message;
      },
      (movies) {
        recommendedMovies = filterRelatedMovies(movies, movieId);
      },
    );

    if (errorMessage != null &&
        cast.isEmpty &&
        trailer == null &&
        similarMovies.isEmpty &&
        recommendedMovies.isEmpty) {
      emit(state.copyWith(
        status: MovieDetailsStatus.failure,
        errorMessage: errorMessage,
      ));
      return;
    }

    emit(state.copyWith(
      status: MovieDetailsStatus.success,
      cast: cast,
      trailerKey: trailer?.key,
      similarMovies: similarMovies,
      recommendedMovies: recommendedMovies,
      clearErrorMessage: true,
    ));
  }

  List<MovieModel> filterRelatedMovies(List<MovieModel> movies, int movieId) {
    return movies
        .where((movie) => movie.id != movieId)
        .take(maxRelatedMovies)
        .toList();
  }
}
