import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';

class StudentDetailPage extends StatefulWidget {
  final StudentEntityClass student;
  const StudentDetailPage({super.key, required this.student});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Color darkPurple = const Color(0xFF3D0075);
  final Color cardColor = Colors.white;
  final Color shadowColor = const Color(0xFFB0D6F9);

  Widget _neoInfoCard(String title, String value, IconData icon, int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final start = (0.08 * index).clamp(0.0, 1.0);
        final end = (start + 0.5).clamp(0.0, 1.0);

        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        );

        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.45),
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: darkPurple.withOpacity(0.12),
              child: Icon(icon, color: darkPurple, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: darkPurple.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC), // soft neutral background
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 40),

          // Avatar
          Center(
            child: Hero(
              tag: student.id,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withOpacity(0.45),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    student.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: darkPurple,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Name + Group
          Center(
            child: Text(
              student.name,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: darkPurple,
              ),
            ),
          ),
          Center(
            child: Text(
              student.group,
              style: TextStyle(
                color: darkPurple.withOpacity(0.7),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Info Cards
          _neoInfoCard("ID", student.id, Icons.badge, 1),
          _neoInfoCard("Email", student.email, Icons.email, 2),
          _neoInfoCard("Phone", student.phone, Icons.phone, 3),
          _neoInfoCard("CNIC", student.cnic, Icons.credit_card, 4),
          _neoInfoCard("Gender", student.gender, Icons.person, 5),
          _neoInfoCard("Address", student.address, Icons.home, 6),
          _neoInfoCard(
            "Father Name",
            student.fatherName,
            Icons.family_restroom,
            7,
          ),
          _neoInfoCard(
            "Father Occupation",
            student.fatherOccupation,
            Icons.work,
            8,
          ),

          const SizedBox(height: 30),

          // Button
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.45),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Messaging ${student.name}...")),
                  );
                },
                icon: Icon(Icons.message, color: darkPurple, size: 20),
                label: Text(
                  "Send Message",
                  style: TextStyle(
                    color: darkPurple,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
