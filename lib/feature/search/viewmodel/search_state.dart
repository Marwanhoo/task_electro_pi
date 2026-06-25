import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';

enum SearchStatus { initial, loading, success, empty, failure }

class SearchState {
  final SearchStatus status;
  final String query;
  final List<MovieModel> results;
  final String? errorMessage;

  const SearchState({
    required this.status,
    required this.query,
    required this.results,
    this.errorMessage,
  });

  factory SearchState.initial() => const SearchState(
        status: SearchStatus.initial,
        query: '',
        results: <MovieModel>[],
      );

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<MovieModel>? results,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
