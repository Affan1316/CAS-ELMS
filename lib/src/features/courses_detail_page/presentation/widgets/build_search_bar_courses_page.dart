import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class BuildSearchBarCoursesPage extends StatelessWidget {
  const BuildSearchBarCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: -3,
          intensity: 0.6,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search courses...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            icon: const Icon(Icons.search, color: Color(0xFF2B1B4F)),
          ),
        ),
      ),
    );
  }
}
