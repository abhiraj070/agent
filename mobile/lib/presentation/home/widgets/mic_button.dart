import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/orbit_visual.dart';

/// Ports `.mic-button`: a glowing circular tap target with two orbit rings.
class MicButton extends StatelessWidget {
  const MicButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: OrbitVisual(
        size: 102,
        showGlow: true,
        rings: const [
          OrbitRing(sizeFactor: 0.78, opacity: 0.09, rotationSeconds: 30),
          OrbitRing(sizeFactor: 1.0, opacity: 0.09, rotationSeconds: 18, dashed: true),
        ],
        center: Container(
          width: 102,
          height: 102,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.green.withOpacity(0.32)),
            gradient: RadialGradient(
              colors: [
                AppColors.green.withOpacity(0.2),
                AppColors.green.withOpacity(0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
          child: const _MicIcon(),
        ),
      ),
    );
  }
}

class _MicIcon extends StatelessWidget {
  const _MicIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(31, 42),
      painter: _MicIconPainter(),
    );
  }
}

class _MicIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final capsule = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(size.width / 2, size.height * 0.33), width: 15, height: 22),
      const Radius.circular(8),
    );
    canvas.drawRRect(capsule, paint);

    final arcRect = Rect.fromCenter(center: Offset(size.width / 2, size.height * 0.52), width: 24, height: 20);
    canvas.drawArc(arcRect, 0.15, 2.85, false, paint);

    canvas.drawLine(
      Offset(size.width / 2, size.height * 0.72),
      Offset(size.width / 2, size.height * 0.95),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
