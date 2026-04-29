// Data Models

import 'package:flutter/material.dart';

class NeuCard extends StatelessWidget {
  final Widget child;
  const NeuCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 0.5,
        ),
        boxShadow: [
          // Main soft shadow
          BoxShadow(
            color: const Color(0xFF5D5FEF).withOpacity(0.06),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: -4,
          ),
          // Sharp outer shadow for definition
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: child,
    );
  }
}
