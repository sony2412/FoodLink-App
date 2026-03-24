import 'package:flutter/material.dart';

class FormDivider extends StatelessWidget {
  const FormDivider({super.key, required this.dividerText});

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
            thickness: 0.5,
            endIndent: 8,
          ),
        ),
        Text(
          dividerText,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: const Color(0xFF5DCAA5),
          ),
        ),
        Flexible(
          child: Divider(
            color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
            thickness: 0.5,
            indent: 8,
          ),
        ),
      ],
    );
  }
}
