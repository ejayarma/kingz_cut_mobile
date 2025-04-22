import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/screens/auth/login_screen.dart';
import 'package:kingz_cut_mobile/screens/customer/home/customer_dashboard_screen.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      // extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
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

            child: Image.asset('assets/images/barbar_waiting.png', height: 300),
          ),
          Text(
            'Welcome to Kingz Cut Barbering Salon',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 50,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed:
                      () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                        ),
                      },
                  child: Text(
                    "I'm a customer",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => {},
                  child: Text(
                    "I'm a Barber",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
