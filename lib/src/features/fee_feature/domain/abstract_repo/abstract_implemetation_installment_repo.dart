import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';

abstract class AbstractInstallmentRepo {
  Future<void> createStudentWithInstallments({
    required double paidAmount,
    required String studentId,
    required String name,
    required String groupId,
    required double totalFee,
    required int numberOfInstallments,
  });
  Future<StudentFeeFeatureEntityClass?> getStudent(String studentId);
  Future<void> updateInstallmentPayment({
    required String studentId,
    required String installmentId,
    required double paidAmount,
    required DateTime paidDate,
    required String paymentMethod,
  });
}
