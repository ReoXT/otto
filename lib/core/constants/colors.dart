import 'package:flutter/material.dart';

/// Otto brand color palette
/// Based on otto-spec.md lines 58-69
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6B9DFC); // Soft blue - trust, calm
  static const Color secondary = Color(0xFFFFB347); // Warm orange - energy, playfulness
  static const Color accent = Color(0xFF7ED4AD); // Mint green - success, freshness

  // Background Colors
  static const Color background = Color(0xFFFFF9F5); // Warm cream - soft, easy on eyes
  static const Color surface = Color(0xFFFFFFFF); // White

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436); // Dark gray
  static const Color textSecondary = Color(0xFF636E72); // Medium gray

  // Status Colors
  static const Color error = Color(0xFFFF6B6B); // Soft red - error/over limit
  static const Color success = Color(0xFF7ED4AD); // Mint green - success/under limit

  // Progress Bar Colors
  static const Color progressGreen = Color(0xFF7ED4AD); // Under/on target
  static const Color progressYellow = Color(0xFFFFB347); // Approaching limit (80-100%)
  static const Color progressRed = Color(0xFFFF6B6B); // Over limit
}
