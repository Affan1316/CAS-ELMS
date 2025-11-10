import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/presentation/widget/status_chip.dart';

import '../../data/model/model_classes.dart';

/// A dedicated StatelessWidget for a single attendance row
class AttendanceListItem extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceListItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.containerColor,
      child: ListTile(
        title: Text(
          record.date,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        subtitle: Text(record.day, style: TextStyle(color: Colors.grey[600])),
        // Use the StatusChip to show the status
        trailing: StatusChip(status: record.status),
      ),
    );
  }
}
