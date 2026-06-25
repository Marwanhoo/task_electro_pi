import 'package:dio/dio.dart';

class ApiServices {
  final Dio dio;

  ApiServices(this.dio);

  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await dio.get(
      endPoint,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    dynamic dataBody,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await dio.post(
      endPoint,
      data: dataBody,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> delete({
    required String endPoint,
    dynamic dataBody,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await dio.delete(
      endPoint,
      data: dataBody,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }
}
