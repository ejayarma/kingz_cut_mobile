import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';
import 'package:kingz_cut_mobile/screens/auth/login_screen.dart';
import 'package:kingz_cut_mobile/screens/splash_screen.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';

class KCutApp extends ConsumerStatefulWidget {
  const KCutApp({super.key});

  @override
  ConsumerState<KCutApp> createState() => _KCutAppState();
}

class _KCutAppState extends ConsumerState<KCutApp> {
  @override
  void initState() {
    super.initState();
    _listenAuthState();
    _logAppConfig();
  }

  void _listenAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        debugPrint('User is currently signed out!');
        // _navigateToLogin();
      } else {
        debugPrint('User is signed in!');
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

      if (customer != null) {
        // Update state in CustomerProvider
        ref.read(customerNotifier.notifier).setCustomer(customer);
      } else if (staff != null) {
        // If staff exists, navigate to staff dashboard
        ref.read(staffNotifier.notifier).setStaff(staff);
        _logAppConfig();
      } else {
        // If neither customer nor staff, navigate to login
        // _navigateToLogin();
      }
    } catch (e) {
      debugPrint('Error fetching customer: $e');
      // Optionally, show an error or fallback
      // _navigateToLogin();
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
      debugPrint('🔁 AppConfig changed: ${appConfig?.toJson().toString()}');
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
