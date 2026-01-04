abstract class SuperAdminFeeRepository {
  Future<List<Map<String, dynamic>>> getNotifications();
  Future<void> confirmPayment(String id, String studentId);

  // New method for bulk confirmation
  Future<void> confirmBulkPayments(List<Map<String, String>> payments);

  Future fetchGroupFeeHistory(String groupId);
}
