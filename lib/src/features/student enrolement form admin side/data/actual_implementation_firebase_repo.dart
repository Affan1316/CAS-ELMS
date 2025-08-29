import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/data/student.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/domain/firestore_repositry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActualImplementationFirebaseRepo implements FirestoreRepositry {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  addStudentDataToFirebase(Student student) async {
    return await firestore.collection("students").doc(student.id).set({
      "name": student.name,
      "fatherName": student.fatherName,
      "address": student.address,
      "cnic": student.cnic,
      "gender": student.gender,
      "email": student.email,
      "fatherOccupation": student.fatherOccupation,
    });
  }
}
