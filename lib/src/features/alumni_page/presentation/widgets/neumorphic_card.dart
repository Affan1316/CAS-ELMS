import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NeumorphicCard extends StatelessWidget {
  final Map<String, String> alum;
  const NeumorphicCard({super.key, required this.alum});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF9F9F9), Color(0xFFE6E6E6)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFBEBEBE),
            offset: Offset(6, 6),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing spotlight avatar
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.white, Colors.grey.shade300],
                radius: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.person, size: 36, color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(height: 18),

          // Name
          Text(
            alum['name']!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          // Role
          Text(
            alum['role']!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
            ),
          ),

          // Company (styled like a clickable brand)
          const SizedBox(height: 6),
          Text(
            alum['company']!,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colors.deepPurple,
            ),
          ),

          // Year
          const SizedBox(height: 4),
          Text(
            "Class of ${alum['year']!}",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),

          // Icons
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (alum.containsKey('linkedin'))
                IconButton(
                  icon: const Icon(Icons.link),
                  iconSize: 22,
                  color: Colors.blueAccent,
                  onPressed: () => _launchURL(alum['linkedin']!),
                  tooltip: 'View LinkedIn',
                ),
              if (alum.containsKey('github'))
                IconButton(
                  icon: const Icon(Icons.code),
                  iconSize: 22,
                  color: Colors.black87,
                  onPressed: () => _launchURL(alum['github']!),
                  tooltip: 'View GitHub',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
