import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key, this.onTap, required this.studentName});
  final VoidCallback? onTap;
  final String studentName;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF3D4C5F)),
          onPressed: () {},
        ),
        SizedBox(width: 10),
        Text(
          '$studentName\'s WorkShop Time',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3D4C5F),
          ),
        ),
      ],
    );
  }
}
