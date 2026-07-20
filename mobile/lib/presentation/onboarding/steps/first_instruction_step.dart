import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/person_avatar.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../domain/entities/person.dart';

/// Step 4 — ports the first-instruction textarea handed to the newly added
/// person.
class FirstInstructionStep extends StatefulWidget {
  const FirstInstructionStep({
    super.key,
    required this.person,
    required this.instruction,
    required this.onInstructionChanged,
    required this.onSubmit,
    required this.onBack,
    required this.onAddAnother,
  });

  final Person person;
  final String instruction;
  final ValueChanged<String> onInstructionChanged;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final VoidCallback onAddAnother;

  @override
  State<FirstInstructionStep> createState() => _FirstInstructionStepState();
}

class _FirstInstructionStepState extends State<FirstInstructionStep> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.instruction);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Person get person => widget.person;
  String get instruction => widget.instruction;
  ValueChanged<String> get onInstructionChanged => widget.onInstructionChanged;
  VoidCallback get onSubmit => widget.onSubmit;
  VoidCallback get onBack => widget.onBack;
  VoidCallback get onAddAnother => widget.onAddAnother;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('YOUR FIRST HAND-OFF', style: AppTextStyles.eyebrow),
        const SizedBox(height: 13),
        Text('Give your first\ninstruction for ${person.name}.', style: AppTextStyles.headline.copyWith(fontSize: 32)),
        const SizedBox(height: 15),
        const Text(
          'Say it naturally. Aaraam will handle the call and bring back what matters.',
          style: AppTextStyles.subline,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.022),
            border: Border.all(color: AppColors.green.withOpacity(0.16)),
            borderRadius: BorderRadius.circular(19),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PersonAvatar(initials: person.initials, size: 32),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.role.toUpperCase(),
                        style: const TextStyle(color: AppColors.green, fontSize: 7, letterSpacing: 1),
                      ),
                      const SizedBox(height: 3),
                      Text(person.name, style: const TextStyle(color: AppColors.ink, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white12)),
                ),
                padding: const EdgeInsets.only(top: 15),
                child: TextField(
                  autofocus: true,
                  minLines: 4,
                  maxLines: 6,
                  onChanged: onInstructionChanged,
                  controller: _controller,
                  style: const TextStyle(fontFamily: 'serif', color: AppColors.ink, fontSize: 17, height: 1.45),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Ask ${person.name} to…',
                    hintStyle: const TextStyle(color: Color(0x8096A19B)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Speak or type—however it comes to mind',
                style: TextStyle(color: AppColors.faint, fontSize: 7),
              ),
            ],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            PillButton(label: 'Back', variant: PillButtonVariant.ghost, expand: false, onPressed: onBack),
            const SizedBox(width: 9),
            Expanded(
              child: PillButton(label: 'Take care of it', onPressed: onSubmit),
            ),
          ],
        ),
        Center(
          child: TextButton(
            onPressed: onAddAnother,
            child: const Text(
              'Add another contact or person instead',
              style: TextStyle(color: AppColors.faint, fontSize: 9),
            ),
          ),
        ),
      ],
    );
  }
}
