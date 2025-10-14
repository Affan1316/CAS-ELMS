import 'package:flutter_cas_app_main/src/features/student_attendance/domain/entities/attendance.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/domain/repositories/abstract_attendance_repository.dart';

class GetAttendanceUsecase {
  final AbstractAttendanceRepository attendanceRepository;

  GetAttendanceUsecase({required this.attendanceRepository});

  Future<List<Attendance>> call(String studentId){
    return attendanceRepository.getAttendance(studentId);
  }
}