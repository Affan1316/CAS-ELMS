import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/pay_fee/presentation/pages/group_detail_page.dart';

import '../domain/firestore_repositry.dart';
import 'student_entity_class.dart';

class ActualImplementationFirebaseRepo implements FirestoreRepositry {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String completeStudentsCollectionName = "students";
  @override
  addStudentDataToFirebase(StudentEntityClass student) async {
    print(
      "++++++++++++++++++++++executing second function___________________________",
    );

    await addStudentDataAccordingToGroupsToFirebase(student);
    return await firestore
        .collection(completeStudentsCollectionName)
        .doc(student.id)
        .set({
          "name": student.name,
          "fatherName": student.fatherName,
          "address": student.address,
          "cnic": student.cnic,
          "gender": student.gender,
          "email": student.email,
          "fatherOccupation": student.fatherOccupation,
          "group": student.group,
          "phone": student.phone,
        });
  }

  @override
  addStudentDataAccordingToGroupsToFirebase(StudentEntityClass student) async {
    String collectionName = student.group;

    print(
      "++++++++++++++++++++++ executing fitst function___________________________",
    );

    return await firestore
        .collection("$collectionName students")
        .doc(student.id)
        .set({"name": student.name});
  }

  @override
  Future<Map<String, dynamic>?> readStudentDataBasedOnId(String id) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection(completeStudentsCollectionName)
            .doc(id)
            .get();

    return documentSnapshot.data();
  }
}
