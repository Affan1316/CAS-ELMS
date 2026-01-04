import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';

abstract class FirestoreRepositry {
  addStudentDataToFirebase(StudentEntityClass student);
  addStudentDataAccordingToGroupsToFirebase(StudentEntityClass student);
  Future<Map<String, dynamic>?> readStudentDataBasedOnId(String id);
  Stream<QuerySnapshot<Map<String, dynamic>>> readWholeGroupStudentsList(
    String groupTitle,
  );
  Future<List<String>> getGroupsNames();
  
  Future<void> updateStudentGroup({
    required String studentId,
    required String newGroupName,
  });
}
