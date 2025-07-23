import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class BulidCourseCard extends StatelessWidget {
  const BulidCourseCard({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    final bool enrolling = course['enrolling'];
    final Color baseColor = enrolling ? Color(0xFFE2F7FB) : Color(0xFFF3F3F3);
    final Color badgeColor = enrolling ? Color(0xFF2B9EB3) : Colors.grey;
    final Color enrollColor = enrolling ? Colors.green : Colors.red;

    return Neumorphic(
      style: NeumorphicStyle(
        depth: 5,
        intensity: 0.8,
        surfaceIntensity: 0.2,
        color: baseColor,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        shadowLightColorEmboss: Colors.white,
        shadowDarkColorEmboss: Colors.black26,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Neumorphic(
            style: NeumorphicStyle(
              color: badgeColor,
              depth: -4,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(6)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Text(
              course['title'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            course['description'],
            style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(
                enrolling ? Icons.check_circle : Icons.lock,
                color: enrollColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                enrolling ? 'Enrolling Now' : 'Closed',
                style: TextStyle(
                  color: enrollColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${course['enrollments']} enrolled',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          NeumorphicButton(
            onPressed: enrolling ? () {} : null,
            style: NeumorphicStyle(
              color: enrolling ? const Color(0xFF2B1B4F) : Colors.grey.shade400,
              depth: enrolling ? 5 : 0,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                'Enroll',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
