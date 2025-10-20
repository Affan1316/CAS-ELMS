// domain/repositories/super_admin_fee_repository.dart

import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/entity/group_fee_history.dart';

abstract class SuperAdminFeeRepository {
  Future<List<Map<String, dynamic>>> getNotifications();
  Future<void> confirmPayment(String id, String studentId);
  Future fetchGroupFeeHistory(String groupId);
}
