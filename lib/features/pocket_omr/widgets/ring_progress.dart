import 'package:flutter/material.dart';

import '../theme/pocket_colors.dart';

class RingProgress extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final double stroke;
  final Widget child;

  const RingProgress({
    super.key,
    required this.progress,
    required this.child,
    this.color = PocketColors.lightBlue,
    this.size = 56,
    this.stroke = 3,
  });

  @override
  Widget build(BuildContext context) {
    // Guard against NaN/Infinity (e.g. 0/0) which crashes the indicator.
    final value = progress.isFinite ? progress.clamp(0.0, 1.0) : 0.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: stroke,
              backgroundColor: color.withOpacity(0.18),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
