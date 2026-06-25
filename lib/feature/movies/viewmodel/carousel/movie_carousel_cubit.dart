import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/feature/movies/data/repository/movie_repository.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/carousel/movie_carousel_state.dart';

class MovieCarouselCubit extends Cubit<MovieCarouselState> {
  final MovieRepository movieRepository;

  MovieCarouselCubit({required this.movieRepository})
      : super(MovieCarouselState.initial());

  Future<void> loadTrendingMovies() async {
    emit(state.copyWith(
      status: MovieCarouselStatus.loading,
      clearErrorMessage: true,
    ));

    final result = await movieRepository.getTrendingMovies();

    result.fold(
      (failure) => emit(state.copyWith(
        status: MovieCarouselStatus.failure,
        errorMessage: failure.message,
      )),
      (movies) => emit(state.copyWith(
        status: MovieCarouselStatus.success,
        movies: movies,
        clearErrorMessage: true,
      )),
    );
  }
}
