import 'package:flutter/material.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/movie_poster_card.dart';

class HorizontalMovieList extends StatelessWidget {
  const HorizontalMovieList({
    super.key,
    required this.movies,
    required this.heroScope,
    this.listHeight = 290,
  });

  final List<MovieModel> movies;
  final String heroScope;
  final double listHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) => MoviePosterCard(
          movie: movies[index],
          posterWidth: 140,
          heroScope: heroScope,
        ),
      ),
    );
  }
}
