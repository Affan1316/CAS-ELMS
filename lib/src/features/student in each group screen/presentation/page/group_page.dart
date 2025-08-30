// import 'package:flutter/material.dart';
// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/group_students_screen.dart';

import 'package:flutter_cas_app_main/src/features/student%20in%20each%20group%20screen/data/group.dart';
import 'package:flutter_cas_app_main/src/features/student%20in%20each%20group%20screen/data/student.dart';
import 'package:flutter_cas_app_main/src/features/student%20in%20each%20group%20screen/presentation/widget/update_group_screen.dart';

class GroupMainDetailPage extends StatefulWidget {
  const GroupMainDetailPage({super.key});

  @override
  State<GroupMainDetailPage> createState() => _GroupMainDetailPageState();
}

class _GroupMainDetailPageState extends State<GroupMainDetailPage> {
  List<Group> _groups = [
    Group(
      title: 'Flutter',
      course: 'Flutter',
      instructor: 'Sir Noman Ameer Khan',
      fee: 95000,
      startTime: '6:00 PM',
      endTime: '7:00 PM',
    ),
    Group(
      title: 'F21',
      course: 'Android',
      instructor: 'Sir Noman Ameer Khan',
      fee: 90000,
      startTime: '5:00 PM',
      endTime: '6:00 PM',
    ),
    Group(
      title: 'F9',
      course: 'Flutter',
      instructor: 'Sir Noman Ameer Khan',
      fee: 75000,
      startTime: '4:00 PM',
      endTime: '5:00 PM',
    ),
    Group(
      title: 'Web1',
      course: 'Web Development',
      instructor: 'Sir Talal Aslam',
      fee: 75000,
      startTime: '7:00 PM',
      endTime: '8:00 PM',
    ),
  ];

  List<Student> getDummyStudents(String groupTitle) {
    return [
      Student(name: 'Muzammil Ashraf', rollNumber: 'Ai-24'),
      Student(name: 'Muhammad Abdullah Waqar', rollNumber: 'Ai-08'),
      Student(name: 'Haroon Ashraf', rollNumber: 'Ai-02'),
      Student(name: 'Abdullah Qureshi', rollNumber: 'Ai-11'),
      Student(name: 'Gulraiz Javaid', rollNumber: 'Ai-09'),
      Student(name: 'Mushtaq Ahmed', rollNumber: 'Ai-23'),
    ];
  }

  void _editGroup(int index) {
    final group = _groups[index];
    final titleController = TextEditingController(text: group.title);
    final courseController = TextEditingController(text: group.course);
    final instructorController = TextEditingController(text: group.instructor);
    final feeController = TextEditingController(
      text: group.fee.toStringAsFixed(0),
    );
    final startTimeController = TextEditingController(text: group.startTime);
    final endTimeController = TextEditingController(text: group.endTime);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Group'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField(titleController, 'Title'),
                  _buildTextField(courseController, 'Course'),
                  _buildTextField(instructorController, 'Instructor'),
                  _buildTextField(
                    feeController,
                    'Fee',
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(startTimeController, 'Start Time'),
                  _buildTextField(endTimeController, 'End Time'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _groups[index] = group.copyWith(
                      title: titleController.text,
                      course: courseController.text,
                      instructor: instructorController.text,
                      fee: double.tryParse(feeController.text) ?? group.fee,
                      startTime: startTimeController.text,
                      endTime: endTimeController.text,
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFEAF6FF),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkPurple = const Color(0xFF3D0075);
    final cardColor = Colors.white;
    final shadowColor = const Color(0xFFB0D6F9);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Groups', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          final group = _groups[index];
          return GestureDetector(
            onTap: () {
              final students = getDummyStudents(group.title);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => GroupStudentsScreen(
                        groupTitle: group.title,
                        students: students,
                      ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(8, 8),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 15,
                    offset: Offset(-8, -8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkPurple,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.deepPurple),
                        tooltip: 'Edit Group',
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return
                                  // Container();
                                  UpdateGroupScreen();
                                },
                              ),
                            ),
                        //  _editGroup(index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _infoRow('Course:', group.course),
                  _infoRow('Instructor:', group.instructor),
                  _infoRow('Fee:', 'PKR ${group.fee.toStringAsFixed(0)}'),
                  _infoRow('Start:', group.startTime),
                  _infoRow('End:', group.endTime),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
