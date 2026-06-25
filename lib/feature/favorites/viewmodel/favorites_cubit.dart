import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/feature/favorites/data/repository/favorites_repository.dart';
import 'package:task_electro_pi/feature/favorites/viewmodel/favorites_state.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/session_cubit.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;
  final SessionCubit sessionCubit;

  FavoritesCubit({
    required this.repository,
    required this.sessionCubit,
  }) : super(FavoritesState.initial());

  int? get accountId => sessionCubit.state.accountId;

  Future<void> loadFavorites() async {
    final currentAccountId = accountId;
    if (currentAccountId == null) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: 'Please log in',
          movies: <MovieModel>[],
          favoriteIds: <int>{},
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: FavoritesStatus.loading,
        movies: <MovieModel>[],
        favoriteIds: <int>{},
        clearErrorMessage: true,
        currentPage: 0,
        totalPages: 0,
        isLoadingMore: false,
      ),
    );

    final result = await repository.getFavoriteMovies(
      accountId: currentAccountId,
      page: 1,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: FavoritesStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (pageResult) {
        emit(
          state.copyWith(
            status: FavoritesStatus.success,
            movies: pageResult.movies,
            favoriteIds: pageResult.movies.map((movie) => movie.id).toSet(),
            currentPage: pageResult.page,
            totalPages: pageResult.totalPages,
          ),
        );
      },
    );
  }

  Future<void> loadFavoritesIfNeeded() async {
    if (accountId == null) {
      return;
    }
    if (state.status == FavoritesStatus.loading ||
        state.status == FavoritesStatus.success) {
      return;
    }
    await loadFavorites();
  }

  Future<void> loadMoreFavorites() async {
    final currentAccountId = accountId;
    if (currentAccountId == null ||
        !state.hasMorePages ||
        state.isLoadingMore ||
        state.status == FavoritesStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await repository.getFavoriteMovies(
      accountId: currentAccountId,
      page: nextPage,
    );

    result.fold(
      (_) => emit(state.copyWith(isLoadingMore: false)),
      (pageResult) {
        final updatedMovies = <MovieModel>[
          ...state.movies,
          ...pageResult.movies,
        ];
        emit(
          state.copyWith(
            status: FavoritesStatus.success,
            movies: updatedMovies,
            favoriteIds: updatedMovies.map((movie) => movie.id).toSet(),
            currentPage: pageResult.page,
            totalPages: pageResult.totalPages,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  bool isFavorite(int movieId) => state.favoriteIds.contains(movieId);

  Future<String?> toggleFavorite(int movieId) async {
    final currentAccountId = accountId;
    if (currentAccountId == null) {
      return 'Please log in';
    }

    final wasFavorite = state.favoriteIds.contains(movieId);
    final updatedIds = <int>{...state.favoriteIds};
    if (wasFavorite) {
      updatedIds.remove(movieId);
    } else {
      updatedIds.add(movieId);
    }

    emit(state.copyWith(favoriteIds: updatedIds));

    final result = await repository.setFavorite(
      accountId: currentAccountId,
      movieId: movieId,
      isFavorite: !wasFavorite,
    );

    return result.fold(
      (failure) {
        final revertedIds = <int>{...state.favoriteIds};
        if (wasFavorite) {
          revertedIds.add(movieId);
        } else {
          revertedIds.remove(movieId);
        }
        emit(state.copyWith(favoriteIds: revertedIds));
        return failure.message;
      },
      (_) {
        if (wasFavorite) {
          final updatedMovies =
              state.movies.where((movie) => movie.id != movieId).toList();
          emit(
            state.copyWith(
              movies: updatedMovies,
              favoriteIds: updatedMovies.map((movie) => movie.id).toSet(),
            ),
          );
        }
        return null;
      },
    );
  }

  void reset() {
    emit(FavoritesState.initial());
  }
}
