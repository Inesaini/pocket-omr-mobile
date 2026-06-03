import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  static const double defaultSize = 180;

  final double size;

  const LogoWidget({super.key, this.size = defaultSize});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
