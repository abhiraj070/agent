import 'package:flutter/material.dart';

import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/pill_button.dart';
import '../../core/widgets/role_picker.dart';
import '../../data/local/seed_data.dart';

typedef PersonFormSubmit = void Function({
  required String name,
  required String role,
  required String phone,
  required String language,
  String? note,
});

/// Ports `.person-form`: the "Add to My People" sheet, reused both from the
/// My People screen and from the task flow's "I don't have X yet" prompt.
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      name: _nameController.text,
      role: _role,
      phone: _phoneController.text,
      language: _language,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );
    Navigator.of(context).pop();
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
          const SizedBox(height: 4),
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
                label: 'Add to My People',
                variant: PillButtonVariant.accent,
                expand: false,
                onPressed: _submit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
