class FeeInstallment {
  final String id;
  final String title;
  final double totalAmount;
  double paidAmount;
  DateTime dueDate;
  DateTime? paidDate;
  String? paymentMethod;

  FeeInstallment({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueDate,
    this.paidDate,
    this.paymentMethod,
  });

  factory FeeInstallment.fromMap(Map<String, dynamic> map) {
    return FeeInstallment(
      id: map['id'] as String,
      title: map['title'] as String,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      paidAmount: (map['paidAmount'] as num).toDouble(),
      dueDate: DateTime.parse(map['dueDate']),
      paidDate:
          map['paidDate'] != null ? DateTime.parse(map['paidDate']) : null,
      paymentMethod: map['paymentMethod'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }
}

class StudentFeeFeature {
  final String id;
  final String name;
  final String groupId;
  final double totalFee;
  final List<FeeInstallment> installments;

  StudentFeeFeature({
    required this.id,
    required this.name,
    required this.groupId,
    required this.totalFee,
    required this.installments,
  });

  factory StudentFeeFeature.fromMap(Map<String, dynamic> map) {
    return StudentFeeFeature(
      id: map['id'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      totalFee: (map['totalFee'] as num).toDouble(),
      installments:
          (map['installments'] as List<dynamic>)
              .map((e) => FeeInstallment.fromMap(Map<String, dynamic>.from(e)))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'groupId': groupId,
      'totalFee': totalFee,
      'installments': installments.map((e) => e.toMap()).toList(),
    };
  }
}
