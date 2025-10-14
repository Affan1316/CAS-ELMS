// domain/repositories/super_admin_fee_repository.dart

abstract class SuperAdminFeeRepository {
  Future<List<Map<String, dynamic>>> getNotifications();
  Future<void> confirmPayment(String id, String studentId);
}
