import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/screens/onboarding_screen.dart';
import 'package:kingz_cut_mobile/screens/launch_screen.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
// import 'package:kingz_cut_mobile/state_providers/app_config_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigate();
  }

  void _navigate() async {
    // Wait for provider to load
    final appConfig = await ref.read(appConfigProvider.future);

    if (!mounted) return;

    // Add splash delay
    await Future.delayed(Durations.extralong4);

    if (!mounted) return;

    if (appConfig?.hasOnboarded == true) {
      // Navigate to launch screen (login flow starts there)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LaunchScreen()),
      );
    } else {
      // Navigate to onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
      );
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
