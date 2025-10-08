import 'package:flutter_cas_app_main/src/features/student_attendance/data/repositories/attendance_repository_impl.dart';

class AttendanceDailycheckUsecase {
  final AttendanceRepositoryImpl attendanceRepositoryImpl;
  const AttendanceDailycheckUsecase({required this.attendanceRepositoryImpl});

  Future<void> call() async{
    return await attendanceRepositoryImpl.performDailyCheck();
  }
}