import 'package:flutter/material.dart';

class FeatureCardWidget extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final IconData icon;
  final GestureTapCallback ontap;

  const FeatureCardWidget({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
    required this.title,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: width * 0.42,
        height: height * 0.15,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white, // Light background
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFA3B1C6), // Darker shadow bottom right
              offset: Offset(6, 6),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.white, // Lighter shadow top left
              offset: Offset(-6, -6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.black54),
            FittedBox(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
