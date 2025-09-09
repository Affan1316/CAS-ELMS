import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/actual_implementation_firebase_repo.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';

class ReadWholeGroupStudentsListUsecase {
  final FirestoreRepositry firestoreRepositry =
      ActualImplementationFirebaseRepo();

  Stream<QuerySnapshot<Map<String, dynamic>>> readWholeGroupStudents(
    String groupTitle,
  ) {
    return firestoreRepositry.readWholeGroupStudentsList(groupTitle);
  }
}
