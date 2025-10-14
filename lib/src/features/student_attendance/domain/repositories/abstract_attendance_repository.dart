import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/domain/entities/attendance.dart';

abstract class AbstractAttendanceRepository {
  Future<List<Attendance>> getAttendance(String studentId);

  Future<void> performDailyCheck();
}