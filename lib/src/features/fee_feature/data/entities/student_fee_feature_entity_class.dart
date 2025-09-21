import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';

class StudentFeeFeatureEntityClass {
  final String id;
  final String name;
  final String groupId;
  final double totalFee;
  final double paidAmount;
  final List<FeeInstallmentEntityClass> installments;

  const StudentFeeFeatureEntityClass({
    required this.id,
    required this.name,
    required this.groupId,
    required this.totalFee,
    required this.paidAmount,
    required this.installments,
  });

  factory StudentFeeFeatureEntityClass.fromMap(Map<String, dynamic> map) {
    return StudentFeeFeatureEntityClass(
      id: (map['id'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      groupId: (map['groupId'] ?? '') as String,
      totalFee: (map['totalFee'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (map['paidAmount'] as num?)?.toDouble() ?? 0.0,
      installments:
          (map['installments'] as List<dynamic>? ?? [])
              .map(
                (e) => FeeInstallmentEntityClass.fromMap(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'groupId': groupId,
      'totalFee': totalFee,
      'paidAmount': paidAmount,
      'installments': installments.map((e) => e.toMap()).toList(),
    };
  }
}
