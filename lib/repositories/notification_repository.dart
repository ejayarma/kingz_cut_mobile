// lib/repositories/notification_repository.dart
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  late final Dio _dio;

  NotificationRepository({required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add logging interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => log(obj.toString()),
      ),
    );
  }

  Future<List<NotificationModel>> getNotifications(String uid) async {
    try {
      final response = await _dio.get(
        '/api/notifications',
        queryParameters: {'uid': uid},
      );

      final notificationsResponse = NotificationsResponse.fromJson(
        response.data,
      );
      return notificationsResponse.notifications;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Failed to fetch notifications: ${e.response!.statusCode}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<bool> createNotification(CreateNotificationRequest request) async {
    try {
      final response = await _dio.post(
        '/api/notifications',
        data: request.toJson(),
      );

      log("Notification creation response: ${response.data}");

      return response.statusCode == 201;
    } on DioException catch (e) {
      if (e.response != null) {
        log("Notification creation error: ${e.response!.data}");
        throw Exception(
          'Failed to create notification: ${e.response!.statusCode}',
        );
      } else {
        throw Exception('Failed to create notification: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await _dio.patch(
        '/api/notifications/$notificationId',
        data: {'read': true},
      );

      log("Notification mark as read response: ${response.data}");

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response != null) {
        log("Mark as read error: ${e.response!.data}");
        throw Exception(
          'Failed to mark notification as read: ${e.response!.statusCode}',
        );
      } else {
        throw Exception('Failed to mark notification as read: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Clean up resources
  void dispose() {
    _dio.close();
  }
}

// Provider for the repository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final repository = NotificationRepository(
    baseUrl:
        'https://kingz-cut-admin.vercel.app', // Replace with your actual URL
  );

  // Dispose the repository when the provider is disposed
  ref.onDispose(() {
    repository.dispose();
  });

  return repository;
});
