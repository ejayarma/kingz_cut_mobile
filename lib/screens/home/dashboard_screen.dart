import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/screens/home/barber_home_page.dart';
import 'package:kingz_cut_mobile/screens/home/barbers_booking_page.dart';
import 'package:kingz_cut_mobile/screens/home/customer_bookings_page.dart';
import 'package:kingz_cut_mobile/screens/home/customer_home_page.dart';
import 'package:kingz_cut_mobile/screens/home/customer_messaging_page.dart';
import 'package:kingz_cut_mobile/screens/home/customer_profile_page.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final int initialPageIndex;

  const DashboardScreen({super.key, required this.initialPageIndex});

  const DashboardScreen.withInitialPage({super.key, this.initialPageIndex = 0});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends ConsumerState<DashboardScreen> {
  int _pageIndex = 0;

  List<Widget> _buildPages() {
    final userType = ref.read(appConfigProvider).value?.userType;
    return [
      userType == UserType.customer
          ? const CustomerHomePage()
          : const BarberHomePage(),

      userType == UserType.customer
          ? const CustomerBookingsPage()
          : const BarberBookingsPage(),

      const CustomerMessagingPage(),
      const CustomerProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();
    return Scaffold(
      body: SafeArea(child: pages[widget.initialPageIndex ?? _pageIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: widget.initialPageIndex ?? _pageIndex,

        onTap: (value) {
          setState(() => _pageIndex = value);
        },
        items: const [
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
            tooltip: 'Messaging',
            icon: ImageIcon(AssetImage('assets/images/icons/messaging.png')),
            // activeIcon: Icon(CupertinoIcons.chat_bubble_text_fill),
            label: 'Messaging',
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
