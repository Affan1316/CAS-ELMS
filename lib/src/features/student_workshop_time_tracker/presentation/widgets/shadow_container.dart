import 'package:flutter/material.dart';

class ShadowedContainer extends StatelessWidget {
  const ShadowedContainer({super.key, this.padding = 16, this.child});
  final double padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Color(0xFFE6E9EF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: Offset(-6, -6),
              blurRadius: 12,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0xFFA3B1C6),
              offset: Offset(6, 6),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
