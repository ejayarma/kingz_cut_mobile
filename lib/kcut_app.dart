import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/screens/splash_screen.dart';

class KCutApp extends StatelessWidget {
  const KCutApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // The Mandy red, light theme.
      theme: FlexThemeData.light(
        scheme: FlexScheme.tealM3,
        secondary: Color(0xFFFF9600),
      ),
      // The Mandy red, dark theme.
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.tealM3,
        secondary: Color(0xFFFF9600),
      ),
      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
