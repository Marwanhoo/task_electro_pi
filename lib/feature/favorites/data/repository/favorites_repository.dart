import 'package:dartz/dartz.dart';
import 'package:task_electro_pi/core/errors/failure.dart';
import 'package:task_electro_pi/feature/movies/data/model/movies_result_model.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, MoviesResultModel>> getFavoriteMovies({
    required int accountId,
    int page = 1,
  });

  Future<Either<Failure, void>> setFavorite({
    required int accountId,
    required int movieId,
    required bool isFavorite,
  });
}
