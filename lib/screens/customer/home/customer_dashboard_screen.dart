import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/screens/customer/home/customer_bookings_page.dart';
import 'package:kingz_cut_mobile/screens/customer/home/customer_home_page.dart';
import 'package:kingz_cut_mobile/screens/customer/home/customer_messaging_page.dart';
import 'package:kingz_cut_mobile/screens/customer/home/customer_profile_page.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  final List<Widget> _pages = [
    const CustomerHomePage(),
    const CustomerBookingsPage(),
    const CustomerMessagingPage(),
    const CustomerProfilePage(),
  ];

  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_pageIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _pageIndex,

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
