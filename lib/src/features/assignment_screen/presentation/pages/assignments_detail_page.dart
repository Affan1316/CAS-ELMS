import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  NeumorphicButton(
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                    style: const NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: 4,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.arrow_back_ios_new, size: 26),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "if_else",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: -8,
                    intensity: 0.9,
                    surfaceIntensity: 0.5,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(20),
                    ),
                    color: NeumorphicTheme.baseColor(context),
                    lightSource: LightSource.topLeft,
                    shape: NeumorphicShape.concave,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    '''30 If‑Else Assignment Questions for Beginners

1) Check if a number is positive or negative.
2) Check if a number is even or odd.
...
30) Check if the time (hour) is morning, afternoon, evening, or night.''',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
