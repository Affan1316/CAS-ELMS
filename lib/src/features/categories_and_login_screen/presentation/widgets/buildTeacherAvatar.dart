import 'package:flutter/material.dart';

Widget buildTeacherAvatar() {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Use the available space efficiently
      final size =
          constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;

      return Container(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            // Changed from Image.network to Image.asset
            'assets/images/teacher.png',
            width: size * 0.9,
            height: size * 0.9,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.school,
                size: size * 0.8,
                color: Colors.teal.shade600,
              );
            },
          ),
        ),
      );
    },
  );
}
