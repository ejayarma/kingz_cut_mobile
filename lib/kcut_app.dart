import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';
import 'package:kingz_cut_mobile/screens/auth/login_screen.dart';
import 'package:kingz_cut_mobile/screens/splash_screen.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/customer_provider.dart';

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
        _navigateToLogin();
      } else {
        debugPrint('User is signed in!');
        await _handleSignedInUser(user);
      }
    });
  }

  void _logAppConfig() async {
    final appConfig = await ref.read(appConfigProvider.future);
    debugPrint(
      '🔧 AppConfig loaded: hasOnboarded = ${appConfig?.hasOnboarded}',
    );
  }

  Future<void> _handleSignedInUser(User user) async {
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final customer = await customerRepo.getCustomerByUserId(user.uid);

      if (customer != null) {
        // Update state in CustomerProvider
        ref.read(customerProvider.notifier).setCustomer(customer);
      } else {
        // If customer does not exist, navigate to login
        _navigateToLogin();
      }
    } catch (e) {
      debugPrint('Error fetching customer: $e');
      // Optionally, show an error or fallback
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
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
