import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/pill_button.dart';
import '../../core/widgets/role_picker.dart';
import '../../data/local/seed_data.dart';
import '../../data/remote/api_exception.dart';

typedef PersonFormSubmit = Future<void> Function({
  required String name,
  required String role,
  required String phone,
  required String language,
  String? note,
});

/// Ports `.person-form`: the "Add to My People" sheet, opened from the My
/// People screen. Submitting hits `/add_members` for real — the sheet
/// stays open with an inline error on failure instead of always closing.
class PersonFormSheet extends StatefulWidget {
  const PersonFormSheet({
    super.key,
    this.prefillName,
    required this.onSubmit,
  });

  final String? prefillName;
  final PersonFormSubmit onSubmit;

  @override
  State<PersonFormSheet> createState() => _PersonFormSheetState();
}

class _PersonFormSheetState extends State<PersonFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.prefillName ?? '');
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  String _role = SeedData.personRoles.first;
  String _language = SeedData.languages.first;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await widget.onSubmit(
        name: _nameController.text,
        role: _role,
        phone: _phoneController.text,
        language: _language,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.prefillName?.isNotEmpty == true ? widget.prefillName! : 'someone';
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'NOT IN MY PEOPLE',
            style: TextStyle(color: Color(0xFFB7E8CA), fontSize: 8, letterSpacing: 1),
          ),
          const SizedBox(height: 6),
          Text(
            'Add $displayName',
            style: const TextStyle(fontFamily: 'serif', color: Color(0xFFF5F3EE), fontSize: 28),
          ),
          const SizedBox(height: 7),
          const Text(
            'Add them once, then Aaraam can handle future calls.',
            style: TextStyle(color: Color(0xFF969B98), fontSize: 11),
          ),
          const SizedBox(height: 20),
          RolePicker(value: _role, onChanged: (v) => setState(() => _role = v)),
          AppTextField(
            label: 'Name',
            controller: _nameController,
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
          AppTextField(
            label: 'Optional note',
            controller: _noteController,
            hintText: 'Usual hours, pronunciation…',
          ),
          if (_error != null) ...[
            const SizedBox(height: 4),
            Text(_error!, style: const TextStyle(color: AppColors.errorSoft, fontSize: 9)),
          ],
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PillButton(
                label: 'Cancel',
                variant: PillButtonVariant.ghost,
                expand: false,
                onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 9),
              PillButton(
                label: _isSubmitting ? 'Adding…' : 'Add to My People',
                variant: PillButtonVariant.accent,
                expand: false,
                onPressed: _isSubmitting ? null : _submit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
