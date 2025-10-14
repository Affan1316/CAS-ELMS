import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/data/datasource/abstract_attendance_remote_datasource.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/domain/entities/attendance.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/domain/repositories/abstract_attendance_repository.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceRepositoryImpl extends AbstractAttendanceRepository {
  final AbstractAttendanceRemoteDatasource abstractAttendanceRemoteDatasource;
  final FirebaseFirestore firestore;

  AttendanceRepositoryImpl({
    required this.abstractAttendanceRemoteDatasource,
    required this.firestore,
  });
  @override
  Future<List<Attendance>> getAttendance(String studentId) async {
    return await abstractAttendanceRemoteDatasource.fetchAttendance(studentId);
  }

  @override
  Future<void> performDailyCheck() async {
    final firestore = FirebaseFirestore.instance;
    const studentId = "F17-02";

    final now = DateTime.now();
    final todayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final yesterdayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${(now.day - 1).toString().padLeft(2, '0')}";

    final todayDoc = firestore
        .collection("students")
        .doc(studentId)
        .collection("attendance")
        .doc(todayStr);
    final yesterdayDoc = firestore
        .collection("students")
        .doc(studentId)
        .collection("attendance")
        .doc(yesterdayStr);

    // ✅ 1. Close yesterday's attendance if still open
    final ySnap = await yesterdayDoc.get();
    if (ySnap.exists) {
      final yData = ySnap.data()!;
      if (yData["lastEnterTime"] != null && yData["status"] != "present") {
        await yesterdayDoc.update({
          "status": "present",
          "closedAt": now.toIso8601String(),
        });
        print("✅ Closed yesterday’s attendance");
      }
    }

    // ✅ 2. Ensure today's doc exists
    final tSnap = await todayDoc.get();
    if (!tSnap.exists) {
      bool isInsideZone =
          await _checkIfUserInsideZone(); // 👈 Check current location

      await todayDoc.set({
        "locationLogs": [
          if (isInsideZone)
            {
              "zoneId": "rollover_zone",
              "event": "manual_rollover_enter",
              "timestamp": now.toIso8601String(),
            },
        ],
        "status": "absent",
        "lastEnterTime": isInsideZone ? now.toIso8601String() : null,
      });

      if (isInsideZone) {
        print("📍 New day started — user still inside zone, entry logged");
      } else {
        print("📅 New day started — user outside zone, normal absent start");
      }
    }
  }

  Future<bool> _checkIfUserInsideZone() async {
    LocationPermission permission = await Geolocator.checkPermission();
    const double zoneLatitude = 29.394702; // example: Lahore coordinates
    const double zoneLongitude = 71.652824;
    const double zoneRadiusMeters = 50.0;

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return false;
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final double userLat = position.latitude;
      final double userLng = position.longitude;

      final double distance = Geolocator.distanceBetween(
        userLat,
        userLng,
        zoneLatitude,
        zoneLongitude,
      );
      log(
        "📍 User distance from zone: ${distance.toStringAsFixed(2)} meters",
        name: "GeofenceServiceImpl",
      );

      return distance <= zoneRadiusMeters;
    } catch (e) {
      log("❌ Error getting location: $e", name: "GeofenceServiceImpl");
      return false;
    }
  }
}
