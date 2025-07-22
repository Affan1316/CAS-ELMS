import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CourseDurationPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final double animationValue;

  CourseDurationPainter({
    required this.data,
    required this.labels,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Graph boundaries
    final padding = 40.0;
    final graphWidth = size.width - 2 * padding;
    final graphHeight = size.height - 2 * padding;

    // Find min and max values
    final minValue = 0.0;
    final maxValue = data.reduce(math.max) + 5;
    final valueRange = maxValue - minValue;

    // Draw animated bars
    final barWidth = graphWidth / (data.length * 2);

    for (int i = 0; i < data.length; i++) {
      final barProgress = math.max(
        0.0,
        math.min(1.0, (animationValue - i * 0.1) * 2.0),
      );
      if (barProgress > 0) {
        final x = padding + (i * graphWidth / (data.length - 1)) - barWidth / 2;
        final barHeight = (data[i] / valueRange) * graphHeight * barProgress;
        final y = size.height - padding - barHeight;

        // Create gradient for each bar
        final barGradient = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFFE94560), Color(0xFFFF6B9D), Color(0xFFFFADB5)],
        ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight));

        // Draw bar shadow
        final shadowPaint =
            Paint()
              ..color = Colors.black.withOpacity(0.3)
              ..style = PaintingStyle.fill;

        final shadowRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 3, y + 3, barWidth, barHeight),
          Radius.circular(8),
        );
        canvas.drawRRect(shadowRect, shadowPaint);

        // Draw main bar
        final barPaint =
            Paint()
              ..shader = barGradient
              ..style = PaintingStyle.fill;

        final barRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          Radius.circular(8),
        );
        canvas.drawRRect(barRect, barPaint);

        // Draw glowing border
        final borderPaint =
            Paint()
              ..color = Color(0xFFE94560).withOpacity(0.8)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..maskFilter = MaskFilter.blur(BlurStyle.outer, 4);

        canvas.drawRRect(barRect, borderPaint);

        // Draw floating value label
        final textPaint = TextPainter(
          text: TextSpan(
            text: '${data[i].round()}h',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPaint.layout();

        // Position label above bar
        final labelX = x + (barWidth - textPaint.width) / 2;
        final labelY = y - textPaint.height - 5;
        textPaint.paint(canvas, Offset(labelX, labelY));

        // Draw animated sparkle effects
        if (barProgress > 0.8) {
          final sparkleCount = 3;
          for (int j = 0; j < sparkleCount; j++) {
            final sparkleX = x + (j + 1) * (barWidth / (sparkleCount + 1));
            final sparkleY = y + j * (barHeight / sparkleCount);
            final sparkleSize =
                2.0 + math.sin(animationValue * math.pi * 4 + j) * 1.0;

            final sparklePaint =
                Paint()
                  ..color = Colors.white.withOpacity(0.8)
                  ..style = PaintingStyle.fill;

            canvas.drawCircle(
              Offset(sparkleX, sparkleY),
              sparkleSize,
              sparklePaint,
            );
          }
        }
      }
    }

    // Draw grid lines
    final gridPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.08)
          ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
      final y = padding + (i * graphHeight / 5);
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        gridPaint,
      );
    }

    // Draw labels
    final textPaint = TextPainter(textDirection: TextDirection.ltr);

    // X-axis labels
    for (int i = 0; i < labels.length; i++) {
      final x = padding + (i * graphWidth / (labels.length - 1));
      textPaint.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: Color(0xFFE94560),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      textPaint.layout();
      textPaint.paint(
        canvas,
        Offset(x - textPaint.width / 2, size.height - 25),
      );
    }

    // Y-axis labels
    for (int i = 0; i <= 5; i++) {
      final value = maxValue - (i * valueRange / 5);
      final y = padding + (i * graphHeight / 5);
      textPaint.text = TextSpan(
        text: '${value.round()}h',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 11,
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
