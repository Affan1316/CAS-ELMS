// ............................................................................

import 'package:flutter_cas_app_main/src/features/fee%20history/data/fee.dart';

abstract class FeeService {
  Future<List<Fee>> getFees();
  Future<Fee?> getFeeById(String id);
  Future<void> addFee(Fee fee);
  Future<void> updateFee(Fee fee);
  Future<void> deleteFee(String id);
}
