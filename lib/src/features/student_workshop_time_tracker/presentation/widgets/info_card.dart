import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_workshop_time_tracker/presentation/pages/student_workshop_time_tracker.dart';
import 'package:flutter_cas_app_main/src/features/student_workshop_time_tracker/presentation/widgets/shadow_container.dart';

class StudentInfoCard extends StatelessWidget {
  const StudentInfoCard({super.key, required this.student});
  final DummyStudent student;

  @override
  Widget build(BuildContext context) {
    return ShadowedContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Student Name:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D4C5F),
                ),
              ),
              Text(
                student.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D4C5F),
                ),
              ),
            ],
          ),
          // SizedBox(height: 12),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Course Name:',
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Color(0xFF3D4C5F),
          //       ),
          //     ),
          //     Text(
          //       student.courseName,
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Color(0xFF3D4C5F),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Batch Name:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D4C5F),
                ),
              ),
              Text(
                student.batchName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D4C5F),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rollno:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D4C5F),
                ),
              ),
              Text(
                student.rollno??"",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D4C5F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
