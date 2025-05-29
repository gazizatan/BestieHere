import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Colors.pink;
  static const Color accentColor = Color(0xFFD81B60); // Darker pink
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color backgroundLight = Color(0xFFFCE4EC); // Light pink
  static const Color backgroundDark = Color(0xFF212121);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF2C2C2C);
  static const Color textColorLight = Color(0xFF212121);
  static const Color textColorDark = Colors.white;
  static const Color subtitleColor = Color(0xFF757575);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: accentColor,
          background: backgroundLight,
          surface: surfaceLight,
          error: errorColor,
        ),
        scaffoldBackgroundColor: backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColorLight),
          bodyMedium: TextStyle(color: textColorLight),
          titleLarge:
              TextStyle(color: textColorLight, fontWeight: FontWeight.bold),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          secondary: accentColor,
          background: backgroundDark,
          surface: surfaceDark,
          error: errorColor,
        ),
        scaffoldBackgroundColor: backgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColorDark),
          bodyMedium: TextStyle(color: textColorDark),
          titleLarge:
              TextStyle(color: textColorDark, fontWeight: FontWeight.bold),
        ),
      );
}
