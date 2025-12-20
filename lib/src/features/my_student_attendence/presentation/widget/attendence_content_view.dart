import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/data/model/model_classes.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/presentation/widget/attendence_list_item.dart';

class AttendanceContentView extends StatelessWidget {
  final Student student;
  final List<AttendanceRecord> records;

  const AttendanceContentView({
    super.key,
    required this.student,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Use the dedicated StudentInfoCard widget
        const SizedBox(height: 10),
        // Create a list of widgets from the records
        ...records.map((record) {
          // Use the dedicated AttendanceListItem widget
          return AttendanceListItem(record: record);
        }),
      ],
    );
  }
}
