import 'package:flutter/widgets.dart';

Widget buildAdminTitleSection() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      children: [
        Text(
          'Management System',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: Color(0xFF1F2937),
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Center For Advance Studies',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3B82F6),
            letterSpacing: 0.2,
          ),
        ),
      ],
    ),
  );
}
