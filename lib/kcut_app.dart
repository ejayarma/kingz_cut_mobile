import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/home_screen.dart';

class KCutApp extends StatelessWidget {
  const KCutApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The Mandy red, light theme.
      theme: FlexThemeData.light(scheme: FlexScheme.tealM3),
      // The Mandy red, dark theme.
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.tealM3),
      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.system,
      home: const HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
