import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigate();
  }

  void _navigate() {
    Future.delayed(Durations.extralong4, () {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return OnBoardingScreen();
            },
          ),
        );
      }
    });
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
