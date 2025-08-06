// ............................................................................

import 'package:equatable/equatable.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/payment_method.dart';

class Fee extends Equatable {
  final String id;
  final DateTime date;
  final double amount;
  final String description;
  final String status;
  final PaymentMethod paymentMethod; // Add payment method field

  const Fee({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.status,
    required this.paymentMethod, // Add to constructor
  });

  @override
  List<Object> get props => [
    id,
    date,
    amount,
    description,
    status,
    paymentMethod,
  ];

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      id: json['id'] ?? '',
      date:
          json['date'] != null
              ? (json['date'] is DateTime
                  ? json['date']
                  : DateTime.parse(json['date']))
              : DateTime.now(),
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      paymentMethod: _parsePaymentMethod(
        json['paymentMethod'] ?? 'jazzCash',
      ), // Parse payment method
    );
  }

  // Helper method to parse payment method
  static PaymentMethod _parsePaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'easypaisa':
        return PaymentMethod.easyPaisa;
      case 'ubl':
        return PaymentMethod.ubl;
      case 'jazzcash':
      default:
        return PaymentMethod.jazzCash;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'status': status,
      'paymentMethod':
          paymentMethod.toString().split('.').last, // Convert to string
    };
  }

  Fee copyWith({
    String? id,
    DateTime? date,
    double? amount,
    String? description,
    String? status,
    PaymentMethod? paymentMethod, // Add to copyWith
  }) {
    return Fee(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod, // Add to copyWith
    );
  }
}
