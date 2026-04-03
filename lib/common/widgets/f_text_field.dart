import 'package:flutter/material.dart';

class FTextField extends StatelessWidget {
  const FTextField({
    super.key,
    this.controller,
    required this.label,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String label;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      style: const TextStyle(color: Color(0xFFE8FBF4), fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF5DCAA5), size: 20),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 13),
        floatingLabelStyle: const TextStyle(color: Color(0xFF9FE1CB)),
        filled: true,
        fillColor: const Color(0xFF0F6E56).withValues(alpha: 0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5DCAA5), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
    );
  }
}
