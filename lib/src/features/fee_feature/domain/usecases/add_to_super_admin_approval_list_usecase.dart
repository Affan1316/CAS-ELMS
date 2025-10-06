import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/abstract_repo/abstract_implemetation_installment_repo.dart';

class AddToSuperAdminApprovalListUsecase {
  final AbstractInstallmentRepo _abstractInstallmentRepo =
      ActualImplemetationInstallmentRepo();
  add(
    // FeeInstallmentEntityClass installment,
    StudentFeeFeatureEntityClass student,
    int index,
  ) {
    _abstractInstallmentRepo.addToSuperAdminApprovalList(
      // installment,
      student,
      index,
    );
  }
}
