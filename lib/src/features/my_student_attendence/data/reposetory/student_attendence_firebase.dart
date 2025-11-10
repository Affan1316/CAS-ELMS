import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../../workshop_geofencing/Domain/repository/firestore_repository.dart';
import '../../../workshop_geofencing/Domain/repository/firestore_repository.dart';
import '../model/model_classes.dart';

class StudentAttendanceFirebase{
  final _firestore = FirebaseFirestore.instance;
  Future<List<AttendanceRecord>> getStudentAttendance(String studentId) async {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.studentCollection)
        .doc(studentId)
        .collection(FirebaseCollections.attendanceCollection)
        .orderBy('date', descending: true)
        .get();

    final records = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return AttendanceRecord(
        date: data['date'] ?? '',
        day: data['day'] ?? '',
        status: (data['status'] == true || data['status'] == 'present')
            ? AttendanceStatus.present
            : AttendanceStatus.absent,
      );
    }).toList();

    log("Attendance fetched: ${records.length}", name: "attendance_service");
    return records;
  }

}