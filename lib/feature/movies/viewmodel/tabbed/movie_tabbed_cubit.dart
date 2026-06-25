import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/errors/failure.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/data/repository/movie_repository.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/tabbed/movie_tabbed_state.dart';

class MovieTabbedCubit extends Cubit<MovieTabbedState> {
  final MovieRepository movieRepository;

  MovieTabbedCubit({required this.movieRepository})
      : super(MovieTabbedState.initial());

  Future<void> changeTab(int tabIndex) async {
    emit(state.copyWith(
      status: MovieTabbedStatus.loading,
      currentTabIndex: tabIndex,
      clearErrorMessage: true,
    ));

    final Either<Failure, List<MovieModel>> result =
        await loadMoviesForTab(tabIndex);

    result.fold(
      (failure) => emit(state.copyWith(
        status: MovieTabbedStatus.failure,
        errorMessage: failure.message,
      )),
      (movies) => emit(state.copyWith(
        status: MovieTabbedStatus.success,
        movies: movies,
        clearErrorMessage: true,
      )),
    );
  }

  Future<Either<Failure, List<MovieModel>>> loadMoviesForTab(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return movieRepository.getNowPlayingMovies();
      case 2:
        return movieRepository.getComingSoonMovies();
      case 0:
      default:
        return movieRepository.getPopularMovies();
    }
  }
}
