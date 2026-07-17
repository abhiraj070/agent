import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backdrop,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.green,
        secondary: AppColors.greenStrong,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
        fontFamily: AppTextStyles.sansFamily,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      dividerColor: AppColors.line,
    );
  }
}
