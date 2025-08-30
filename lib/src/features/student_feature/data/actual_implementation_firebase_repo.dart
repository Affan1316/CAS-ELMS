import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/pay_fee/presentation/pages/group_detail_page.dart';

import '../domain/firestore_repositry.dart';
import 'student_entity_class.dart';

class ActualImplementationFirebaseRepo implements FirestoreRepositry {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  addStudentDataToFirebase(StudentEntityClass student) async {
    addStudentDataAccordingToGroupsToFirebase(student);

    return await firestore.collection("students").doc(student.id).set({
      "name": student.name,
      "fatherName": student.fatherName,
      "address": student.address,
      "cnic": student.cnic,
      "gender": student.gender,
      "email": student.email,
      "fatherOccupation": student.fatherOccupation,
      "group": student.group,
    });
  }

  addStudentDataAccordingToGroupsToFirebase(StudentEntityClass student) async {
    String collectionName = student.group;
    return await firestore.collection("$collectionName data").doc(student.id);
  }
}
