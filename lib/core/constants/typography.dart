import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Otto typography configuration
/// Based on otto-spec.md lines 71-76
class AppTypography {
  AppTypography._();

  /// Display and header font - Nunito (rounded, friendly)
  static TextStyle get displayFont => GoogleFonts.nunito();

  /// Body text font - Inter (clean readability)
  static TextStyle get bodyFont => GoogleFonts.inter();

  /// Numbers and stats font - Space Mono (clear, distinct)
  static TextStyle get numbersFont => GoogleFonts.spaceMono();

  // Display styles
  static TextStyle displayLarge = displayFont.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle displayMedium = displayFont.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static TextStyle displaySmall = displayFont.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  // Heading styles
  static TextStyle headlineLarge = displayFont.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineMedium = displayFont.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineSmall = displayFont.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // Body styles
  static TextStyle bodyLarge = bodyFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodyMedium = bodyFont.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodySmall = bodyFont.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Number/Stats styles
  static TextStyle numberLarge = numbersFont.copyWith(
    fontSize: 48,
    fontWeight: FontWeight.bold,
  );

  static TextStyle numberMedium = numbersFont.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle numberSmall = numbersFont.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  // Button text
  static TextStyle button = displayFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Label text
  static TextStyle label = bodyFont.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
