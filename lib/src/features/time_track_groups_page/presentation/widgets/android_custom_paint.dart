import 'dart:math' as math;

import 'package:flutter/material.dart';

class SvgIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Calculate scaling factors to maintain aspect ratio
    final double scale = math.min(size.width / 48, size.height / 48);
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Apply transformation to center the drawing
    canvas.save();
    canvas.translate(centerX - (24 * scale), centerY - (24 * scale));
    canvas.scale(scale, scale);

    // Define paints with original colors
    final Paint greenLight = Paint()..color = const Color(0xFF00c853);
    final Paint greenDark = Paint()..color = const Color(0xFF00e676);
    final Paint cloudLight = Paint()..color = const Color(0xFFc2eafd);
    final Paint cloudMedium = Paint()..color = const Color(0xFF9addfb);
    final Paint shadow = Paint()..color = const Color(0xFF37474f);

    // Draw first path (green dome)
    final Path path1 = Path();
    path1.moveTo(4, 23);
    path1.cubicTo(4, 11.954, 12.954, 3, 24, 3);
    path1.cubicTo(35.046, 3, 44, 11.954, 44, 23);
    path1.lineTo(24, 25);
    path1.lineTo(4, 23);
    path1.close();
    canvas.drawPath(path1, greenLight);

    // Draw second path (green base)
    final Path path2 = Path();
    path2.moveTo(44, 23);
    path2.cubicTo(44, 34.046, 35.046, 43, 24, 43);
    path2.cubicTo(12.954, 43, 4, 34.046, 4, 23);
    path2.lineTo(44, 23);
    path2.close();
    canvas.drawPath(path2, greenDark);

    // Draw third path (cloud part)
    final Path path3 = Path();
    path3.moveTo(39.29, 42.34);
    path3.lineTo(39.29, 45.5); // v3.16
    path3.cubicTo(39.29, 45.69, 39.19, 45.85, 39.04, 45.93);
    path3.cubicTo(38.9, 46.02, 38.71, 46.03, 38.54, 45.93);
    path3.lineTo(35.82, 44.34); // l-2.72-1.59
    path3.lineTo(31.14, 36.19); // l-4.68-8.15
    path3.lineTo(29.14, 32.72); // l-2-3.47
    path3.lineTo(25.39, 26.2); // l-3.75-6.52
    path3.lineTo(28.32, 23.27); // l2.93-2.93
    path3.lineTo(32.31, 30.21); // l3.99,6.94
    path3.lineTo(34.38, 33.81); // l2.07,3.6
    path3.lineTo(39.29, 42.34); // L39.29,42.34
    path3.close();
    canvas.drawPath(path3, cloudLight);

    // Draw fourth path (cloud highlight)
    final Path path4 = Path();
    path4.moveTo(31.231, 28.335);
    path4.cubicTo(30.417, 29.436, 29.362, 30.346, 28.139, 30.983);
    path4.lineTo(32.13, 37.924); // l3.991,6.941
    path4.cubicTo(33.315, 37.276, 34.402, 36.478, 35.395, 35.578);
    path4.lineTo(31.231, 28.335);
    path4.close();
    canvas.drawPath(path4, cloudMedium);

    // Draw fifth path (cloud continuation)
    final Path path5 = Path();
    path5.moveTo(39, 23);
    path5.cubicTo(39, 27.24, 37.23, 31.08, 34.38, 33.81);
    path5.cubicTo(33.42, 34.74, 32.33, 35.54, 31.14, 36.19);
    path5.cubicTo(29.02, 37.34, 26.59, 38, 24, 38);
    path5.cubicTo(21.47, 38, 19.04, 37.38, 16.86, 36.19);
    path5.lineTo(12.18, 44.34); // l-4.68,8.15
    path5.lineTo(9.46, 45.93); // l-2.72,1.59
    path5.cubicTo(9.29, 46.03, 9.1, 46.02, 8.96, 45.93);
    path5.cubicTo(8.81, 45.85, 8.71, 45.69, 8.71, 45.5);
    path5.lineTo(8.71, 42.34); // v-3.16
    path5.lineTo(19.68, 23.27); // l10.97-19.07
    path5.lineTo(22.61, 26.2); // l2.93,2.93
    path5.lineTo(18.86, 32.73); // l-3.75,6.53
    path5.cubicTo(20.43, 33.56, 22.18, 34, 24, 34);
    path5.cubicTo(25.86, 34, 27.61, 33.54, 29.14, 32.72);
    path5.cubicTo(30.35, 32.09, 31.42, 31.23, 32.31, 30.21);
    path5.cubicTo(33.99, 28.27, 35, 25.76, 35, 23);
    path5.lineTo(39, 23);
    path5.close();
    canvas.drawPath(path5, cloudLight);

    // Draw sixth path (shadow and details)
    final Path path6 = Path();
    path6.moveTo(28.5, 13);
    path6.lineTo(26, 13); // H26
    path6.lineTo(26, 10); // v-3
    path6.lineTo(22, 10); // h-4
    path6.lineTo(22, 13); // v3
    path6.lineTo(19.5, 13); // h-2.5
    path6.cubicTo(18.672, 13, 18, 13.672, 18, 14.5);
    path6.lineTo(18, 23); // V23
    path6.lineTo(22.932, 27.932); // l4.932,4.932
    path6.cubicTo(23.522, 28.522, 24.478, 28.522, 25.068, 27.932);
    path6.lineTo(30, 23); // L30,23
    path6.lineTo(30, 14.5); // v-8.5
    path6.cubicTo(30, 13.672, 29.328, 13, 28.5, 13);
    path6.close();

    path6.moveTo(24, 22);
    path6.cubicTo(22.619, 22, 21.5, 20.881, 21.5, 19.5);
    path6.cubicTo(21.5, 18.119, 22.619, 17, 24, 17);
    path6.cubicTo(25.381, 17, 26.5, 18.119, 26.5, 19.5);
    path6.cubicTo(26.5, 20.881, 25.381, 22, 24, 22);
    path6.close();

    canvas.drawPath(path6, shadow);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class AndroidLogo extends StatelessWidget {
  const AndroidLogo({super.key, this.size = 48});
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: SvgIconPainter());
  }
}
