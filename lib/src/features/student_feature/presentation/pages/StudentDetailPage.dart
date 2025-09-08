import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _pickedImage;

  final Color darkPurple = const Color(0xFF3D0075);
  final Color cardColor = Colors.white;
  final Color shadowColor = const Color(0xFFB0D6F9);

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
      print("Picked Image Path: ${image.path}");
    }
  }

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

          // Avatar with picker
          Center(
            child: Hero(
              tag: student.id,
              child: GestureDetector(
                onTap: _pickImage,
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
                  child: ClipOval(
                    child:
                        _pickedImage != null
                            ? Image.file(_pickedImage!, fit: BoxFit.cover)
                            : Image.asset(
                              "assets/images/person 1-Photoroom.png",
                              fit: BoxFit.contain,
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
        ],
      ),
    );
  }
}
