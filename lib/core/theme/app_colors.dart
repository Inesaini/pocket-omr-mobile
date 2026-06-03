import 'package:flutter/material.dart';

class AppColors {
  // Brand Blues
  static const Color primaryBlue = Color(0xFF1EA1EE);
  static const Color deepBlue = Color(0xFF003E75);
  static const Color buttonDark = Color(0xFF003E75);

  // Background Gradients
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF009EE8), // Vibrant cyan-blue at top
      Color(0xFF69B6DD), // Softer blue at bottom
    ],
    stops: [0.0, 1.0],
  );

  static const Gradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFEAF5FA), // Very light airy blue top
      Color(0xFFF6FBFE), // Almost white bottom
    ],
  );
}
