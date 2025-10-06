import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/abstract_repo/abstract_implemetation_installment_repo.dart';

class AddToFeeDefaulterUsecase {
  AbstractInstallmentRepo abstractInstallmentRepo =
      ActualImplemetationInstallmentRepo();

  add(
    String studentId,
    String name,
    String rollnum,
    double remaingFee,
    String group,
  ) {
    abstractInstallmentRepo.addToFeeDefaulters(
      groupId: group,
      name: name,
      remaingFee: remaingFee,
      studentId: studentId,
    );
    abstractInstallmentRepo.UpdateCollectiveFeeDefaultersDataGroupwise(
      remaingFee,
      group,
    );
  }
}
