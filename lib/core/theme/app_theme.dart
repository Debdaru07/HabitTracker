import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.screenBg,
    primaryColor: AppColors.green,
    fontFamily: 'Inter',

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: AppTypography.h2,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: AppTypography.body.copyWith(color: AppColors.grey),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: AppTypography.button,
      ),
    ),
  );
}
