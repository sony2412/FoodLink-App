import 'package:flutter/material.dart';

class FPrimaryButton extends StatelessWidget {
  const FPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 52.0,
    this.borderRadius = 12.0,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: isLoading
                ? null
                : const LinearGradient(
              colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            color: isLoading
                ? const Color(0xFFEF9F27).withValues(alpha: 0.5)
                : null,
            boxShadow: isLoading
                ? null
                : [
              BoxShadow(
                color: const Color(0xFFEF9F27).withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}