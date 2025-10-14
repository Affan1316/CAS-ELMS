// domain/usecases/get_super_admin_fee_notifications.dart

import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/abstract_repo/super_admin_fee_repository.dart';

class ConfirmSuperAdminFeePaymentUseCase {
  final SuperAdminFeeRepository repository;

  ConfirmSuperAdminFeePaymentUseCase(this.repository);

  Future<void> call(String id, String studentId) {
    return repository.confirmPayment(id, studentId);
  }
}
