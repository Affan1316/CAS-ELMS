// file: enhanced_fee_history_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/payment_method_enum.dart';

/// ---------- Model ----------
class FeeEntityClass {
  final String id;
  final DateTime date;
  final double paidAmount;
  final PaymentMethodEnum paymentMethod;
  final String status;

  FeeEntityClass({
    required this.id,
    required this.date,
    required this.paidAmount,
    required this.paymentMethod,
    required this.status,
  });

  factory FeeEntityClass.fromMap(Map<String, dynamic> map, {String? id}) {
    final ts = map['createdAt'] as Timestamp?;
    final date = ts?.toDate() ?? DateTime.now();
    final paidAmount = map['paidAmount'] ?? 0.0;
    final pmRaw = map['paymentMethod'];
    final status = map['status'] as String? ?? 'Paid';
    debugPrint("|||||||||||$paidAmount|||||||||||");
    debugPrint("|||||||||||$pmRaw|||||||||||");

    return FeeEntityClass(
      id: id ?? '',
      date: date,
      paidAmount: paidAmount,
      paymentMethod: _parsePaymentMethod(pmRaw),
      status: status,
    );
  }

  static PaymentMethodEnum _parsePaymentMethod(dynamic v) {
    // if (v == null) return PaymentMethod.ubl;
    final s = v.toString().toLowerCase();
    if (s.contains('cashpayment')) return PaymentMethodEnum.cashPayment;
    if (s.contains('jazz') || s.contains('jazzcash')) {
      return PaymentMethodEnum.jazzCash;
    }
    if (s.contains('easy') || s.contains('easypaisa')) {
      return PaymentMethodEnum.easyPaisa;
    }
    return PaymentMethodEnum.ubl;
  }
}
