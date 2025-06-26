import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/screens/home/barber_home_page.dart';
import 'package:kingz_cut_mobile/screens/home/barbers_booking_page.dart';
import 'package:kingz_cut_mobile/screens/home/customer_bookings_page.dart';
import 'package:kingz_cut_mobile/screens/home/customer_home_page.dart';
import 'package:kingz_cut_mobile/screens/home/customer_messaging_page.dart';
import 'package:kingz_cut_mobile/screens/home/profile_page.dart';
import 'package:kingz_cut_mobile/screens/notifications_page.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
import 'package:kingz_cut_mobile/widgets/notification_badge.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final int? initialPageIndex;

  const DashboardScreen({super.key, this.initialPageIndex});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends ConsumerState<DashboardScreen> {
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set the initial page index only once when the widget is first created
    if (widget.initialPageIndex != null) {
      _pageIndex = widget.initialPageIndex!;
    }
  }

  List<Widget> _buildPages() {
    final userType = ref.read(appConfigProvider).value?.userType;
    return [
      userType == UserType.customer
          ? const CustomerHomePage()
          : const BarberHomePage(),

      userType == UserType.customer
          ? const CustomerBookingsPage()
          : const BarberBookingsPage(),

      const NotificationsPage(),
      // const CustomerMessagingPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();
    return Scaffold(
      body: SafeArea(child: pages[_pageIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() => _pageIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            tooltip: 'Home',
            icon: ImageIcon(AssetImage('assets/images/icons/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            tooltip: 'Bookings',
            icon: ImageIcon(AssetImage('assets/images/icons/bookings.png')),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            tooltip: 'Notifications',
            icon: NotificationIconButton(iconColor: Colors.grey),
            activeIcon: NotificationIconButton(
              iconColor: Theme.of(context).colorScheme.primary,
            ),
            // activeIcon: Icon(CupertinoIcons.chat_bubble_text_fill),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            tooltip: 'Profile',
            icon: ImageIcon(AssetImage('assets/images/icons/profile.png')),

            // activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
