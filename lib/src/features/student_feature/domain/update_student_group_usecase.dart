import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';

class UpdateStudentGroupUseCase {
  final FirestoreRepositry firestoreRepositry;

  UpdateStudentGroupUseCase({required this.firestoreRepositry});

  /// Updates a student's group in the database
  /// 
  /// Parameters:
  /// - [studentId]: The ID of the student to update
  /// - [newGroupName]: The new group name to assign to the student
  /// 
  /// Throws an exception if the update fails
  Future<void> updateStudentGroup({
    required String studentId,
    required String newGroupName,
  }) async {
    try {
      await firestoreRepositry.updateStudentGroup(
        studentId: studentId,
        newGroupName: newGroupName,
      );
    } catch (e) {
      throw Exception('Failed to update student group: ${e.toString()}');
    }
  }
}