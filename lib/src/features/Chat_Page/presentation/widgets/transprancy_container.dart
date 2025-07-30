
import 'package:flutter/material.dart';

class TransprancyContainer extends StatelessWidget {
  const TransprancyContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    required this.border,
    this.margin,
    this.borderRadius,
    this.color ,this.gradient
  });
  final Widget child;
  final BoxBorder border;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Gradient? gradient;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
    
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius, // Rounded corners for the container
        border: border,gradient: gradient
      ),
      child: child,
    );
  }
}
