import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/errors/failure.dart';
import 'package:task_electro_pi/feature/movies/data/model/cast_member_model.dart';
import 'package:task_electro_pi/feature/movies/data/model/video_model.dart';
import 'package:task_electro_pi/feature/movies/data/repository/movie_repository.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/details/movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  static const int maxCastMembers = 15;

  final MovieRepository movieRepository;

  MovieDetailsCubit({required this.movieRepository})
      : super(MovieDetailsState.initial());

  Future<void> loadDetails(int movieId) async {
    emit(state.copyWith(
      status: MovieDetailsStatus.loading,
      clearErrorMessage: true,
      clearTrailerKey: true,
    ));

    late Either<Failure, List<CastMemberModel>> creditsResult;
    late Either<Failure, List<VideoModel>> videosResult;

    await Future.wait([
      movieRepository.getMovieCredits(movieId).then((value) {
        creditsResult = value;
      }),
      movieRepository.getMovieVideos(movieId).then((value) {
        videosResult = value;
      }),
    ]);

    String? errorMessage;
    List<CastMemberModel> cast = <CastMemberModel>[];
    VideoModel? trailer;

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

    if (errorMessage != null && cast.isEmpty && trailer == null) {
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
      clearErrorMessage: true,
    ));
  }
}
