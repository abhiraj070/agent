import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Ports `.launch-splash`: a breathing brand mark shown while the app
/// decides whether to route into onboarding or straight to home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.stageBackground),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scale,
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.soft,
                  border: Border.all(color: AppColors.green.withOpacity(0.28)),
                ),
                child: const Text(
                  'अ',
                  style: TextStyle(color: AppColors.green, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 11),
            const Text(
              'Aaraam',
              style: TextStyle(
                fontFamily: 'serif',
                color: AppColors.ink,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
