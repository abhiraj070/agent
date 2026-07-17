import 'package:flutter/material.dart';

import '../../data/local/seed_data.dart';
import '../theme/app_colors.dart';
import 'selectable_chip.dart';

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
              return SelectableChip(
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
