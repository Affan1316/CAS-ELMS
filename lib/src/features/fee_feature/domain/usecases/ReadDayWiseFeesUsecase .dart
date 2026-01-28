import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';

class ReadDayWiseFeesUsecase {
  final ActualImplemetationInstallmentRepo _repo =
      ActualImplemetationInstallmentRepo();

  Future<Map<DateTime, double>> execute(DateTime start, DateTime end) async {
    return await _repo.fetchDayWiseFeesByDateRange(start, end);
  }
}
