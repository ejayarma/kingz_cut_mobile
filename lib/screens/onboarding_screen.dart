import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kingz_cut_mobile/screens/home/dashboard_screen.dart';
import 'package:kingz_cut_mobile/screens/launch_screen.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      ),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      titlePadding: const EdgeInsets.symmetric(vertical: 30),
      bodyAlignment: Alignment.center,
      bodyTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      fullScreen: true,
      imagePadding: const EdgeInsets.symmetric(vertical: 10.0),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: IntroductionScreen(
        globalBackgroundColor: Theme.of(context).colorScheme.primary,
        dotsDecorator: DotsDecorator(
          size: const Size(10.0, 10.0),
          activeSize: const Size(22.0, 10.0),
          color: Theme.of(context).colorScheme.onPrimary,
          activeColor: Theme.of(context).colorScheme.inversePrimary,
          activeShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        pages: [
          PageViewModel(
            title: "Welcome to Kingz Cut Barbering Salon",
            body:
                "Effortless bookings, zero wait times. Schedule your haircut in seconds and enjoy a seamless grooming experience.",
            image: _introImage('assets/images/intro/intro1.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Your Style, Your Barber",
            body:
                "Choose your favorite barber, select your preferred service, and enjoy a tailored grooming session every time.",
            image: _introImage('assets/images/intro/intro2.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Exclusive Perks & Reminders",
            body:
                "Get appointment reminders, loyalty rewards, and special discounts straight to your phone.",
            image: _introImage('assets/images/intro/intro3.png'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _goHomepage(context),
        onSkip: () => _goHomepage(context),
        showSkipButton: true,
        showNextButton: true,
        skip: Text(
          'Skip',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        next: Text(
          'Next',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        isProgress: true,
        doneStyle: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        done: Text(
          'Get Started',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  void _logAppConfig() async {
    final appConfig = await ref.read(appConfigProvider.future);
    log('🔧 AppConfig loaded: = ${appConfig?.toJson().toString()}');
  }

  Future<void> _goHomepage(BuildContext context) async {
    final notifier = ref.read(appConfigProvider.notifier);
    await notifier.setOnboarded(true);

    _logAppConfig();

    if (!mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LaunchScreen()),
      );
    }
  }

  Widget _introImage(String assetName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      height: MediaQuery.of(context).size.height * .45,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.vertical(
            bottom: Radius.circular(120),
          ),
        ),
      ),
      child: Image.asset(
        assetName,
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.height / 2,
      ),
    );
  }
}
