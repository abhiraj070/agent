import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum PillButtonVariant { primary, ghost, accent }

/// Ports `.onboarding-primary` / `.onboarding-back` / `.sheet-primary` pill
/// buttons: full-bleed rounded rect, 51px min height, three visual variants.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PillButtonVariant.primary,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final PillButtonVariant variant;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    final BorderSide border;

    switch (variant) {
      case PillButtonVariant.primary:
        background = const Color(0xF0F6F2EF);
        foreground = const Color(0xFF111612);
        border = BorderSide.none;
        break;
      case PillButtonVariant.accent:
        background = AppColors.green;
        foreground = const Color(0xFF102018);
        border = BorderSide.none;
        break;
      case PillButtonVariant.ghost:
        background = Colors.white.withOpacity(0.025);
        foreground = AppColors.muted;
        border = const BorderSide(color: AppColors.line);
        break;
    }

    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        minimumSize: const Size(0, 51),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          side: border,
        ),
      ),
      child: Text(
        label,
        style: variant == PillButtonVariant.ghost
            ? AppTextStyles.buttonGhost
            : AppTextStyles.buttonPrimary.copyWith(color: foreground),
        textAlign: TextAlign.center,
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
