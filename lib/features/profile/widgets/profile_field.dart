import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';


class ProfileField extends StatelessWidget {
  const ProfileField({
    super.key,
    required this.label,
    this.value      = '',
    this.isPassword = false,
    this.readOnly   = true,
    this.controller,
  });

  final String                 label;
  final String                 value;
  final bool                   isPassword;
  final bool                   readOnly;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller ?? TextEditingController(text: value),
          readOnly:    readOnly,
          obscureText: isPassword,
          style: AppTextStyles.fieldValue,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled:    true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}