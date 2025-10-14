import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/abstract_repo/abstract_implemetation_installment_repo.dart';

class AddToPendingFee2 {
  AbstractInstallmentRepo abstractInstallmentRepo =
      ActualImplemetationInstallmentRepo();

  add(
    StudentFeeFeatureEntityClass student,
    FeeInstallmentEntityClass instalment,
    double paidAmount,
    String paymentMethod,
  ) {
    abstractInstallmentRepo.addToPendingFee2(
      student,
      instalment,
      paidAmount,
      paymentMethod,
    );
  }
}
