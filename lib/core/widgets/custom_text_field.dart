import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool withBorder;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.withBorder = false, // used in ForgotPassword
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  static const Color _deepBlue = Color(0xFF003E75);

  late bool _obscure = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: widget.withBorder
            ? Border.all(color: _deepBlue, width: 1.2)
            : null,
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          style: const TextStyle(
            color: _deepBlue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: _deepBlue.withAlpha(150),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(widget.prefixIcon,
                        color: _deepBlue, size: 22),
                  )
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 40, minHeight: 48),
            suffixIcon: widget.isPassword
                ? IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _deepBlue,
                      size: 22,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                  )
                : null,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 40, minHeight: 48),
            border: InputBorder.none,
            contentPadding: widget.prefixIcon != null
                ? const EdgeInsets.symmetric(vertical: 14)
                : const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ),
    );
  }
}
