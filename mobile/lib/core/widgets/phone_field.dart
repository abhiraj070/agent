import 'package:flutter/material.dart';

import '../../domain/entities/country.dart';
import '../theme/app_colors.dart';
import 'bottom_sheet_shell.dart';
import 'country_picker_sheet.dart';

/// "Phone number" field with a tappable country chip, shared by every
/// add-person entry point (onboarding's `AddPersonStep` and the People
/// screen's `PersonFormSheet`) so a phone number is always composed as
/// dial code + local digits, the same way the account's own OTP phone
/// field works, instead of one free-text field per place that needs it.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.country,
    required this.controller,
    required this.onCountryChanged,
  });

  final Country country;
  final TextEditingController controller;
  final ValueChanged<Country> onCountryChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Phone number', style: TextStyle(color: AppColors.muted, fontSize: 9)),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => BottomSheetShell.show(
                  context,
                  child: CountryPickerSheet(onSelect: onCountryChanged),
                ),
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E1210),
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${country.isoCode} ${country.dialCode}',
                        style: const TextStyle(color: AppColors.ink, fontSize: 11),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: AppColors.muted, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: AppColors.ink, fontSize: 11),
                    validator: (v) => (v == null || v.trim().length < 6) ? 'Required' : null,
                    decoration: InputDecoration(
                      hintText: '98765 43210',
                      hintStyle: const TextStyle(color: AppColors.faint, fontSize: 11),
                      filled: true,
                      fillColor: const Color(0xFF0E1210),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
