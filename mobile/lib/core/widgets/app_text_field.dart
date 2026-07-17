import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ports the shared `input`/`select`/`textarea` styling used across
/// `.person-form`, `.onboarding-fields` and the composer sheet.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.autofocus = false,
    this.initialValue,
    this.validator,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool autofocus;
  final String? initialValue;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 9)),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          keyboardType: keyboardType,
          maxLines: maxLines,
          autofocus: autofocus,
          validator: validator,
          style: const TextStyle(color: AppColors.ink, fontSize: 11),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.faint, fontSize: 11),
            filled: true,
            fillColor: const Color(0xFF0E1210),
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide(color: AppColors.green.withOpacity(0.4)),
            ),
          ),
        ),
        const SizedBox(height: 13),
      ],
    );
  }
}

/// Ports the `select` used for "Preferred language".
class AppDropdownField extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 9)),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0E1210),
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(11),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF0E1210),
              style: const TextStyle(color: AppColors.ink, fontSize: 11),
              items: options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
        const SizedBox(height: 13),
      ],
    );
  }
}
