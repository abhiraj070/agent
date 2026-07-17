import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../core/widgets/role_picker.dart';
import '../../../data/local/seed_data.dart';

typedef SubmitFirstPerson = Future<void> Function({
  required String name,
  required String role,
  required String phone,
  required String language,
});

/// Step 3 — ports the first-person form (role picker + name/language/phone).
/// Submitting hits `/add_members` for real, so this surfaces a loading
/// state and inline error rather than always advancing.
class AddPersonStep extends StatefulWidget {
  const AddPersonStep({
    super.key,
    required this.hasExistingPending,
    required this.isSubmitting,
    required this.errorMessage,
    required this.onBack,
    required this.onSubmit,
  });

  final bool hasExistingPending;
  final bool isSubmitting;
  final String? errorMessage;
  final VoidCallback onBack;
  final SubmitFirstPerson onSubmit;

  @override
  State<AddPersonStep> createState() => _AddPersonStepState();
}

class _AddPersonStepState extends State<AddPersonStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _role = SeedData.personRoles.first;
  String _language = SeedData.languages.first;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      name: _nameController.text,
      role: _role,
      phone: _phoneController.text,
      language: _language,
    );
  }

  @override
  Widget build(BuildContext context) {
    final eyebrow = widget.hasExistingPending ? 'ADD ANOTHER PERSON' : 'YOUR TRUSTED CIRCLE BEGINS';
    final headline = widget.hasExistingPending
        ? 'Who else should\nAaraam know?'
        : 'Who helps make\nlife easier?';
    final body = widget.hasExistingPending
        ? 'Add the next person you often need to reach.'
        : 'Start with the role you rely on most.';

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(eyebrow, style: AppTextStyles.eyebrow),
          const SizedBox(height: 13),
          Text(headline, style: AppTextStyles.headline.copyWith(fontSize: 34)),
          const SizedBox(height: 15),
          Text(body, style: AppTextStyles.subline),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RolePicker(value: _role, onChanged: (v) => setState(() => _role = v)),
                  AppTextField(
                    label: 'Name',
                    controller: _nameController,
                    hintText: 'Anil ji',
                    autofocus: true,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  AppDropdownField(
                    label: 'Preferred language',
                    value: _language,
                    options: SeedData.languages,
                    onChanged: (v) => setState(() => _language = v),
                  ),
                  AppTextField(
                    label: 'Phone number',
                    controller: _phoneController,
                    hintText: '+91 98765 43210',
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          if (widget.errorMessage != null) ...[
            Text(
              widget.errorMessage!,
              style: const TextStyle(color: AppColors.errorSoft, fontSize: 9),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              PillButton(label: 'Back', variant: PillButtonVariant.ghost, expand: false, onPressed: widget.onBack),
              const SizedBox(width: 9),
              Expanded(
                child: PillButton(
                  label: widget.isSubmitting ? 'Adding…' : 'Meet Aaraam',
                  onPressed: widget.isSubmitting ? null : _submit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
