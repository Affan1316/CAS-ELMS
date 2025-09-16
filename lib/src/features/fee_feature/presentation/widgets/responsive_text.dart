// Data Models

import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final double phoneSize;
  final double tabletSize;
  final FontWeight weight;
  final Color color;

  const ResponsiveText({
    super.key,
    required this.text,
    required this.phoneSize,
    required this.tabletSize,
    this.weight = FontWeight.normal,
    this.color = const Color(0xFF3E206D),
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Text(
      text,
      style: TextStyle(
        fontSize: isTablet ? tabletSize : phoneSize,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
