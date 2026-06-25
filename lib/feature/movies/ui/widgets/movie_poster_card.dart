import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/ui/movie_details_route_args.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/score_ring.dart';

class MoviePosterCard extends StatelessWidget {
  const MoviePosterCard({
    super.key,
    required this.movie,
    this.posterWidth,
    this.heroScope,
  });

  final MovieModel movie;
  final double? posterWidth;
  final String? heroScope;

  String get posterImageUrl => '${AppStrings.imageBaseUrl}${movie.posterPath}';

  String? get heroTag =>
      heroScope != null ? '$heroScope-movie-${movie.id}' : null;

  void openMovieDetails(BuildContext context) {
    context.push(
      '/details',
      extra: MovieDetailsRouteArgs(movie: movie, heroTag: heroTag),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final posterImage = ClipRRect(
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
    );

    final card = GestureDetector(
      onTap: () => openMovieDetails(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              if (heroTag != null)
                Hero(tag: heroTag!, child: posterImage)
              else
                posterImage,
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
