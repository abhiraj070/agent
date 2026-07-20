import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/orbit_visual.dart';

/// Ports `.mic-button`: a glowing circular tap target with two orbit rings,
/// plus a soft press-in/release bounce and a slow outward "invitation to
/// speak" pulse so it reads as alive, not a static icon.
class MicButton extends StatefulWidget {
  const MicButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _pressController;
  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      reverseDuration: const Duration(milliseconds: 360),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    HapticFeedback.lightImpact();
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails _) => _pressController.reverse();
  void _handleTapCancel() => _pressController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pressScale,
        builder: (context, child) => Transform.scale(scale: _pressScale.value, child: child),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) => Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  for (final delay in const [0.0, 0.5])
                    _PulseRing(progress: (_pulseController.value + delay) % 1.0),
                ],
              ),
            ),
            OrbitVisual(
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
          ],
        ),
      ),
    );
  }
}

/// One ring of the slow outward pulse — grows and fades as [progress]
/// goes 0→1, looped and staggered by [_MicButtonState] so a new ring
/// always emerges as the previous one fades out.
class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final scale = 0.86 + progress * 0.35;
    final opacity = (1 - progress) * 0.3;
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 102,
        height: 102,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.green.withOpacity(opacity), width: 1.4),
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
