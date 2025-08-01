import 'dart:ui';

import 'package:flutter/material.dart';

class SelectGroupPage extends StatelessWidget {
  const SelectGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var Size(:width, :height) = size;
    height -= kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6DD5FA),
        title: Text('Select Group'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
           color: Colors.white
          ),
          child: ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) => NeumorphicGroupTile(
              groupName: 'F19',
              courseName: 'Flutter Development',
            ),
          ),
        ),
      ),
    );
  }
}

class NeumorphicGroupTile extends StatelessWidget {
  final String groupName;
  final String courseName;
  final VoidCallback? onTap;

  const NeumorphicGroupTile({
    super.key,
    required this.groupName,
    required this.courseName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF3F6FA); // Light background for neumorphic effect

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          // Outer shadows for soft 3D look
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(6, 6),
            blurRadius: 12,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 12,
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(4, 4),
                blurRadius: 8,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 8,
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.people,
              color: Colors.black87,
              size: 28,
            ),
          ),
        ),
        title: Text(
          groupName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          courseName,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}