import 'package:flutter/material.dart';

import '../theme/pocket_colors.dart';

class ConfidenceBar extends StatelessWidget {
  final double percent;
  final double width;
  final bool showLabel;

  const ConfidenceBar({
    super.key,
    required this.percent,
    this.width = 90,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = PocketColors.confidenceColor(percent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Text(
            '${percent.toStringAsFixed(0)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: width,
            height: 6,
            child: LinearProgressIndicator(
              value: percent.isFinite ? (percent / 100).clamp(0.0, 1.0) : 0.0,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
