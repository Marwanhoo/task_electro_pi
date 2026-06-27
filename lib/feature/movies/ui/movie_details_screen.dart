import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/core/utils/url_launcher_helper.dart';
import 'package:task_electro_pi/feature/favorites/ui/favorite_heart_button.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/cast_member_tile.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/score_ring.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/details/movie_details_cubit.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/details/movie_details_state.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({
    super.key,
    required this.movie,
    this.heroTag,
  });

  final MovieModel movie;
  final String? heroTag;

  String get backdropImageUrl => '${AppStrings.imageBaseUrl}${movie.backdropPath}';

  String get posterImageUrl => '${AppStrings.imageBaseUrl}${movie.posterPath}';

  Future<void> onWatchTrailerPressed(BuildContext context) async {
    final trailerKey = context.read<MovieDetailsCubit>().state.trailerKey;
    if (trailerKey == null) {
      return;
    }

    final launched = await openYoutubeTrailer(trailerKey);
    if (!context.mounted) {
      return;
    }

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open trailer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            actions: <Widget>[
              FavoriteHeartButton(movieId: movie.id),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: buildBackdrop(theme),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildHeaderRow(theme),
                  BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
                    buildWhen: (previous, current) =>
                        previous.trailerKey != current.trailerKey,
                    builder: (context, state) {
                      if (state.trailerKey == null) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FilledButton.icon(
                          onPressed: () => onWatchTrailerPressed(context),
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text('Watch Trailer'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Overview',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview.isEmpty
                        ? 'No overview available.'
                        : movie.overview,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  buildCastSection(theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCastSection(ThemeData theme) {
    return BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Cast',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (state.status == MovieDetailsStatus.loading)
              const SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.status == MovieDetailsStatus.failure)
              Text(
                state.errorMessage ?? 'Unable to load cast.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              )
            else if (state.cast.isEmpty)
              Text(
                'No cast available.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color
                      ?.withValues(alpha: 0.6),
                ),
              )
            else
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.cast.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return CastMemberTile(castMember: state.cast[index]);
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget buildBackdrop(ThemeData theme) {
    final placeholderColor = theme.colorScheme.surfaceContainerHighest;
    if (movie.backdropPath.isEmpty) {
      return Container(color: placeholderColor);
    }
    return CachedNetworkImage(
      imageUrl: backdropImageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: placeholderColor),
      errorWidget: (context, url, error) => Container(color: placeholderColor),
    );
  }

  Widget buildHeaderRow(ThemeData theme) {
    final poster = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: posterImageUrl,
        width: 120,
        height: 180,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 120,
          height: 180,
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        errorWidget: (context, url, error) => Container(
          width: 120,
          height: 180,
          color: theme.colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const Icon(Icons.movie_outlined, size: 40),
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (heroTag != null)
          Hero(tag: heroTag!, child: poster)
        else
          poster,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                movie.title,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              if (movie.releaseDate.isNotEmpty)
                Text(
                  movie.releaseDate,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.6),
                  ),
                ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  ScoreRing(voteAverage: movie.voteAverage, diameter: 46),
                  const SizedBox(width: 10),
                  Text(
                    'User Score',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
