import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/pill_button.dart';

/// Ports the `.composer` bottom sheet — "or type instead" fallback for the
/// mic input.
class ComposerSheet extends StatefulWidget {
  const ComposerSheet({super.key, required this.onSubmit});

  final ValueChanged<String> onSubmit;

  @override
  State<ComposerSheet> createState() => _ComposerSheetState();
}

class _ComposerSheetState extends State<ComposerSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSubmit(text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'What can I take care of?',
          style: TextStyle(fontFamily: 'serif', color: AppColors.ink, fontSize: 25),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          autofocus: true,
          minLines: 5,
          maxLines: 7,
          style: const TextStyle(color: AppColors.ink, fontSize: 13, height: 1.5),
          decoration: InputDecoration(
            hintText: 'Ask Anil ji to meet me at the main gate in 5 minutes…',
            hintStyle: const TextStyle(color: AppColors.faint),
            filled: true,
            fillColor: Colors.white.withOpacity(0.025),
            contentPadding: const EdgeInsets.all(15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.green.withOpacity(0.45)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PillButton(
              label: 'Cancel',
              variant: PillButtonVariant.ghost,
              expand: false,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 9),
            PillButton(
              label: 'Take care of it',
              variant: PillButtonVariant.accent,
              expand: false,
              onPressed: _submit,
            ),
          ],
        ),
      ],
    );
  }
}
