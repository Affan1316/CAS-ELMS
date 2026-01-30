import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulter_entity.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulters_collective.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';

abstract class AbstractInstallmentRepo {
  Future<void> createStudentWithInstallments({
    required double paidAmount,
    required String studentId,
    required String name,
    required String groupId,
    required double totalFee,
    required int numberOfInstallments,
    required double amountPerMonth,
  });
  Future<StudentFeeFeatureEntityClass?> getStudent(String studentId);

  Future<List<FeeEntityClass>> fetchFeesByDateRange(
    DateTime start,
    DateTime end,
  );
  Future<List<FeeEntityClass>> fetchTodayFees();

  // NEW: Fetch day-wise aggregated fees
  Future<Map<DateTime, double>> fetchDayWiseFeesByDateRange(
    DateTime start,
    DateTime end,
  );

  Future<void> addToFeeDefaulters({
    required String studentId,
    required String name,
    required double remaingFee,
    required String groupId,
  });
  Future<bool> UpdateCollectiveFeeDefaultersDataGroupwise(
    double remaingFee,
    String group,
  );
  Future<FeeDefaultersCollective?> readFeeDefultersCollectiveDataBasedOnGroup(
    String groupId,
  );
  Future<List<FeeDefaulterEntity>> readFeeDefultersDataBasedOnGroup(
    String groupId,
  );
  Future<List<String>> readFeeDefaulterGroopNames();
  removeFromDefaulter(
    String groupId,
    String studentId,
    double paidAmount,
    double totalReaminingFeeForThisStudent,
  );
  Future<bool> checkIfStudentIsDefaulter(String groupId, String studentId);
  addToSuperAdminApprovalList(StudentFeeFeatureEntityClass student, int index);
  addToPendingFee2(
    StudentFeeFeatureEntityClass student,
    FeeInstallmentEntityClass adminSidePayedInstalment,
    double paidAmount,
    String paymentMethod,
    DateTime paidDate,
  );
}
