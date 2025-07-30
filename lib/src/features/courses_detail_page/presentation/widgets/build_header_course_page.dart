import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildHeaderCoursePage extends StatelessWidget {
  const BuildHeaderCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Neumorphic(
        style: NeumorphicStyle(
          color: const Color(0xFFEAF1FB),
          depth: 8,
          intensity: 0.6,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NeumorphicButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
                color: Colors.white,
                depth: 3,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Color(0xFF2B1B4F),
              ),
            ),

            // Title
            Text(
              'CAS Learning Portal',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2B1B4F),
              ),
            ),

            // Profile icon or menu
            NeumorphicButton(
              onPressed: () {
                // Future: Show profile/settings
              },
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
                color: Colors.white,
                depth: 3,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.person,
                size: 22,
                color: Color(0xFF2B1B4F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
