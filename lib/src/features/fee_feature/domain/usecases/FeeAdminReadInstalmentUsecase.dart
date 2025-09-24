import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';

class Feeadminreadinstalmentusecase {
  final ActualImplemetationInstallmentRepo actualImplemetationInstallmentRepo =
      ActualImplemetationInstallmentRepo();
  Future<StudentFeeFeatureEntityClass?> getStudent(String studentId) async {
    return await actualImplemetationInstallmentRepo.getStudent(studentId);
  }
}
