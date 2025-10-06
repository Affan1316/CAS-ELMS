import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/abstract_repo/abstract_implemetation_installment_repo.dart';

class UpdateStudentInstallmentUsecaseFee {
  AbstractInstallmentRepo repo = ActualImplemetationInstallmentRepo();
  update({
    required String studentId,
    required String installmentId,
    required double paidAmount,
    required String paymentMethod,
    required DateTime paidDate,
    required String groupId,
    required double totalReaminingFeeForThisStudent,
  }) {
    var a = repo.updateInstallmentPayment(
      studentId: studentId,
      installmentId: installmentId,
      paidAmount: paidAmount,
      paymentMethod: paymentMethod,
      paidDate: paidDate,
      groupId: groupId,
      totalReaminingFeeForThisStudent: totalReaminingFeeForThisStudent,
    );
  }
}
