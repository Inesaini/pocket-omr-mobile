import 'package:flutter/material.dart';

import '../theme/pocket_colors.dart';

class ScreenTitle extends StatelessWidget {
  final String text;
  const ScreenTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    final first = text[0];
    final rest = text.substring(1);
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: PocketColors.navy,
          height: 1.1,
        ),
        children: [
          TextSpan(
            text: first,
            style: const TextStyle(color: PocketColors.lightBlue),
          ),
          TextSpan(text: rest),
        ],
      ),
    );
  }
}
