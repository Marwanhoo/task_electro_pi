import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState {
  final FavoritesStatus status;
  final List<MovieModel> movies;
  final Set<int> favoriteIds;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;

  const FavoritesState({
    required this.status,
    required this.movies,
    required this.favoriteIds,
    this.errorMessage,
    this.currentPage = 0,
    this.totalPages = 0,
    this.isLoadingMore = false,
  });

  factory FavoritesState.initial() => const FavoritesState(
        status: FavoritesStatus.initial,
        movies: <MovieModel>[],
        favoriteIds: <int>{},
      );

  bool get hasMorePages => currentPage < totalPages;

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<MovieModel>? movies,
    Set<int>? favoriteIds,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
    bool clearErrorMessage = false,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
