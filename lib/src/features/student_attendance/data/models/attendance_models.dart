import 'package:flutter_cas_app_main/src/features/student_attendance/domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  AttendanceModel({
    required super.date,
    required super.logs,
    required super.status,
  });

  factory AttendanceModel.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) {
    return AttendanceModel(
      date: DateTime.parse(docId),
      logs: List<Map<String, dynamic>>.from(json['locationLogs'] ?? []),
      status: json["status"] ?? "absent",
    );
  }
}
