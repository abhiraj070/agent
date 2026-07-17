import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/people_controller.dart';
import '../../application/screen_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/bottom_sheet_shell.dart';
import '../shared_sheets/person_form_sheet.dart';
import 'widgets/person_row.dart';

/// Ports the `people-screen` subscreen: "My People" list, add-person entry
/// point, and a link through to Activity.
class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final people = ref.watch(peopleControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(23, 8, 23, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _RoundIconButton(
                icon: '‹',
                onTap: () => ref.read(currentScreenProvider.notifier).state = AppScreen.home,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('YOUR TRUSTED CIRCLE', style: AppTextStyles.eyebrow),
                    const SizedBox(height: 5),
                    Text('My People', style: AppTextStyles.headline.copyWith(fontSize: 36)),
                  ],
                ),
              ),
              _RoundIconButton(
                icon: '＋',
                fontSize: 18,
                onTap: () => BottomSheetShell.show(
                  context,
                  child: PersonFormSheet(
                    onSubmit: ({
                      required name,
                      required role,
                      required phone,
                      required language,
                      note,
                    }) async {
                      await ref.read(peopleControllerProvider.notifier).add(
                            name: name,
                            role: role,
                            phone: phone,
                            language: language,
                            note: note,
                          );
                      if (context.mounted) {
                        AppToast.show(context, '$name added to My People');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 27),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: AppColors.soft,
              border: Border.all(color: AppColors.green.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Text('◇', style: TextStyle(color: AppColors.green, fontSize: 10)),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'Added manually. Your contacts stay untouched.',
                    style: TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          for (final person in people)
            PersonRow(
              person: person,
              onTap: () => AppToast.show(context, '${person.name} · ${person.language}'),
            ),
          const SizedBox(height: 26),
          InkWell(
            onTap: () => ref.read(currentScreenProvider.notifier).state = AppScreen.activity,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.025),
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('⌁', style: TextStyle(color: AppColors.green, fontSize: 16)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Activity', style: TextStyle(color: AppColors.ink, fontSize: 12)),
                        SizedBox(height: 4),
                        Text(
                          'Minimal outcomes, nothing more',
                          style: TextStyle(color: AppColors.muted, fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                  const Text('›', style: TextStyle(color: AppColors.faint, fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap, this.fontSize = 22});

  final String icon;
  final VoidCallback onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 35,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.025),
          border: Border.all(color: AppColors.line),
        ),
        child: Text(icon, style: TextStyle(color: AppColors.ink, fontSize: fontSize)),
      ),
    );
  }
}
