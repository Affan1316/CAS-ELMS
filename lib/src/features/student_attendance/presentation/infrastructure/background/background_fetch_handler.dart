import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/firebase_options.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/data/datasource/attendance_remote_datasource.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/data/repositories/attendance_repository_impl.dart';
import 'package:workmanager/workmanager.dart';

Future<void> performDailyAttendanceCheck() async {
  final repo = AttendanceRepositoryImpl(
    abstractAttendanceRemoteDatasource: AttendanceRemoteDatasource(
      firestore: FirebaseFirestore.instance,
    ),
    firestore: FirebaseFirestore.instance,
  );
  await repo.performDailyCheck();
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print("📅 Running background task: $task");

      // Firebase must be initialized in background isolate
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Run your attendance check
      await performDailyAttendanceCheck();

      print("✅ Attendance check completed successfully.");
      return Future.value(true);
    } catch (e) {
      print("❌ Error in background task: $e");
      return Future.value(false);
    }
  });
}
