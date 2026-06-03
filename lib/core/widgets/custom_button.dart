import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  final bool hasGlow;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.hasGlow = false,
    this.borderRadius = 26.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.white,
        elevation: 0, // We use custom boxShadow if hasGlow is true
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 1.5)
              : BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return Container(
      width: double.infinity,
      height: 48,
      decoration: hasGlow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withAlpha(200), // Strong white/cyan glow
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 0),
                ),
                BoxShadow(
                  color: Colors.white.withAlpha(150), // Inner denser glow
                  blurRadius: 10,
                  spreadRadius: -2,
                  offset: const Offset(0, 0),
                )
              ],
            )
          : null,
      child: button,
    );
  }
}
