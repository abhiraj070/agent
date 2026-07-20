import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../../data/local/country_codes.dart';
import '../../domain/entities/country.dart';

/// Searchable country/dial-code list — shared by every phone-entry field
/// that composes a number as dial code + local digits (account setup's
/// [PhoneEntryStep] and [PhoneField]).
class CountryPickerSheet extends StatefulWidget {
  const CountryPickerSheet({super.key, required this.onSelect});

  final ValueChanged<Country> onSelect;

  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final results = query.isEmpty
        ? CountryCodes.all
        : CountryCodes.all
            .where((country) =>
                country.name.toLowerCase().contains(query) ||
                country.dialCode.contains(query))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'CHOOSE A COUNTRY',
          style: TextStyle(color: AppColors.green, fontSize: 8, letterSpacing: 1),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (value) => setState(() => _query = value),
          style: const TextStyle(color: AppColors.ink, fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Search country',
            hintStyle: const TextStyle(color: AppColors.faint),
            prefixIcon: const Icon(Icons.search, color: AppColors.faint, size: 18),
            filled: true,
            fillColor: const Color(0xFF0E1210),
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
        const SizedBox(height: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 360),
          child: results.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No matching country.',
                    style: TextStyle(color: AppColors.faint, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: results.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.line),
                  itemBuilder: (context, index) {
                    final country = results[index];
                    return InkWell(
                      onTap: () {
                        widget.onSelect(country);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(country.name, style: const TextStyle(color: AppColors.ink, fontSize: 12)),
                            Text(country.dialCode, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
