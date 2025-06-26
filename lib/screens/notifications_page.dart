// lib/screens/notifications_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:kingz_cut_mobile/utils/custom_ui_block.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/notification_model.dart';
import '../state_providers/notification_notifier.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotifications();
    });
  }

  Future<void> _fetchNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await ref
          .read(notificationNotifierProvider.notifier)
          .fetchNotifications(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Notifications'),
        // backgroundColor: theme.primaryColor,
        // foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        elevation: 0,
        actions: [
          if (notificationState.notifications.isNotEmpty)
            TextButton(
              onPressed: () => _markAllAsRead(),
              child: Text(
                'Mark All Read',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchNotifications(),
        child: _buildBody(context, notificationState, theme),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationState state,
    ThemeData theme,
  ) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load notifications',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? 'Unknown error occurred',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchNotifications,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ll notify you when something important happens',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.notifications.length,
      itemBuilder: (context, index) {
        final notification = state.notifications[index];
        return _NotificationCard(
          notification: notification,
          onTap: () => _markAsRead(notification),
        );
      },
    );
  }

  void _markAsRead(NotificationModel notification) {
    if (!notification.read) {
      ref
          .read(notificationNotifierProvider.notifier)
          .markAsRead(notification.id);
    }
  }

  Future<void> _markAllAsRead() async {
    final unreadNotifications = ref
        .read(notificationNotifierProvider)
        .notifications
        .where((n) => !n.read);

    if (unreadNotifications.isEmpty) {
      return;
    }

    try {
      CustomUiBlock.block(context);
      for (final notification in unreadNotifications) {
        await ref
            .read(notificationNotifierProvider.notifier)
            .markAsRead(notification.id);
      }

      ref.invalidate(notificationNotifierProvider);

      await _fetchNotifications();
    } catch (e) {
      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'An error occurred marking notifications as read.',
        );
      }
    } finally {
      if (mounted) {
        CustomUiBlock.unblock(context);
      }
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = !notification.read;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            isUnread ? theme.primaryColor.withOpacity(0.05) : theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isUnread
                  ? theme.primaryColor.withOpacity(0.2)
                  : theme.dividerColor,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color:
                      isUnread
                          ? const Color(0xFFFF9600) // Your secondary color
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight:
                            isUnread ? FontWeight.w600 : FontWeight.w500,
                        color:
                            isUnread
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _getTypeIcon(notification.type),
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatNotificationType(notification.type),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeago.format(notification.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'booking':
        return Icons.event;
      case 'payment':
        return Icons.payment;
      case 'promotion':
        return Icons.local_offer;
      case 'reminder':
        return Icons.access_time;
      default:
        return Icons.notifications;
    }
  }

  String _formatNotificationType(String type) {
    return type.substring(0, 1).toUpperCase() + type.substring(1).toLowerCase();
  }
}
