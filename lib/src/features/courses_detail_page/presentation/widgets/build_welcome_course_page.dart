import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildWelcomeCoursePage extends StatelessWidget {
  const BuildWelcomeCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 4,
          intensity: 0.7,
          color: const Color(0xFFF2F7FA),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(18)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👋 Welcome, Learner!',
              style: GoogleFonts.nunito(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2B1B4F),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.format_quote,
                  color: Colors.deepPurple,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '"Knowledge is power, but enthusiasm pulls the switch."',
                    style: GoogleFonts.merriweather(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
