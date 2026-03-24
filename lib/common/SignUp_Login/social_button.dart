import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
          border: Border.all(
            color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: FaIcon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}
