import 'package:flutter/material.dart';

import '../../data/local/seed_data.dart';
import '../theme/app_colors.dart';

/// Ports `.role-first`/`.role-options`: a labelled card of 2-column radio
/// chips for picking a person's role.
class RolePicker extends StatelessWidget {
  const RolePicker({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.04),
        border: Border.all(color: AppColors.green.withOpacity(0.18)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FIRST, CHOOSE THEIR ROLE',
            style: TextStyle(
              color: AppColors.green,
              fontSize: 7,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Who are they to you?',
            style: TextStyle(
              fontFamily: 'serif',
              color: AppColors.ink,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 11),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 7,
            crossAxisSpacing: 7,
            childAspectRatio: 3.2,
            children: SeedData.personRoles.map((role) {
              final selected = role == value;
              return _RoleOption(
                label: role,
                selected: selected,
                onTap: () => onChanged(role),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
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
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.ink : AppColors.muted,
                fontSize: 9,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              width: 6,
              height: 6,
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
