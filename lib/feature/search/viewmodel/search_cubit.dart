import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/feature/movies/data/repository/movie_repository.dart';
import 'package:task_electro_pi/feature/search/viewmodel/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MovieRepository movieRepository;

  Timer? debounceTimer;

  static const Duration debounceDuration = Duration(milliseconds: 400);

  SearchCubit({required this.movieRepository}) : super(SearchState.initial());

  void onSearchQueryChanged(String rawQuery) {
    debounceTimer?.cancel();
    final query = rawQuery.trim();
    if (query.isEmpty) {
      emit(SearchState.initial());
      return;
    }
    debounceTimer = Timer(debounceDuration, () => runSearch(query));
  }

  Future<void> runSearch(String query) async {
    emit(state.copyWith(
      status: SearchStatus.loading,
      query: query,
      clearErrorMessage: true,
    ));

    final result = await movieRepository.searchMovies(query);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: failure.message,
      )),
      (movies) => emit(state.copyWith(
        status: movies.isEmpty ? SearchStatus.empty : SearchStatus.success,
        results: movies,
        clearErrorMessage: true,
      )),
    );
  }

  @override
  Future<void> close() {
    debounceTimer?.cancel();
    return super.close();
  }
}
