import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/abstract_repo/abstract_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/get_groups_names_usecase.dart';

class ReadGroupNamesFeeDefaultersUsecase {
  final AbstractInstallmentRepo _abstractInstallmentRepo =
      ActualImplemetationInstallmentRepo();
  Future<List<String>> get() async {
    return await _abstractInstallmentRepo.readFeeDefaulterGroopNames();
  }
}
