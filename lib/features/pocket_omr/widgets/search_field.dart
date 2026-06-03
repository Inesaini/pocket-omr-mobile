import 'package:flutter/material.dart';

import '../theme/pocket_colors.dart';

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;

  const SearchField({super.key, this.hint = 'Search exam', this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: PocketColors.navy, width: 1.2),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: PocketColors.navy),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: PocketColors.lightBlue),
          hintText: hint,
          hintStyle: const TextStyle(
            color: PocketColors.muted,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
