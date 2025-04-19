import 'package:kingz_cut_mobile/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData kLightTheme = _buildLightTheme();

ThemeData _buildLightTheme() {
  ThemeData base = ThemeData.light(useMaterial3: true);
  final ColorScheme appColorScheme = ColorScheme.fromSeed(
    seedColor: kSeedColorDark,
  );

  final errorInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: appColorScheme.error),
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  );

  var regularInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: appColorScheme.primary),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  );

  return base.copyWith(
    colorScheme: appColorScheme,
    navigationBarTheme: base.navigationBarTheme.copyWith(
      // backgroundColor: children_dark,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 8.0, overflow: TextOverflow.fade),
      ),
    ),

    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      iconTheme: base.iconTheme.copyWith(color: Colors.black),
      backgroundColor: appColorScheme.primary,
      titleTextStyle: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black,
      ),
      elevation: 5,
      toolbarTextStyle: base.textTheme.titleLarge!.merge(
        GoogleFonts.montserrat(),
      ),
    ),
    textTheme: GoogleFonts.montserratTextTheme(base.textTheme),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    dropdownMenuTheme: base.dropdownMenuTheme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: regularInputBorder,
        disabledBorder: regularInputBorder,
        focusedBorder: regularInputBorder,
        errorBorder: errorInputBorder,
        focusedErrorBorder: errorInputBorder,
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        labelStyle: GoogleFonts.montserrat(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    /// INPUT DECORATION
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      enabledBorder: regularInputBorder,
      disabledBorder: regularInputBorder,
      focusedBorder: regularInputBorder,
      errorBorder: errorInputBorder,
      focusedErrorBorder: errorInputBorder,
      contentPadding: const EdgeInsets.all(12.0),
      labelStyle: GoogleFonts.montserrat(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
      floatingLabelStyle: const TextStyle(color: Colors.black),
      hintStyle: base.textTheme.titleMedium!
          .copyWith(fontWeight: FontWeight.normal, color: Colors.grey)
          .merge(GoogleFonts.montserrat()),
    ),
  );
}
