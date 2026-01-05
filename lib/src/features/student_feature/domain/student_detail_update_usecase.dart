import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';

class UpdateStudentUseCase {
  final FirestoreRepositry firestoreRepositry;

  UpdateStudentUseCase({required this.firestoreRepositry});

  /// Updates an existing student's information in the database
  /// 
  /// Parameters:
  /// - [student]: StudentEntityClass containing all updated student information
  /// 
  /// Throws an exception if the update fails
  Future<void> updateStudentData(StudentEntityClass student) async {
    try {
      await firestoreRepositry.updateStudentData(student);
    } catch (e) {
      throw Exception('Failed to update student data: ${e.toString()}');
    }
  }
}