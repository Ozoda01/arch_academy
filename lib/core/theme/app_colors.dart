import 'package:flutter/material.dart';

class AppColors {
  // Course/Language specific colors
  static const dartColor = Color(0xFF0175C2);     // Blue
  static const flutterColor = Color(0xFF54C5F8);  // Light Blue
  static const javaColor = Color(0xFFED8B00);     // Orange
  static const kotlinColor = Color(0xFF7F52FF);   // Purple

  // Brand / Light Theme Colors
  static const primary = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFFEBE9FF);
  static const background = Color(0xFFF8F9FF);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1E1E2E);
  static const textSecondary = Color(0xFF6E6E82);

  // Brand / Dark Theme Colors
  static const darkBackground = Color(0xFF0C0C14);
  static const darkSurface = Color(0xFF161622);
  static const darkPrimary = Color(0xFF8B85FF);
  static const darkTextPrimary = Color(0xFFECECF1);
  static const darkTextSecondary = Color(0xFF9E9EB2);

  // Status Colors
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFFB300);

  // Gradients for premium aesthetics
  static const primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF8E87FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const darkPrimaryGradient = LinearGradient(
    colors: [darkPrimary, Color(0xFFA5A0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glassGradient = LinearGradient(
    colors: [
      Colors.white24,
      Colors.white12,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
