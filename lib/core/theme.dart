import 'package:flutter/material.dart';

class AppColors {
  static const darkBlue = Color(0xFF1F3864);
  static const accentBlue = Color(0xFF2E75B6);
  static const incomeGreen = Color(0xFF3CB371);
  static const expenseRed = Color(0xFFE06666);
  static const lightGray = Color(0xFFE4E8EC);

  static const white = Colors.white;
  static const text = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
}

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",

    colorScheme: const ColorScheme.light(
      primary: AppColors.darkBlue,
      onPrimary: Colors.white,

      secondary: AppColors.accentBlue,
      onSecondary: Colors.white,

      surface: Colors.white,
      onSurface: AppColors.text,

      error: AppColors.expenseRed,
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: AppColors.lightGray,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.darkBlue,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.darkBlue,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.darkBlue,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: AppColors.text,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textSecondary,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.lightGray,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.lightGray,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.accentBlue,
          width: 2,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.lightGray,
      thickness: 1,
    ),
  );
}
