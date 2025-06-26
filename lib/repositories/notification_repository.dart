// lib/repositories/notification_repository.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';

class NotificationRepository {
  final String baseUrl;

  NotificationRepository({required this.baseUrl});

  Future<List<NotificationModel>> getNotifications(String uid) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/notifications?uid=$uid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final notificationsResponse = NotificationsResponse.fromJson(data);
        return notificationsResponse.notifications;
      } else {
        throw Exception(
          'Failed to fetch notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> createNotification(CreateNotificationRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/notifications'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/notifications/$notificationId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'read': true}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }
}

// Provider for the repository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(
    baseUrl:
        'https://kingz-cut-admin.vercel.app/', // Replace with your actual URL
  );
});
