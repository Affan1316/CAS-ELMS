import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';

class AIFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AIFloatingButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      elevation: 8,
      backgroundColor: Colors.transparent,
      shape: const CircleBorder(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0E96C5), // Primary
              Color(0xFF39B3D7), // Lighter blend
              Color(0xFF82D8E8), // Aqua
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            )
          ],
        ),
        child:  Center(
          child: Icon(
            Icons.message, // AI-like icon (robot head)
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
