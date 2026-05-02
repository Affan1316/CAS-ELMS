import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  // ── LOGIC UNCHANGED: same constructor signature ───────────────────────────
  final bool isLoading;
  final VoidCallback onPressed;

  const SignUpButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: isLoading ? const Color(0xFF555555) : const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child:
              isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white54,
                    ),
                  )
                  : const Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
        ),
      ),
    );
  }
}
