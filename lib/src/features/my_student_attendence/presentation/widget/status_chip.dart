import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/data/model/model_classes.dart';

class StatusChip extends StatelessWidget {
  final AttendanceStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // Default values
    String label;
    IconData icon;
    Color color;

    // Determine values based on the status enum
    switch (status) {
      case AttendanceStatus.present:
        label = 'Present';
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case AttendanceStatus.absent:
        label = 'Absent';
        icon = Icons.cancel;
        color = Colors.red;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}