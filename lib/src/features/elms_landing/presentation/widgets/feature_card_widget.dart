import 'package:flutter/material.dart';

class FeatureCardWidget extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final  IconData icon;
  const FeatureCardWidget({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.42,
      height: height * 0.12,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF0E96C5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [Icon(icon)]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [FittedBox(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold),))]),
        ],
      ),
    );
  }
}
