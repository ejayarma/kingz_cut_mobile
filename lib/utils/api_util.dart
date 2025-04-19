import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kingz_cut_mobile/utils/api_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';


Map<String, dynamic> _parseAndDecode(String response) {
  return jsonDecode(response) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class ApiUtil {

  static const kServerBase = "${ApiConfig.kApiBaseUrl}/api/v1/authService";

  late final String? authToken;
  final BuildContext context;

  ApiUtil(this.context) {
    _initializeClient();
  }

  late final Dio httpClient;

  void _initializeClient() {
    final userDetailProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    authToken = userDetailProvider.currentUser?.token;
    final options = BaseOptions(
      baseUrl: kServerBase,
      followRedirects: false,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    );

    httpClient =
        Dio(options)
          ..interceptors.addAll([
            ApiAuthInterceptor(authToken: authToken, context: context),
            LogInterceptor(
              responseBody: true,
              requestBody: true,
              request: true,
              logPrint: (object) => print(object),
            ),
          ])
          ..transformer =
              (BackgroundTransformer()..jsonDecodeCallback = parseJson);
  }
}

class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  ApiResponse({this.data, this.message, this.success = false, this.statusCode});
}

extension ApiResponseHandler on ApiUtil {
  Future<ApiResponse<T>> handleResponse<T>({
    required Future<Response> Function() request,
    T Function(Map<String, dynamic> json)? fromJson,
  }) async {
    try {
      final response = await request();

      // Get status code
      final statusCode = response.statusCode;

      // Check if response has data
      if (response.data == null) {
        return ApiResponse(
          success: false,
          message: 'No data received from server',
          statusCode: statusCode,
        );
      }

      // Handle successful response
      if (statusCode! >= 200 && statusCode < 300) {
        if (fromJson != null) {
          // If response.data is already a Map<String, dynamic>
          if (response.data is Map<String, dynamic>) {
            return ApiResponse(
              data: fromJson(response.data),
              success: true,
              statusCode: statusCode,
            );
          }

          // If response.data needs to be decoded from JSON string
          if (response.data is String) {
            final decodedData = await parseJson(response.data);
            return ApiResponse(
              data: fromJson(decodedData),
              success: true,
              statusCode: statusCode,
            );
          }
        }

        // Return raw response if no fromJson provided
        return ApiResponse(
          data: response.data as T,
          success: true,
          statusCode: statusCode,
        );
      }

      // Handle unsuccessful response
      return ApiResponse(
        success: false,
        message: _extractErrorMessage(response.data),
        statusCode: statusCode,
      );
    } on SocketException {
      return ApiResponse(
        success: false,
        message: "Please check your internet connection",
        statusCode: 400,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: _handleDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  String _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Check common error message fields
      return responseData['message'] ??
          responseData['error'] ??
          responseData['error_message'] ??
          'Unknown error occurred';
    }
    if (responseData is String) {
      return responseData;
    }
    return 'Unknown error occurred';
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        return _extractErrorMessage(e.response?.data);
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

class ApiAuthInterceptor extends Interceptor {
  final String? authToken; // Store the auth token
  final BuildContext context;

  ApiAuthInterceptor({
    this.authToken,
    required this.context,
  }); // Constructor to receive the token

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (authToken != null && authToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }

    // Add any other common headers you need
    options.headers['Accept'] = 'application/json';
    options.headers['contentType'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle token-related errors (e.g., 401 Unauthorized)
    if (err.response?.statusCode == 401) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Placeholder()),
      );
    }
    return handler.next(err);
  }
}
