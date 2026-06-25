import 'dart:io';

import 'package:dio/dio.dart';
import 'package:task_electro_pi/core/errors/api_error_response.dart';
import 'package:task_electro_pi/core/errors/failure.dart';

class ServerFailure extends Failure {
  ServerFailure(super.message);

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response!.statusCode!,
          dioException.response?.data,
        );
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with the movie server');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with the movie server');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with the movie server');
      case DioExceptionType.cancel:
        return ServerFailure('Request to the movie server was cancelled');
      case DioExceptionType.connectionError:
        return ServerFailure('No internet connection');
      case DioExceptionType.unknown:
        if (dioException.error is SocketException) {
          return ServerFailure('No internet connection');
        }
        return ServerFailure('Unknown error with the movie server');
      default:
        return ServerFailure('Oops, there was an error. Please try again');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (response is Map<String, dynamic>) {
      final apiErrorResponse = ApiErrorResponse.fromJson(response);
      return ServerFailure(apiErrorResponse.message);
    }

    switch (statusCode) {
      case 401:
        return ServerFailure('Unauthorized, please check your API key');
      case 403:
        return ServerFailure('Forbidden');
      case 404:
        return ServerFailure('Your request was not found, please try again');
      case 500:
        return ServerFailure('Internal server error, please try again');
      default:
        return ServerFailure('Oops, there was an error. Please try again');
    }
  }
}
