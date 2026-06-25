import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task_electro_pi/core/errors/failure.dart';
import 'package:task_electro_pi/core/errors/server_failure.dart';
import 'package:task_electro_pi/core/utils/api_services.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/favorites/data/repository/favorites_repository.dart';
import 'package:task_electro_pi/feature/movies/data/model/movies_result_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final ApiServices apiServices;

  FavoritesRepositoryImpl({required this.apiServices});

  @override
  Future<Either<Failure, MoviesResultModel>> getFavoriteMovies({
    required int accountId,
    int page = 1,
  }) async {
    try {
      final responseData = await apiServices.get(
        endPoint: AppStrings.favoriteMoviesEndpoint(accountId),
        queryParameters: <String, dynamic>{'page': page},
      );
      return Right(MoviesResultModel.fromJson(responseData));
    } on DioException catch (dioException) {
      return Left(ServerFailure.fromDioException(dioException));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setFavorite({
    required int accountId,
    required int movieId,
    required bool isFavorite,
  }) async {
    try {
      final responseData = await apiServices.post(
        endPoint: AppStrings.favoriteEndpoint(accountId),
        dataBody: <String, dynamic>{
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': isFavorite,
        },
      );
      final statusCode = responseData['status_code'] as int?;
      final success = responseData['success'] as bool?;
      if (statusCode == 1 || success == true) {
        return const Right(null);
      }
      return Left(
        ServerFailure(
          responseData['status_message'] as String? ??
              'Failed to update favorite',
        ),
      );
    } on DioException catch (dioException) {
      return Left(ServerFailure.fromDioException(dioException));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
