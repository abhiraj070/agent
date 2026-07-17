import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// One decorative ring in an [OrbitVisual].
class OrbitRing {
  const OrbitRing({
    required this.sizeFactor,
    this.opacity = 0.15,
    this.rotationSeconds = 24,
    this.reverse = false,
    this.strokeWidth = 1,
    this.dashed = false,
  });

  /// Diameter as a fraction of the visual's overall [OrbitVisual.size].
  final double sizeFactor;
  final double opacity;
  final double rotationSeconds;
  final bool reverse;
  final double strokeWidth;
  final bool dashed;
}

/// Reusable ambient animation: a breathing glow, slowly rotating rings, and
/// an optional center child. Ports the shared visual language behind
/// `.mic-button`/`.orbit`, `.welcome-visual`, `.intelligence-field` and
/// `.first-task-visual` in globals.css — all of which are variations of the
/// same "glow + orbiting rings + core" motif.
class OrbitVisual extends StatefulWidget {
  const OrbitVisual({
    super.key,
    required this.size,
    this.rings = const [],
    this.center,
    this.showGlow = true,
    this.orbitingDotCount = 0,
    this.glowColor = AppColors.greenStrong,
  });

  final double size;
  final List<OrbitRing> rings;
  final Widget? center;
  final bool showGlow;
  final int orbitingDotCount;
  final Color glowColor;

  @override
  State<OrbitVisual> createState() => _OrbitVisualState();
}

class _OrbitVisualState extends State<OrbitVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final elapsedSeconds = _controller.value * 60;
          final breathe =
              0.9 + 0.15 * math.sin(elapsedSeconds / 7 * 2 * math.pi);
          return Stack(
            alignment: Alignment.center,
            children: [
              if (widget.showGlow)
                Transform.scale(
                  scale: breathe,
                  child: Container(
                    width: widget.size * 0.62,
                    height: widget.size * 0.62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.glowColor.withOpacity(0.16),
                          widget.glowColor.withOpacity(0.02),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ),
              for (final ring in widget.rings)
                Transform.rotate(
                  angle: (ring.reverse ? -1 : 1) *
                      2 *
                      math.pi *
                      (elapsedSeconds / ring.rotationSeconds),
                  child: Container(
                    width: widget.size * ring.sizeFactor,
                    height: widget.size * ring.sizeFactor,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.green.withOpacity(ring.opacity),
                        width: ring.strokeWidth,
                      ),
                    ),
                  ),
                ),
              for (var i = 0; i < widget.orbitingDotCount; i++)
                _OrbitingDot(
                  radius: widget.size * (0.16 + i * 0.09),
                  angle: 2 *
                      math.pi *
                      (elapsedSeconds / (12 + i * 7)) *
                      (i.isOdd ? -1 : 1),
                  opacity: 0.8 - i * 0.2,
                ),
              if (widget.center != null) widget.center!,
            ],
          );
        },
      ),
    );
  }
}

class _OrbitingDot extends StatelessWidget {
  const _OrbitingDot({
    required this.radius,
    required this.angle,
    required this.opacity,
  });

  final double radius;
  final double angle;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final dx = radius * math.cos(angle);
    final dy = radius * math.sin(angle);
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.green.withOpacity(opacity),
          boxShadow: [
            BoxShadow(
              color: AppColors.green.withOpacity(opacity * 0.6),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
