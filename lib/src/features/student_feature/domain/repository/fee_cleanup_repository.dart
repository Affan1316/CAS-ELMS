
abstract class FeeCleanupRepository {
  Future<void> deleteStudentFeeData({
    required String studentId,
    required String groupId,
  });
}
