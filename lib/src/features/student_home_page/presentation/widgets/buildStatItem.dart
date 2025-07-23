import 'package:flutter/widgets.dart';

Widget buildStatItem(String label, String value, Color color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: const Color(0xFF64748B),
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
