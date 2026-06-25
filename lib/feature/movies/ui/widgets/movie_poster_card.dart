import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/score_ring.dart';

class MoviePosterCard extends StatelessWidget {
  const MoviePosterCard({super.key, required this.movie, this.posterWidth});

  final MovieModel movie;

  /// Fixed card width for horizontal lists. When null the card fills the
  /// width given by its parent (used inside the search results grid).
  final double? posterWidth;

  String get posterImageUrl => '${AppStrings.imageBaseUrl}${movie.posterPath}';

  void openMovieDetails(BuildContext context) {
    context.push('/details', extra: movie);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = GestureDetector(
      onTap: () => openMovieDetails(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Hero(
                tag: 'movie-${movie.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: CachedNetworkImage(
                      imageUrl: posterImageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: const Icon(Icons.movie_outlined, size: 40),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                bottom: -18,
                child: ScoreRing(voteAverage: movie.voteAverage),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            formatReleaseDate(movie.releaseDate),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );

    if (posterWidth == null) {
      return card;
    }
    return SizedBox(width: posterWidth, child: card);
  }

  String formatReleaseDate(String releaseDate) {
    if (releaseDate.isEmpty) {
      return 'Unknown date';
    }
    final parsedDate = DateTime.tryParse(releaseDate);
    if (parsedDate == null) {
      return releaseDate;
    }
    const monthNames = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${monthNames[parsedDate.month - 1]} ${parsedDate.day}, ${parsedDate.year}';
  }
}
