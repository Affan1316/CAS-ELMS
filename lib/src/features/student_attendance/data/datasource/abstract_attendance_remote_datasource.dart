import 'package:flutter_cas_app_main/src/features/student_attendance/data/models/attendance_models.dart';

abstract class AbstractAttendanceRemoteDatasource {
  Future<List<AttendanceModel>> fetchAttendance(String studentId);
}