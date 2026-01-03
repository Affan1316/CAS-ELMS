import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/abstract_repo/super_admin_fee_repository.dart';

class ConfirmBulkSuperAdminFeePaymentUseCase {
  final SuperAdminFeeRepository repository;

  ConfirmBulkSuperAdminFeePaymentUseCase(this.repository);

  /// Confirms multiple payments at once
  ///
  /// [payments] is a list of maps containing 'id' and 'studentId'
  /// Example: [{'id': 'inst123', 'studentId': 'student456'}, ...]
  Future<void> call(List<Map<String, String>> payments) {
    return repository.confirmBulkPayments(payments);
  }
}
