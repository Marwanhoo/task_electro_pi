import 'package:dio/dio.dart';
import 'package:task_electro_pi/core/utils/app_cache.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';

class SessionInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final sessionId = AppCache.getString(key: AppStrings.sessionIdKey);
    if (sessionId != null && sessionId.isNotEmpty) {
      options.queryParameters['session_id'] = sessionId;
    }
    handler.next(options);
  }
}
