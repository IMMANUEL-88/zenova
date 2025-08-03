import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenova/theme/custom_themes/elevated_button_theme.dart';
import 'package:zenova/theme/custom_themes/outlined_button_theme.dart';
import 'package:zenova/theme/custom_themes/text_field_theme.dart';
import 'package:zenova/theme/custom_themes/text_theme.dart';

// Light theme configuration
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.grey.withValues(alpha: 0.5),
    onSecondary: Colors.grey,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  // dividerColor: EColors.white,
  scaffoldBackgroundColor: Color(0xFFF7F7F7),
  fontFamily: GoogleFonts.poppins().fontFamily,
  elevatedButtonTheme: EElevatedButtonTheme.lightElevatedButtonTheme,
  textTheme: ETextTheme.lightTextTheme,
  inputDecorationTheme: ETextFormFieldTheme.lightInputDecorationTheme,
  outlinedButtonTheme: EOutlinedButtonTheme.lightOutlinedButtonTheme,
);

// Dark theme configuration
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.grey.withValues(alpha: 0.5),
    onSecondary: Colors.grey,
    surface: Color(0xFF121212),
    onSurface: Colors.white,
  ),
  // dividerColor: Colors.black,
  scaffoldBackgroundColor: Color(0xFF0f0f0f),
  fontFamily: GoogleFonts.poppins().fontFamily,
  elevatedButtonTheme: EElevatedButtonTheme.darkElevatedButtonTheme,
  textTheme: ETextTheme.darkTextTheme,
  inputDecorationTheme: ETextFormFieldTheme.darkInputDecorationTheme,
  outlinedButtonTheme: EOutlinedButtonTheme.darkOutlinedButtonTheme,
);
