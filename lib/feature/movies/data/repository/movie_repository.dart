import 'package:dartz/dartz.dart';
import 'package:task_electro_pi/core/errors/failure.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieModel>>> getTrendingMovies();

  Future<Either<Failure, List<MovieModel>>> getPopularMovies();

  Future<Either<Failure, List<MovieModel>>> getNowPlayingMovies();

  Future<Either<Failure, List<MovieModel>>> getComingSoonMovies();
}
