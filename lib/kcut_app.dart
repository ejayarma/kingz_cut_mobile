// Updated main app with notification initialization
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';
import 'package:kingz_cut_mobile/screens/auth/login_screen.dart';
import 'package:kingz_cut_mobile/screens/splash_screen.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/notification_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';
import 'package:kingz_cut_mobile/services/notification_service.dart';

class KCutApp extends ConsumerStatefulWidget {
  const KCutApp({super.key});

  @override
  ConsumerState<KCutApp> createState() => _KCutAppState();
}

class _KCutAppState extends ConsumerState<KCutApp> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize notification service
    await NotificationService.initialize();

    // Listen to auth state changes
    _listenAuthState();

    // Log app config
    _logAppConfig();
  }

  void _listenAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        log('User is currently signed out!');
        // _navigateToLogin();
      } else {
        log('User is signed in!');
        await _handleSignedInUser(user);
      }
    });
  }

  void _logAppConfig() async {
    final appConfig = await ref.read(appConfigProvider.future);
    final customer = ref.read(customerNotifier).value;
    final staff = ref.read(staffNotifier).value;

    log('🔧 AppConfig loaded: = ${appConfig?.toJson().toString()}');
    log('🔧 Customer loaded: = ${customer?.toJson().toString()}');
    log('🔧 Staff loaded: = ${staff?.toJson().toString()}');
  }

  Future<void> _handleSignedInUser(User user) async {
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final customer = await customerRepo.getCustomerByUserId(user.uid);
      final staffRepo = ref.read(staffRepositoryProvider);
      final staff = await staffRepo.getStaffByUserId(user.uid);

      // Save FCM token to user document
      await _saveFCMTokenToUser(user.uid);

      if (customer != null) {
        // Update state in CustomerProvider
        ref.read(customerNotifier.notifier).setCustomer(customer);

        // Fetch notifications for customer
        ref
            .read(notificationNotifierProvider.notifier)
            .fetchNotifications(user.uid);
      } else if (staff != null) {
        // If staff exists, navigate to staff dashboard
        ref.read(staffNotifier.notifier).setStaff(staff);

        // Fetch notifications for staff
        ref
            .read(notificationNotifierProvider.notifier)
            .fetchNotifications(user.uid);

        _logAppConfig();
      } else {
        // If neither customer nor staff, navigate to login
        // _navigateToLogin();
      }
    } catch (e) {
      log('Error fetching customer: $e');
      // Optionally, show an error or fallback
      // _navigateToLogin();
    }
  }

  Future<void> _saveFCMTokenToUser(String uid) async {
    try {
      final token = await NotificationService.getFCMToken();
      final userType = ref.read(appConfigProvider).value?.userType;
      if (token != null && userType != null) {
        // Implement for customer user
        if (userType == UserType.customer) {
          final customer = await ref
              .read(customerRepositoryProvider)
              .getCustomerByUserId(uid);
          if (customer != null) {
            ref
                .read(customerRepositoryProvider)
                .updateCustomer(
                  customer.id,
                  customer.copyWith(fcmToken: token),
                );
          }
        }

        // Implement for staff user
        if (userType == UserType.barber) {
          final staff = await ref
              .read(staffRepositoryProvider)
              .getStaffByUserId(uid);
          if (staff != null) {
            ref
                .read(staffRepositoryProvider)
                .updateStaff(staff.id, staff.copyWith(fcmToken: token));
          }
        }

        // Save token to Firestore user document
        // You'll need to implement this in your user repository
        // await ref.read(userRepositoryProvider).updateFCMToken(uid, token);
        log('FCM Token saved for user: $uid');
      }
    } catch (e) {
      log('Error saving FCM token: $e');
    }
  }

  void _navigateToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final interFontFamily = GoogleFonts.inter().fontFamily;
    final appConfigAsync = ref.watch(appConfigProvider);

    appConfigAsync.whenData((appConfig) {
      log('🔁 AppConfig changed: ${appConfig?.toJson().toString()}');
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.tealM3,
        secondary: const Color(0xFFFF9600),
        fontFamily: interFontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.tealM3,
        secondary: const Color(0xFFFF9600),
        fontFamily: interFontFamily,
      ),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
