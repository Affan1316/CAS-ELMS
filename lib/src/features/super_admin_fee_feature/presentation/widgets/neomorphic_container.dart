import 'package:flutter/material.dart';

class NeomorphicContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const NeomorphicContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E7EE),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }

    return container;
  }
}
