import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';

class ReadStudentUseCase {
  final FirestoreRepositry firestoreRepositry;
  ReadStudentUseCase({required this.firestoreRepositry});
  Future<StudentEntityClass> readStudentDataUsingId(String id) async {
    var a = await firestoreRepositry.readStudentDataBasedOnId(id);
    a!["id"] = id;

    print(a);
    return StudentEntityClass.fromMap(a);
  }
}
