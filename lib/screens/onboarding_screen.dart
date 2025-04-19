import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kingz_cut_mobile/screens/home_screen.dart';
import 'package:kingz_cut_mobile/screens/launch_screen.dart';
import 'package:kingz_cut_mobile/screens/splash_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    //this is a page decoration for intro screen

    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      ), //tile font size, weight and color

      bodyPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      titlePadding: const EdgeInsets.all(16.0),
      bodyAlignment: Alignment.center,

      bodyTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
      ),

      imageFlex: 2,
      bodyFlex: 5,
      fullScreen: true,
      // imagePadding: const EdgeInsets.symmetric(vertical: 10.0),
      imageAlignment: Alignment.topCenter,

      // footerPadding: EdgeInsets.all(200),
    );

    return IntroductionScreen(
      globalBackgroundColor: Theme.of(context).colorScheme.primary,

      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0), //size of dots
        activeSize: const Size(22.0, 10.0),
        color: Theme.of(context).colorScheme.onPrimary, //color of dots
        activeColor:
            Theme.of(context).colorScheme.inversePrimary, //color of active dot
        activeShape: const RoundedRectangleBorder(
          //shave of active dot
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      pages: [
        //set your page view here
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
              "Get to access all favorite topics of yours from both local and global content on this platform. E.g Literature, Social Studies, BioChemeistry, Ceramics, Mathematics",
          image: _introImage('assets/images/intro/intro3.png'),
          decoration: pageDecoration,
        ),
      ],

      onDone: () => _goHomepage(context), //go to home page on done
      onSkip: () => _goHomepage(context), // You can override on skip
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
      ),
      done: Text(
        'Get Started',
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  void _goHomepage(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LaunchScreen();
        },
      ),
    );
  }

  Widget _introImage(String assetName) {
    //widget to show intro image
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      // margin: EdgeInsets.only(bottom: 50),
      height: MediaQuery.of(context).size.height * .45,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
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
