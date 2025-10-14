import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/abstract_repo/abstract_implemetation_installment_repo.dart';

class RemoveStudentFromDefaultersUsecase {
  final AbstractInstallmentRepo _abstractInstallmentRepo =
      ActualImplemetationInstallmentRepo();

  remove(
    String groupId,
    String studentId,
    double paidAmount,
    double totalReaminingFeeForThisStudent,
  ) async {
    await _abstractInstallmentRepo.removeFromDefaulter(
      groupId,
      studentId,
      paidAmount,
      totalReaminingFeeForThisStudent,
    );
  }
}
