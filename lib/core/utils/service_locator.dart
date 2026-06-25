import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:task_electro_pi/core/utils/api_services.dart';
import 'package:task_electro_pi/core/utils/app_cache.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/movies/data/repository/movie_repository.dart';
import 'package:task_electro_pi/feature/movies/data/repository/movie_repository_impl.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/carousel/movie_carousel_cubit.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/tabbed/movie_tabbed_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  await AppCache.init();

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppStrings.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        queryParameters: <String, dynamic>{'api_key': AppStrings.apiKey},
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    return dio;
  });

  getIt.registerLazySingleton<ApiServices>(
    () => ApiServices(getIt<Dio>()),
  );

  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(apiServices: getIt<ApiServices>()),
  );

  getIt.registerFactory<MovieCarouselCubit>(
    () => MovieCarouselCubit(movieRepository: getIt<MovieRepository>()),
  );

  getIt.registerFactory<MovieTabbedCubit>(
    () => MovieTabbedCubit(movieRepository: getIt<MovieRepository>()),
  );
}
