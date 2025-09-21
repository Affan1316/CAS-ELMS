// Data Models

class GroupFeeFeature {
  final String id;
  // final String code;
  final String name;
  final List<String> memberIds;

  GroupFeeFeature({
    required this.id,
    // required this.code,
    required this.name,
    required this.memberIds,
  });
}
// Data Models

// class FeeInstallment {
//   final String id;
//   final String title;
//   final double totalAmount;
//   double paidAmount;
//   DateTime dueDate;
//   DateTime? paidDate;
//   String? paymentMethod;

//   FeeInstallment({
//     required this.id,
//     required this.title,
//     required this.totalAmount,
//     required this.paidAmount,
//     required this.dueDate,
//     this.paidDate,
//     this.paymentMethod,
//   });

//   String get status {
//     if (paidAmount >= totalAmount) return "Paid";
//     if (paidAmount > 0) return "Partial";
//     return "Unpaid";
//   }
// }
// Data Models

// import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment.dart';

// class StudentFeeFeature {
//   final String id;
//   final String name;
//   final String groupId;
//   final double totalFee;
//   final List<FeeInstallment> installments;

//   StudentFeeFeature({
//     required this.id,
//     required this.name,
//     required this.groupId,
//     required this.totalFee,
//     required this.installments,
//   });

//   double get totalPaid {
//     return installments.fold(
//       0,
//       (sum, installment) => sum + installment.paidAmount,
//     );
//   }

//   double get remainingAmount {
//     return totalFee - totalPaid;
//   }
// }
