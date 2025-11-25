import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/abstract_repo/super_admin_fee_repository.dart';

class FetchGroupFeeHistoryUsecase {
  final SuperAdminFeeRepository repo;

  FetchGroupFeeHistoryUsecase({required this.repo});
  Future fetch(String groupId) async {
    return await repo.fetchGroupFeeHistory(groupId);
  }
}
