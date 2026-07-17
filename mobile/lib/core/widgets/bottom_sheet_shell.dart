import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Ports `.bottom-sheet`: a rounded-top sheet with a drag handle, opened via
/// [show].
class BottomSheetShell extends StatelessWidget {
  const BottomSheetShell({super.key, required this.child});

  final Widget child;

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetShell(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.86,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141817),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.sheet),
            ),
            border: Border(
              top: BorderSide(color: Colors.white12),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(23, 12, 23, 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 35,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      color: const Color(0xFF464C49),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
