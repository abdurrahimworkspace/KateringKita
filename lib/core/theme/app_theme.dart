import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgMain,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.cardBg,
        error: AppColors.urgencyRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textTitle,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: AppTypography.display1,
        headlineLarge: AppTypography.heading1,
        headlineMedium: AppTypography.heading2,
        bodyLarge: AppTypography.bodyRegular,
        bodySmall: AppTypography.micro,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTypography.bodyRegular.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: 6,
          shadowColor: AppColors.primary.withOpacity(0.28),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgMain,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textTitle),
        titleTextStyle: AppTypography.heading2.copyWith(color: AppColors.textTitle),
      ),
    );
  }
}
