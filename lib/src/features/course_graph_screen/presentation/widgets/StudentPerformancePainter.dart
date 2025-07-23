import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class StudentPerformancePainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final double animationValue;

  StudentPerformancePainter({
    required this.data,
    required this.labels,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // Graph boundaries
    final padding = 40.0;
    final graphWidth = size.width - 2 * padding;
    final graphHeight = size.height - 2 * padding;

    // Find min and max values
    final minValue = data.reduce(math.min) - 10;
    final maxValue = data.reduce(math.max) + 10;
    final valueRange = maxValue - minValue;

    // Create gradient for line
    final gradient = LinearGradient(
      colors: [
        Color(0xFFFF6B6B),
        Color(0xFF4ECDC4),
        Color(0xFF45B7D1),
        Color(0xFF96CEB4),
      ],
      stops: [0.0, 0.3, 0.7, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    paint.shader = gradient;

    // Draw grid lines
    final gridPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..strokeWidth = 1;

    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = padding + (i * graphHeight / 4);
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        gridPaint,
      );
    }

    // Vertical grid lines
    for (int i = 0; i < data.length; i++) {
      final x = padding + (i * graphWidth / (data.length - 1));
      canvas.drawLine(
        Offset(x, padding),
        Offset(x, size.height - padding),
        gridPaint,
      );
    }

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = padding + (i * graphWidth / (data.length - 1));
      final y = padding + ((maxValue - data[i]) / valueRange) * graphHeight;
      points.add(Offset(x, y));
    }

    // Draw animated line
    if (animationValue > 0) {
      final path = Path();
      final animatedPointsCount = (points.length * animationValue).round();

      if (animatedPointsCount > 0) {
        path.moveTo(points[0].dx, points[0].dy);

        for (int i = 1; i < animatedPointsCount; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }

        // Draw partial line to current animation point
        if (animatedPointsCount < points.length) {
          final progress =
              (points.length * animationValue) - animatedPointsCount;
          final currentPoint = points[animatedPointsCount - 1];
          final nextPoint = points[animatedPointsCount];
          final animatedPoint = Offset(
            currentPoint.dx + (nextPoint.dx - currentPoint.dx) * progress,
            currentPoint.dy + (nextPoint.dy - currentPoint.dy) * progress,
          );
          path.lineTo(animatedPoint.dx, animatedPoint.dy);
        }

        canvas.drawPath(path, paint);

        // Draw glow effect
        final glowPaint =
            Paint()
              ..color = Color(0xFF4ECDC4).withOpacity(0.3)
              ..maskFilter = MaskFilter.blur(BlurStyle.outer, 8)
              ..strokeWidth = 6
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round;

        canvas.drawPath(path, glowPaint);

        // Draw fill area
        final fillPath = Path.from(path);
        fillPath.lineTo(
          points[math.min(animatedPointsCount - 1, points.length - 1)].dx,
          size.height - padding,
        );
        fillPath.lineTo(points[0].dx, size.height - padding);
        fillPath.close();

        final areaGradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4ECDC4).withOpacity(0.3),
            Color(0xFF4ECDC4).withOpacity(0.05),
          ],
        ).createShader(Rect.fromLTWH(0, padding, size.width, graphHeight));

        fillPaint.shader = areaGradient;
        canvas.drawPath(fillPath, fillPaint);
      }

      // Draw animated points
      for (int i = 0; i < animatedPointsCount && i < points.length; i++) {
        final pointOpacity = math.min(
          1.0,
          (animationValue - i / points.length) * points.length,
        );
        if (pointOpacity > 0) {
          // Outer circle (glow)
          final glowCirclePaint =
              Paint()
                ..color = Color(0xFF4ECDC4).withOpacity(0.4 * pointOpacity)
                ..style = PaintingStyle.fill;
          canvas.drawCircle(points[i], 8, glowCirclePaint);

          // Inner circle
          final circlePaint =
              Paint()
                ..color = Colors.white.withOpacity(pointOpacity)
                ..style = PaintingStyle.fill;
          canvas.drawCircle(points[i], 4, circlePaint);
        }
      }
    }

    // Draw labels
    final textPaint = TextPainter(textDirection: TextDirection.ltr);

    // X-axis labels
    for (int i = 0; i < labels.length; i++) {
      final x = padding + (i * graphWidth / (labels.length - 1));
      textPaint.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );
      textPaint.layout();
      textPaint.paint(
        canvas,
        Offset(x - textPaint.width / 2, size.height - 25),
      );
    }

    // Y-axis labels
    for (int i = 0; i <= 4; i++) {
      final value = maxValue - (i * valueRange / 4);
      final y = padding + (i * graphHeight / 4);
      textPaint.text = TextSpan(
        text: '${value.round()}%',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );
      textPaint.layout();
      textPaint.paint(canvas, Offset(5, y - textPaint.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
