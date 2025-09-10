import 'package:flutter/material.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.data, this.padding = 16});
  final String data;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: FittedBox(
        child: Text(
          data,
          style: TextStyle(
            fontSize: getRespSize(context, size: 20),
            fontWeight: FontWeight.w600,
            color: Color(0xFF3D4C5F),
          ),
        ),
      ),
    );
  }
}
