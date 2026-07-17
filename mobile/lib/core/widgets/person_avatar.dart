import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ports `.person-avatar`: a circular gradient chip showing initials.
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({super.key, required this.initials, this.size = 40});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF27342E), Color(0xFF171D1A)],
        ),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.green,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.26,
        ),
      ),
    );
  }
}
