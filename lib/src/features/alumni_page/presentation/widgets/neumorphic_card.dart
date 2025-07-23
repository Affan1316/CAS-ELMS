import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NeumorphicCard extends StatelessWidget {
  final Map<String, String> alum;
  const NeumorphicCard({super.key, required this.alum});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFE0DDDD)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF646262),
              offset: Offset(5, 5),
              blurRadius: 13,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-5, -5),
              blurRadius: 13,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, size: 30, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            Text(
              alum['name']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              alum['role']!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              alum['company']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Class of ${alum['year']!}",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (alum.containsKey('linkedin'))
                  IconButton(
                    icon: const Icon(Icons.link, color: Colors.blueAccent),
                    onPressed: () => _launchURL(alum['linkedin']!),
                  ),
                if (alum.containsKey('github'))
                  IconButton(
                    icon: const Icon(Icons.code, color: Colors.black),
                    onPressed: () => _launchURL(alum['github']!),
                  ),
              ],
            ),
          ],
        ),
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
