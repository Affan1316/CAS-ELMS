import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class MyAnimatedText extends StatelessWidget {
  const MyAnimatedText({
    super.key,
    this.text = 'Select course to see groups',
    this.color = Colors.blueAccent,
  });
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              WavyAnimatedText(
                text,
                textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                speed: const Duration(milliseconds: 250),
              ),
            ],
            isRepeatingAnimation: true,
          ),
        ),
      ),
    );
  }
}
