// lib/state_providers/notification_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const NotificationState());

  Future<void> fetchNotifications(String uid) async {
    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final notifications = await _repository.getNotifications(uid);
      state = state.copyWith(
        notifications: notifications,
        isLoading: false,
        hasError: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final success = await _repository.markAsRead(notificationId);
      if (success) {
        final updatedNotifications =
            state.notifications.map((notification) {
              if (notification.id == notificationId) {
                return notification.copyWith(
                  read: true,
                  readAt: DateTime.now(),
                );
              }
              return notification;
            }).toList();

        state = state.copyWith(notifications: updatedNotifications);
      }
    } catch (e) {
      state = state.copyWith(
        hasError: true,
        errorMessage: 'Failed to mark notification as read: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }

  // Helper method to get unread count
  int get unreadCount => state.notifications.where((n) => !n.read).length;
}

// Provider for the notification notifier
final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      return NotificationNotifier(repository);
    });

// Provider to automatically fetch notifications when user changes
final autoFetchNotificationsProvider = Provider<void>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  final notifier = ref.read(notificationNotifierProvider.notifier);

  if (user != null) {
    notifier.fetchNotifications(user.uid);
  }
});

// Provider for unread notification count
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notificationState = ref.watch(notificationNotifierProvider);
  return notificationState.notifications.where((n) => !n.read).length;
});
