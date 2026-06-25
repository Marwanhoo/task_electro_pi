import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_electro_pi/feature/favorites/viewmodel/favorites_cubit.dart';
import 'package:task_electro_pi/feature/favorites/viewmodel/favorites_state.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/session_cubit.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/session_state.dart';

class FavoriteHeartButton extends StatelessWidget {
  const FavoriteHeartButton({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (sessionContext, sessionState) {
        if (!sessionState.isAuthenticated) {
          return IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              ScaffoldMessenger.of(sessionContext).showSnackBar(
                const SnackBar(content: Text('Please log in to save favorites')),
              );
              sessionContext.push('/login');
            },
          );
        }

        return BlocBuilder<FavoritesCubit, FavoritesState>(
          buildWhen: (previous, current) =>
              previous.favoriteIds != current.favoriteIds,
          builder: (favoritesContext, favoritesState) {
            final favoritesCubit = favoritesContext.read<FavoritesCubit>();
            final isFavorite = favoritesState.favoriteIds.contains(movieId);

            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () async {
                final errorMessage =
                    await favoritesCubit.toggleFavorite(movieId);
                if (errorMessage != null && favoritesContext.mounted) {
                  ScaffoldMessenger.of(favoritesContext).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
