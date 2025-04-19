import 'package:dio/dio.dart';
import 'package:kingz_cut_mobile/models/user_detail.dart';

class ApiAuthInterceptor extends Interceptor {
  final UserDetail userDetail;

  const ApiAuthInterceptor(this.userDetail);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add user ID if available
    if (userDetail.id != null) {
      options.queryParameters['user_id'] = userDetail.id;
    }

    // Add app identification
    options.queryParameters['app_id'] = generateAppId(
      appName: 'kingz_cut',
      version: '1.0.0', // Update this with your app version
    );

    // Add authorization token if available
    if (userDetail.token != null) {
      options.headers['Authorization'] = 'Bearer ${userDetail.token}';
    }

    // Set default headers
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle authentication errors
    if (err.response?.statusCode == 401) {
      // Handle unauthorized access
      // You might want to trigger a logout or token refresh here
    }
    super.onError(err, handler);
  }
}

String generateAppId({required String appName, required String version}) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return '$appName-$version-$timestamp';
}
