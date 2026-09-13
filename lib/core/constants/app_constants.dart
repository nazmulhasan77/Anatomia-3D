import 'package:flutter/material.dart';

/// App-wide constants for Anatomia 3D (Medical Technology aesthetic)
class AppColors {
  // Primary brand colors from spec
  static const Color primaryBlue = Color(0xFF0066FF);
  static const Color secondaryCyan = Color(0xFF00C2FF);
  static const Color accentNeon = Color(0xFF00F0FF);
  static const Color accentPurple = Color(0xFF7928CA);
  static const Color accentRose = Color(0xFFFF0080);

  // Dark Navy backgrounds (Medical Sci-fi & Clinical)
  static const Color darkBg = Color(0xFF060B17);
  static const Color darkBgSecondary = Color(0xFF0C1427);
  static const Color darkSurface = Color(0xFF131D35);
  static const Color darkCardBg = Color(0xCC111C33);
  static const Color darkBorder = Color(0x3300C2FF);

  // Light Mode backgrounds
  static const Color lightBg = Color(0xFFF4F7FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBg = Color(0xEEFFFFFF);
  static const Color lightBorder = Color(0x220066FF);

  // System & Functional colors
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF5252);
  static const Color textPrimaryDark = Color(0xFFF0F4FF);
  static const Color textSecondaryDark = Color(0xFF8B9CB8);
  static const Color textPrimaryLight = Color(0xFF0C1427);
  static const Color textSecondaryLight = Color(0xFF5A6E8C);

  // Anatomical Layer Highlight Colors
  static const Color skinLayer = Color(0xFFFFBD99);
  static const Color muscleLayer = Color(0xFFDE4343);
  static const Color boneLayer = Color(0xFFFFF2D6);
  static const Color organLayer = Color(0xFF9C27B0);
  static const Color vesselLayer = Color(0xFF2979FF);
  static const Color nerveLayer = Color(0xFFFFD600);
}

class AppConstants {
  static const String appName = 'Anatomia 3D';
  static const String appSubtitle = 'Explore the Human Body in 3D';
  static const String appTagline = 'See it. Zoom it. Understand it.';
  
  // Animation Durations
  static const Duration splashDuration = Duration(milliseconds: 2200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 600);
}
