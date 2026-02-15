import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/repository/fee_cleanup_repository.dart';

class DeleteStudentUseCase {
  final FirestoreRepositry firestoreRepositry;
  final FeeCleanupRepository? feeCleanupRepository;

  DeleteStudentUseCase({
    required this.firestoreRepositry,
    this.feeCleanupRepository,
  });

  /// Deletes a student from the database
  /// 
  /// This will:
  /// - Clean up fee records (if feeCleanupRepository is provided)
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
      // 1. Clean up fee data first
      if (feeCleanupRepository != null) {
        await feeCleanupRepository!.deleteStudentFeeData(
          studentId: studentId,
          groupId: groupName,
        );
      } else {
        print("Warning: feeCleanupRepository is null. Fee data will NOT be deleted.");
      }

      // 2. Delete student data
      await firestoreRepositry.deleteStudent(
        studentId: studentId,
        groupName: groupName,
      );
    } catch (e) {
      throw Exception('Failed to delete student: ${e.toString()}');
    }
  }
}