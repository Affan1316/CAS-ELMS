import 'package:flutter/material.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        text,
        style: TextStyle(
          fontSize: getRespSize(context, size: TextSizes.headlineLarge),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
