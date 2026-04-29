import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/payment_method_enum.dart';
import 'package:intl/intl.dart';

class FeeDetailsDialog extends StatelessWidget {
  final FeeEntityClass fee;

  const FeeDetailsDialog({super.key, required this.fee});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            _getPaymentMethodIcon(fee.paymentMethod),
            color: _getPaymentMethodColor(fee.paymentMethod),
          ),
          const SizedBox(width: 2),
          const Text(
            'Transaction Details',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Amount', 'Rs ${fee.paidAmount.toStringAsFixed(2)}'),
          _buildDetailRow(
            'Payment Method',
            _getPaymentMethodLabel(fee.paymentMethod),
          ),
          _buildDetailRow('Status', fee.status),
          _buildDetailRow(
            'Date',
            DateFormat('dd MMM yyyy, hh:mm a').format(fee.date),
          ),
          _buildDetailRow('Transaction ID', fee.id.isEmpty ? 'N/A' : fee.id),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPaymentMethodColor(PaymentMethodEnum method) {
    switch (method) {
      case PaymentMethodEnum.jazzCash:
        return Colors.red[600]!;
      case PaymentMethodEnum.easyPaisa:
        return Colors.green[600]!;
      case PaymentMethodEnum.ubl:
        return Colors.blue[600]!;
      case PaymentMethodEnum.cashPayment:
        return Colors.greenAccent;
    }
  }

  IconData _getPaymentMethodIcon(PaymentMethodEnum method) {
    switch (method) {
      case PaymentMethodEnum.jazzCash:
        return Icons.phone_android;
      case PaymentMethodEnum.easyPaisa:
        return Icons.account_balance_wallet;
      case PaymentMethodEnum.ubl:
        return Icons.account_balance;
      case PaymentMethodEnum.cashPayment:
        return Icons.account_balance_wallet_outlined;
    }
  }

  String _getPaymentMethodLabel(PaymentMethodEnum method) {
    switch (method) {
      case PaymentMethodEnum.jazzCash:
        return 'JazzCash';
      case PaymentMethodEnum.easyPaisa:
        return 'EasyPaisa';
      case PaymentMethodEnum.ubl:
        return 'UBL Bank';
      case PaymentMethodEnum.cashPayment:
        return 'Cash';
    }
  }
}
