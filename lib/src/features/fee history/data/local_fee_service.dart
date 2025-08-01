import 'package:flutter_cas_app_main/src/features/fee%20history/data/fee.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/fee_service.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/payment_method.dart';

class LocalFeeService implements FeeService {
  final List<Fee> _fees = [
    Fee(
      id: "FEE001",
      date: DateTime(2025, 7, 1),
      amount: 45000,
      description: "Tuition Fee",
      status: "Completed",
      paymentMethod: PaymentMethod.jazzCash, // Add payment method
    ),
    Fee(
      id: "FEE002",
      date: DateTime(2025, 7, 2),
      amount: 75000,
      description: "Hostel Fee",
      status: "Completed",
      paymentMethod: PaymentMethod.easyPaisa, // Add payment method
    ),
    Fee(
      id: "FEE003",
      date: DateTime(2025, 7, 3),
      amount: 92500,
      description: "Exam Fee",
      status: "Completed",
      paymentMethod: PaymentMethod.ubl, // Add payment method
    ),
    Fee(
      id: "FEE004",
      date: DateTime(2025, 7, 4),
      amount: 35000,
      description: "Library Fee",
      status: "Completed",
      paymentMethod: PaymentMethod.jazzCash, // Add payment method
    ),
    Fee(
      id: "FEE005",
      date: DateTime(2025, 7, 5),
      amount: 15000,
      description: "Lab Fee",
      status: "Completed",
      paymentMethod: PaymentMethod.easyPaisa, // Add payment method
    ),
    Fee(
      id: "FEE006",
      date: DateTime(2025, 7, 7),
      amount: 20000,
      description: "Sports Fee",
      status: "Completed",
      paymentMethod: PaymentMethod.ubl, // Add payment method
    ),
  ];

  @override
  Future<List<Fee>> getFees() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _fees;
  }

  @override
  Future<Fee?> getFeeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _fees.firstWhere((fee) => fee.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addFee(Fee fee) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _fees.add(fee);
  }

  @override
  Future<void> updateFee(Fee fee) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _fees.indexWhere((f) => f.id == fee.id);
    if (index != -1) {
      _fees[index] = fee;
    }
  }

  @override
  Future<void> deleteFee(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _fees.removeWhere((fee) => fee.id == id);
  }
}
