import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';

class MovieDetailsRouteArgs {
  final MovieModel movie;
  final String? heroTag;

  const MovieDetailsRouteArgs({
    required this.movie,
    this.heroTag,
  });

  static MovieDetailsRouteArgs fromExtra(Object? extra) {
    if (extra is MovieDetailsRouteArgs) {
      return extra;
    }
    if (extra is MovieModel) {
      return MovieDetailsRouteArgs(movie: extra);
    }
    throw ArgumentError('Invalid movie details route extra: $extra');
  }
}
