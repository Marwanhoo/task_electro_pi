import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task_electro_pi/core/errors/failure.dart';
import 'package:task_electro_pi/core/errors/server_failure.dart';
import 'package:task_electro_pi/core/utils/api_services.dart';
import 'package:task_electro_pi/core/utils/app_cache.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/data/model/movies_result_model.dart';
import 'package:task_electro_pi/feature/movies/data/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiServices apiServices;

  MovieRepositoryImpl({required this.apiServices});

  @override
  Future<Either<Failure, List<MovieModel>>> getTrendingMovies() {
    return fetchMovies(
      endPoint: AppStrings.trendingEndpoint,
      cacheKey: AppStrings.cacheTrendingKey,
    );
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getPopularMovies() {
    return fetchMovies(
      endPoint: AppStrings.popularEndpoint,
      cacheKey: AppStrings.cachePopularKey,
    );
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getNowPlayingMovies() {
    return fetchMovies(
      endPoint: AppStrings.nowPlayingEndpoint,
      cacheKey: AppStrings.cacheNowPlayingKey,
    );
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getComingSoonMovies() {
    return fetchMovies(
      endPoint: AppStrings.comingSoonEndpoint,
      cacheKey: AppStrings.cacheComingSoonKey,
    );
  }

  Future<Either<Failure, List<MovieModel>>> fetchMovies({
    required String endPoint,
    required String cacheKey,
  }) async {
    try {
      final responseData = await apiServices.get(endPoint: endPoint);
      final rawResults = responseData['results'] as List<dynamic>? ?? <dynamic>[];
      await AppCache.setString(key: cacheKey, value: jsonEncode(rawResults));
      final movies = MoviesResultModel.moviesFromRawList(rawResults);
      return Right(movies);
    } on DioException catch (dioException) {
      final cachedMovies = readCachedMovies(cacheKey);
      if (cachedMovies != null && cachedMovies.isNotEmpty) {
        return Right(cachedMovies);
      }
      return Left(ServerFailure.fromDioException(dioException));
    } catch (error) {
      final cachedMovies = readCachedMovies(cacheKey);
      if (cachedMovies != null && cachedMovies.isNotEmpty) {
        return Right(cachedMovies);
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  List<MovieModel>? readCachedMovies(String cacheKey) {
    final cachedJson = AppCache.getString(key: cacheKey);
    if (cachedJson == null) {
      return null;
    }
    final rawList = jsonDecode(cachedJson) as List<dynamic>;
    return MoviesResultModel.moviesFromRawList(rawList);
  }
}
