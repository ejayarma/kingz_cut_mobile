// lib/widgets/notification_badge.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state_providers/notification_notifier.dart';
import '../screens/notifications_page.dart';

class NotificationBadge extends ConsumerWidget {
  final Widget child;
  final Color? badgeColor;
  final double? badgeSize;

  const NotificationBadge({
    super.key,
    required this.child,
    this.badgeColor,
    this.badgeSize = 8,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (unreadCount > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              height: badgeSize! * 2,
              width: badgeSize! * 2,
              decoration: BoxDecoration(
                color:
                    badgeColor ??
                    const Color(0xFFFF9600), // Your secondary color
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.scaffoldBackgroundColor,
                  width: 1.5,
                ),
              ),
              child:
                  unreadCount <= 9
                      ? Center(
                        child: Text(
                          unreadCount.toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : const Center(
                        child: Text(
                          '9+',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
            ),
          ),
      ],
    );
  }
}

// Notification Icon Button Widget
class NotificationIconButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;

  const NotificationIconButton({
    super.key,
    this.onPressed,
    this.iconColor,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationBadge(
      child: Icon(
        Icons.notifications_outlined,
        color: iconColor,
        size: iconSize,
      ),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const NotificationsPage()));
  }
}

// Custom App Bar with notification icon
class CustomAppBarWithNotifications extends ConsumerWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool showNotificationIcon;

  const CustomAppBarWithNotifications({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.showNotificationIcon = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor ?? theme.primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: 0,
      actions: [
        if (showNotificationIcon)
          NotificationIconButton(iconColor: foregroundColor ?? Colors.white),
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
