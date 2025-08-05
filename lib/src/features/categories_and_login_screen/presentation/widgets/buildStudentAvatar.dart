import 'package:flutter/material.dart';

Widget buildStudentAvatar() {
  return Container(
    width: 80,
    height: 80,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/images/student-male.png',
        width: 50,
        height: 50,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: 40, color: Colors.blue.shade600);
        },
      ),
    ),
  );
}
