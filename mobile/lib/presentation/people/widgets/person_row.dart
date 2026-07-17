import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/person_avatar.dart';
import '../../../domain/entities/person.dart';

/// Ports `.person-row`: avatar + name/role/language + chevron.
class PersonRow extends StatelessWidget {
  const PersonRow({super.key, required this.person, required this.onTap});

  final Person person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 68),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            PersonAvatar(initials: person.initials, size: 42),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(person.name, style: const TextStyle(color: AppColors.ink, fontSize: 13)),
                  const SizedBox(height: 5),
                  Text(
                    '${person.role} · ${person.language}',
                    style: const TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                ],
              ),
            ),
            const Text('›', style: TextStyle(color: AppColors.faint, fontSize: 19)),
          ],
        ),
      ),
    );
  }
}
