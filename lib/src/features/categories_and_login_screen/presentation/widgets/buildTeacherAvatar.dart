import 'package:flutter/material.dart';

Widget buildTeacherAvatar() {
  return Container(
    width: 80,
    height: 80,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        'assets/images/teacher.png',
        width: 50,
        height: 50,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.school, size: 40, color: Colors.teal.shade600);
        },
      ),
    ),
  );
}
