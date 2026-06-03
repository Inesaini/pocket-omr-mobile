import 'package:flutter/material.dart';

class PocketColors {
  PocketColors._();

  static const navy = Color(0xFF1A2F5A);
  static const accentBlue = Color(0xFF0066CC);
  static const lightBlue = Color(0xFF1EA1EE);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const danger = Color(0xFFF44336);
  static const stopRed = Color(0xFFFF6B5B);

  static const cardBorder = Color(0xFFB5DDF5);
  static const muted = Color(0xFF6B7B95);

  static const Gradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8F4FD), Color(0xFFFFFFFF)],
  );

  static Color confidenceColor(double pct) {
    if (pct >= 80) return success;
    if (pct >= 50) return warning;
    return danger;
  }

  static Color scoreColor(double ratio) {
    if (ratio >= 0.7) return success;
    if (ratio >= 0.4) return warning;
    return danger;
  }
}
