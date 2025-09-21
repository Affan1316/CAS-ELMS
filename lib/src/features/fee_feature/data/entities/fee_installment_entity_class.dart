class FeeInstallmentEntityClass {
  final String id;
  final String title;
  final double totalAmount;
  //
  final double paidAmount;
  final DateTime dueDate;
  final String status;
  //
  final DateTime? paidDate;
  //
  final String? paymentMethod;

  FeeInstallmentEntityClass({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueDate,
    required this.status,
    this.paidDate,
    this.paymentMethod,
  });

  factory FeeInstallmentEntityClass.fromMap(Map<String, dynamic> map) {
    return FeeInstallmentEntityClass(
      id: (map['id'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      status: (map['status'] ?? 'Unpaid') as String,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (map['paidAmount'] as num?)?.toDouble() ?? 0.0,
      dueDate: DateTime.tryParse(map['dueDate'] ?? '') ?? DateTime.now(),
      paidDate:
          map['paidDate'] != null ? DateTime.tryParse(map['paidDate']) : null,
      paymentMethod: map['paymentMethod'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount, // ✅ added
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }
}
