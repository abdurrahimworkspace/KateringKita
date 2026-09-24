import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle display1 = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 34 / 28,
    color: AppColors.textTitle,
  );

  static TextStyle heading1 = GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    height: 28 / 22,
    color: AppColors.textTitle,
  );

  static TextStyle heading2 = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    color: AppColors.textTitle,
  );

  static TextStyle bodyRegular = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    color: AppColors.textBody,
  );

  static TextStyle micro = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
    color: AppColors.textMuted,
  );
}
