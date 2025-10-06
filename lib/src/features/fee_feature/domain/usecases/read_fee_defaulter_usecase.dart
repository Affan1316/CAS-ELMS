import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/abstract_repo/abstract_implemetation_installment_repo.dart';

class ReadFeeDefaulterUsecase {
  final AbstractInstallmentRepo _abstractInstallmentRepo =
      ActualImplemetationInstallmentRepo();
  read(String groupId) async {
    return await _abstractInstallmentRepo.readFeeDefultersDataBasedOnGroup(
      groupId,
    );
  }
}
