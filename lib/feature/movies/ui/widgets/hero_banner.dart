import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_electro_pi/core/themes/app_colors.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key, required this.featuredMovie});

  final MovieModel? featuredMovie;

  String get backdropImageUrl =>
      '${AppStrings.imageBaseUrl}${featuredMovie?.backdropPath ?? ''}';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (featuredMovie != null && featuredMovie!.backdropPath.isNotEmpty)
            CachedNetworkImage(
              imageUrl: backdropImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.tmdbNavy),
              errorWidget: (context, url, error) =>
                  Container(color: AppColors.tmdbNavy),
            )
          else
            Container(color: AppColors.tmdbNavy),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  AppColors.tmdbNavy.withValues(alpha: 0.95),
                  AppColors.tmdbBlue.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Welcome.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Millions of movies to discover. Explore now.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                buildSearchField(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchField(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 18),
          const Expanded(
            child: Text(
              'Search for a movie...',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[AppColors.scoreGreen, AppColors.tmdbBlue],
              ),
              borderRadius: BorderRadius.all(Radius.circular(28)),
            ),
            child: const Text(
              'Search',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
