import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';
import 'package:kingz_cut_mobile/screens/auth/otp_verification_page.dart';
import 'package:kingz_cut_mobile/screens/home/dashboard_screen.dart';
import 'package:kingz_cut_mobile/screens/onboarding_screen.dart';
import 'package:kingz_cut_mobile/screens/launch_screen.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/notification_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';
// import 'package:kingz_cut_mobile/state_providers/app_config_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _navigate();
    });
  }

  Future<void> _navigate() async {
    // Wait for provider to load
    final appConfig = await ref.read(appConfigProvider.future);

    if (!mounted) return;

    // Add splash delay
    await Future.delayed(Durations.extralong4);

    if (!mounted) return;

    if (appConfig?.hasOnboarded == false) {
      // Navigate to launch screen (login flow starts there)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
      );
      return;
    }

    if (appConfig?.userType == null) {
      // Navigate to onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LaunchScreen()),
      );
      return;
    }

    if (FirebaseAuth.instance.currentUser != null) {
      log("User exists");

      // Handle signed in user and check if navigation is needed
      final shouldNavigateToDashboard = await _handleSignedInUser(
        FirebaseAuth.instance.currentUser!,
      );

      // Only navigate to dashboard if phone verification is not needed
      if (mounted && shouldNavigateToDashboard) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
      return;
    } else {
      // Navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LaunchScreen()),
      );
      return;
    }
  }

  Future<bool> _handleSignedInUser(User user) async {
    log("Running _handleSignedInUser");
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final customer = await customerRepo.getCustomerByUserId(user.uid);
      final staffRepo = ref.read(staffRepositoryProvider);
      final staff = await staffRepo.getStaffByUserId(user.uid);

      String phone = '';

      if (customer != null) {
        // Update state in CustomerProvider
        ref.read(customerNotifier.notifier).setCustomer(customer);
        phone = customer.phone;
      } else if (staff != null) {
        // If staff exists, set staff data
        ref.read(staffNotifier.notifier).setStaff(staff);
        phone = staff.phone;
        _logAppConfig();
      } else {
        // If neither customer nor staff exists, return true to navigate to dashboard
        // This might need different handling based on your app logic
        return true;
      }

      log('phone: $phone');

      // Any user without phone will verify
      if (phone.isEmpty && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return OtpVerificationScreen(
                phone: null,
                validatePhone: true,
                onPhoneNumberSubmitted: _handleOtpVerification,
              );
            },
          ),
        );
        return false; // Don't navigate to dashboard
      }
      // Staff verify OTP always
      else if (staff != null && phone.isNotEmpty && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return OtpVerificationScreen(
                phone: phone,
                validatePhone: false,
                onPhoneNumberSubmitted: _handleStaffOtpVerification,
              );
            },
          ),
        );
        return false; // Don't navigate to dashboard
      }

      return true; // Navigate to dashboard if no phone verification needed
    } catch (e) {
      log('Error fetching customer: $e');
      // Return true to navigate to dashboard or handle error differently
      return true;
    }
  }

  void _logAppConfig() async {
    final appConfig = await ref.read(appConfigProvider.future);
    final customer = ref.read(customerNotifier).value;
    final staff = ref.read(staffNotifier).value;

    log('🔧 AppConfig loaded: = ${appConfig?.toJson().toString()}');
    log('🔧 Customer loaded: = ${customer?.toJson().toString()}');
    log('🔧 Staff loaded: = ${staff?.toJson().toString()}');
  }

  Future<void> _handleOtpVerification(
    String phone,
    bool verified,
    WidgetRef ref,
  ) async {
    if (verified) {
      final userType = ref.read(appConfigProvider).value?.userType;
      if (userType == UserType.customer) {
        final customer = await ref
            .read(customerRepositoryProvider)
            .getCustomerByUserId(FirebaseAuth.instance.currentUser?.uid ?? '');
        if (customer != null) {
          await ref
              .read(customerRepositoryProvider)
              .updateCustomer(customer.id, customer.copyWith(phone: phone));
        }

        ref.invalidate(customerNotifier);
      }

      if (userType == UserType.barber) {
        final staff = await ref
            .read(staffRepositoryProvider)
            .getStaffByUserId(FirebaseAuth.instance.currentUser?.uid ?? '');
        if (staff != null) {
          await ref
              .read(staffRepositoryProvider)
              .updateStaff(staff.id, staff.copyWith(phone: phone));
        }
        ref.invalidate(staffNotifier);
      }

      await FirebaseAuth.instance.currentUser?.reload();
      await Future.delayed(Durations.long2);

      if (ref.context.mounted) {
        Navigator.of(ref.context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return DashboardScreen();
            },
          ),
        );
      }
    }
  }

  Future<void> _handleStaffOtpVerification(
    String phone,
    bool verified,
    WidgetRef ref,
  ) async {
    if (verified) {
      if (ref.context.mounted) {
        Navigator.of(ref.context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return DashboardScreen();
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Kingz Cut Barbering Salon',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Image.asset('assets/images/kingz_cut_logo.png', height: 170),
            Text(
              'Kingz Cut Barbering Salon',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
