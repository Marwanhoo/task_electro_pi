import 'package:dartz/dartz.dart';
import 'package:task_electro_pi/core/errors/failure.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/movies/data/model/cast_member_model.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/data/model/video_model.dart';
import 'package:task_electro_pi/feature/movies/data/model/watch_provider_model.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieModel>>> getTrendingMovies();

  Future<Either<Failure, List<MovieModel>>> getPopularMovies();

  Future<Either<Failure, List<MovieModel>>> getNowPlayingMovies();

  Future<Either<Failure, List<MovieModel>>> getComingSoonMovies();

  Future<Either<Failure, List<MovieModel>>> searchMovies(String query);

  Future<Either<Failure, List<CastMemberModel>>> getMovieCredits(int movieId);

  Future<Either<Failure, List<VideoModel>>> getMovieVideos(int movieId);

  Future<Either<Failure, List<MovieModel>>> getSimilarMovies(int movieId);

  Future<Either<Failure, List<MovieModel>>> getRecommendedMovies(int movieId);

  Future<Either<Failure, MovieWatchProvidersModel>> getMovieWatchProviders(
    int movieId, {
    String region = AppStrings.defaultWatchProvidersRegion,
  });
}
