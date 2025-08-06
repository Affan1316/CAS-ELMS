import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/pay_fee/presentation/widgets/group_cards.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../pages/group_detail_page.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final List<Map<String, String>> groups = [
    {"code": "AI", "name": "Artificial Intelligence", "students": "30 Students"},
    {"code": "F22", "name": "Flutter Development", "students": "35 Students"},
    {"code": "F23", "name": "Android Development", "students": "40 Students"},
    {"code": "F24", "name": "Web Development", "students": "25 Students"},
    {"code": "A24", "name": "Data Science", "students": "20 Students"},
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredGroups = groups.where((group) {
      final name = group['name']!.toLowerCase();
      final code = group['code']!.toLowerCase();
      return name.contains(searchQuery.toLowerCase()) || code.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0097B2),
        elevation: 0,
        title: const Text(
          'Groups Overview',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: 6,
                intensity: 0.8,
                surfaceIntensity: 0.1,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
                color: const Color(0xFFE0E5EC),
                shadowLightColor: Colors.white,
                shadowDarkColor: const Color(0xFFA3B1C6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: TextField(
                cursorColor: const Color(0xFF0097B2),
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search groups...",
                  border: InputBorder.none,
                  icon: const Icon(Icons.search, color: Color(0xFF0097B2)),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Color(0xFF0097B2)),
                          onPressed: () => setState(() => searchQuery = ''),
                        )
                      : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: filteredGroups.length,
              itemBuilder: (context, index) {
                final group = filteredGroups[index];
                return GroupCard(
                  group: group,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AGroupPage()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
