import 'package:flutter/material.dart';

class SlelectStudentPage extends StatelessWidget {
  const SlelectStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var Size(:width, :height) = size;
    height -= kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6DD5FA),
        title: Text('Select Student'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: Colors.white),
          child: ListView.builder(
            itemCount: 15,
            itemBuilder:
                (context, index) => LightNeumorphicStudentTile(
                  studentName: 'Saim',
                  fatherName: 'Riaz',
                  studentId: '34332',
                ),
          ),
        ),
      ),
    );
  }
}

class LightNeumorphicStudentTile extends StatelessWidget {
  final String studentName;
  final String fatherName;
  final String studentId;
  final VoidCallback? onTap;

  const LightNeumorphicStudentTile({
    super.key,
    required this.studentName,
    required this.fatherName,
    required this.studentId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const background = Color(
      0xFFF3F6FA,
    ); // Very light background for soft effect

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          // Outer soft shadows
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
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
            child: Icon(Icons.person, color: Colors.black54, size: 28),
          ),
        ),
        title: Text(
          studentName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          "Father: $fatherName\nID: $studentId",
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        onTap: onTap,
      ),
    );
  }
}
