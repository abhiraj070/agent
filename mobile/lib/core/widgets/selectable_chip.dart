import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A single toggleable pill option in a 2-column chip grid — the visual
/// unit behind `.role-option` in globals.css. Shared by [RolePicker] and
/// any other single-choice chip grid (e.g. the reply-language picker).
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.green.withOpacity(0.1)
              : const Color(0x80070C09),
          border: Border.all(
            color: selected
                ? AppColors.green.withOpacity(0.38)
                : Colors.white.withOpacity(0.075),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.ink : AppColors.muted,
                  fontSize: 9,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.green : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColors.green
                      : Colors.white.withOpacity(0.16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
