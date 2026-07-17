import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Ports `.toast`: a floating pill notification near the bottom of the
/// screen, auto-dismissing after [AppDurations.toast].
class AppToast {
  const AppToast._();

  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        onDone: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({required this.message, required this.onDone});

  final String message;
  final VoidCallback onDone;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(AppDurations.toast, () {
      if (mounted) widget.onDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 33,
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFF1A211E),
              border: Border.all(color: AppColors.green.withOpacity(0.18)),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 35,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Text(
              widget.message,
              style: const TextStyle(color: AppColors.green, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
