import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';

class DeleteStudentUseCase {
  final FirestoreRepositry firestoreRepositry;

  DeleteStudentUseCase({required this.firestoreRepositry});

  /// Deletes a student from the database
  /// 
  /// This will:
  /// - Remove the student from the main students collection
  /// - Remove the student from their group collection
  /// 
  /// Parameters:
  /// - [studentId]: The ID of the student to delete
  /// - [groupName]: The group the student belongs to
  /// 
  /// Throws an exception if the deletion fails
  Future<void> deleteStudent({
    required String studentId,
    required String groupName,
  }) async {
    try {
      await firestoreRepositry.deleteStudent(
        studentId: studentId,
        groupName: groupName,
      );
    } catch (e) {
      throw Exception('Failed to delete student: ${e.toString()}');
    }
  }
}