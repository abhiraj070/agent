import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Ports the two type families from globals.css: a Georgia/serif family for
/// headlines and a system sans family for everything else.
class AppTextStyles {
  const AppTextStyles._();

  static const String serifFamily = 'serif';
  static const String sansFamily = 'sans-serif';

  static const TextStyle eyebrow = TextStyle(
    fontFamily: sansFamily,
    color: AppColors.green,
    fontSize: 9,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.6,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: serifFamily,
    color: AppColors.ink,
    fontWeight: FontWeight.w400,
    fontSize: 38,
    letterSpacing: -1.3,
    height: 1.05,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: serifFamily,
    color: AppColors.ink,
    fontWeight: FontWeight.w400,
    fontSize: 43,
    letterSpacing: -1.5,
    height: 1.04,
  );

  static const TextStyle subline = TextStyle(
    fontFamily: sansFamily,
    color: AppColors.muted,
    fontSize: 14,
    height: 1.55,
  );

  static const TextStyle body = TextStyle(
    fontFamily: sansFamily,
    color: AppColors.ink,
    fontSize: 13,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    fontFamily: sansFamily,
    color: AppColors.muted,
    fontSize: 9,
  );

  static const TextStyle small = TextStyle(
    fontFamily: sansFamily,
    color: AppColors.faint,
    fontSize: 9,
  );

  static const TextStyle resultTitle = TextStyle(
    fontFamily: serifFamily,
    color: AppColors.ink,
    fontWeight: FontWeight.w400,
    fontSize: 23,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static const TextStyle activityTitle = TextStyle(
    fontFamily: serifFamily,
    color: AppColors.ink,
    fontWeight: FontWeight.w400,
    fontSize: 17,
    height: 1.35,
  );

  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: sansFamily,
    color: Color(0xFF111612),
    fontSize: 11,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle buttonGhost = TextStyle(
    fontFamily: sansFamily,
    color: AppColors.muted,
    fontSize: 10,
  );
}
