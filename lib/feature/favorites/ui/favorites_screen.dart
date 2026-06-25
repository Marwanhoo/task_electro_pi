import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/utils/service_locator.dart';
import 'package:task_electro_pi/feature/favorites/viewmodel/favorites_cubit.dart';
import 'package:task_electro_pi/feature/favorites/viewmodel/favorites_state.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/movie_poster_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getIt<FavoritesCubit>().loadFavorites();
    scrollController.addListener(onScroll);
  }

  void onScroll() {
    if (!scrollController.hasClients) {
      return;
    }
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      getIt<FavoritesCubit>().loadMoreFavorites();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (favoritesContext, favoritesState) {
          if (favoritesState.status == FavoritesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favoritesState.status == FavoritesStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  favoritesState.errorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (favoritesState.movies.isEmpty) {
            return RefreshIndicator(
              onRefresh: () =>
                  favoritesContext.read<FavoritesCubit>().loadFavorites(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const <Widget>[
                  SizedBox(height: 120),
                  Center(child: Text('No favorite movies yet')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                favoritesContext.read<FavoritesCubit>().loadFavorites(),
            child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.52,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (gridContext, index) {
                        final movie = favoritesState.movies[index];
                        return MoviePosterCard(
                          movie: movie,
                          heroScope: 'favorites-$index',
                        );
                      },
                      childCount: favoritesState.movies.length,
                    ),
                  ),
                ),
                if (favoritesState.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
