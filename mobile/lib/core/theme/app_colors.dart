import 'package:flutter/material.dart';

/// Ports the CSS custom properties from UI_design/app/globals.css.
class AppColors {
  const AppColors._();

  static const Color ink = Color(0xFFF5F3EE);
  static const Color muted = Color(0xFF969B98);
  static const Color faint = Color(0xFF656A68);
  static const Color green = Color(0xFFB7E8CA);
  static const Color greenStrong = Color(0xFF64D69A);
  static const Color surface = Color(0xFF0B0E0D);
  static const Color surface2 = Color(0xFF111514);
  static const Color backdrop = Color(0xFF080A09);

  static const Color line = Color(0x1AE7EFEB); // rgba(231,239,235,.1)
  static const Color soft = Color(0x14B7E8CA); // rgba(183,232,202,.08)

  static const Color ambientOne = Color(0xFF317D56);
  static const Color ambientTwo = Color(0xFF514D2B);

  static const RadialGradient stageBackground = RadialGradient(
    center: Alignment(0, -0.7),
    radius: 1.2,
    colors: [Color(0xFF17201B), Color(0xFF0A0C0B), Color(0xFF060706)],
    stops: [0.0, 0.38, 1.0],
  );

  static const LinearGradient phoneShellBackground = LinearGradient(
    begin: Alignment(-0.6, -1),
    end: Alignment(0.6, 1),
    colors: [Color(0xFF111513), Color(0xFF090C0B), Color(0xFF080A09)],
    stops: [0.0, 0.46, 1.0],
  );
}
