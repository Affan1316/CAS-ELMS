import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/data/datasource/abstract_attendance_remote_datasource.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/data/models/attendance_models.dart';

class AttendanceRemoteDatasource extends AbstractAttendanceRemoteDatasource {
   
   final FirebaseFirestore firestore;
   AttendanceRemoteDatasource({required this.firestore});

  @override
  Future<List<AttendanceModel>> fetchAttendance(String studentId) async{
    final snapshot = await firestore
        .collection("students")
        .doc(studentId)
        .collection("attendance")
        .get();

    return snapshot.docs
        .map((doc) => AttendanceModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
  
}