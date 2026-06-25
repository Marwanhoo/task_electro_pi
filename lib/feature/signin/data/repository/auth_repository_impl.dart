import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task_electro_pi/core/errors/failure.dart';
import 'package:task_electro_pi/core/errors/server_failure.dart';
import 'package:task_electro_pi/core/utils/api_services.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/signin/data/model/auth_session_model.dart';
import 'package:task_electro_pi/feature/signin/data/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiServices apiServices;

  AuthRepositoryImpl({required this.apiServices});

  @override
  Future<Either<Failure, AuthSessionModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final tokenResponse = await apiServices.get(
        endPoint: AppStrings.requestTokenEndpoint,
      );
      final requestToken = tokenResponse['request_token'] as String?;
      if (requestToken == null || tokenResponse['success'] == false) {
        return Left(ServerFailure(statusMessage(tokenResponse)));
      }

      final validateResponse = await apiServices.post(
        endPoint: AppStrings.validateLoginEndpoint,
        dataBody: <String, dynamic>{
          'username': username,
          'password': password,
          'request_token': requestToken,
        },
      );
      if (validateResponse['success'] != true) {
        return Left(ServerFailure(statusMessage(validateResponse)));
      }

      final sessionResponse = await apiServices.post(
        endPoint: AppStrings.createSessionEndpoint,
        dataBody: <String, dynamic>{'request_token': requestToken},
      );
      final sessionId = sessionResponse['session_id'] as String?;
      if (sessionId == null || sessionResponse['success'] != true) {
        return Left(ServerFailure(statusMessage(sessionResponse)));
      }

      final accountResponse = await apiServices.get(
        endPoint: AppStrings.accountEndpoint,
        queryParameters: <String, dynamic>{'session_id': sessionId},
      );
      final accountId = accountResponse['id'] as int? ?? 0;
      final accountUsername =
          accountResponse['username'] as String? ?? username;

      return Right(
        AuthSessionModel(
          sessionId: sessionId,
          accountId: accountId,
          username: accountUsername,
        ),
      );
    } on DioException catch (dioException) {
      return Left(ServerFailure.fromDioException(dioException));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout({required String sessionId}) async {
    try {
      await apiServices.delete(
        endPoint: AppStrings.deleteSessionEndpoint,
        dataBody: <String, dynamic>{'session_id': sessionId},
      );
      return const Right(null);
    } on DioException catch (dioException) {
      return Left(ServerFailure.fromDioException(dioException));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  String statusMessage(Map<String, dynamic> json) {
    return json['status_message'] as String? ??
        json['message'] as String? ??
        'Authentication failed';
  }
}
