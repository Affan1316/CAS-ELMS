import 'package:flutter/material.dart';

Widget buildStudentAvatar() {
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
            'assets/images/student-male.png',
            width: size * 0.9,
            height: size * 0.9,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.person,
                size: size * 0.8,
                color: Colors.blue.shade600,
              );
            },
          ),
        ),
      );
    },
  );
}
