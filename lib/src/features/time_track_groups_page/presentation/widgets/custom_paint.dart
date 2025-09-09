import 'package:flutter/material.dart';

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Line to top-right
    path.lineTo(size.width, 0);

    // Line down some % of height
    path.lineTo(size.width, size.height * 0.6);

    // Curve to left
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height*1.3, // control point
      0,
      size.height * 0.6, // end point
    );

    // Close
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
