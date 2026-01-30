import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/payment_method_enum.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/fee_details_dialog.dart';
import 'package:intl/intl.dart';

class FeeCardWidget extends StatelessWidget {
  final FeeEntityClass fee;
  final int index;
  final Color background;

  const FeeCardWidget({
    super.key,
    required this.fee,
    required this.index,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _neoDecoration(radius: 16),
      child: InkWell(
        onTap: () => _showFeeDetails(context, fee),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Payment method icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getPaymentMethodColor(
                    fee.paymentMethod,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  _getPaymentMethodIcon(fee.paymentMethod),
                  width: 28,
                  height: 28,
                  // color: _getPaymentMethodColor(fee.paymentMethod), // remove if image is colored
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16),

              // Fee details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student name
                    if (fee.name.isNotEmpty)
                      Text(
                        fee.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                    // Roll number
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Roll No: ${fee.rollNumber}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Payment method
                    Text(
                      _getPaymentMethodLabel(fee.paymentMethod),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Date
                    Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(fee.date),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 6),

                    // Status chip
                    _buildStatusChip(fee.status),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rs ${fee.paidAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    final lower = status.toLowerCase();
    if (lower.contains('pending')) {
      backgroundColor = Colors.orange[100]!;
      textColor = Colors.orange[800]!;
      icon = Icons.pending;
    } else if (lower.contains('failed') || lower.contains('error')) {
      backgroundColor = Colors.red[100]!;
      textColor = Colors.red[800]!;
      icon = Icons.error_outline;
    } else {
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[800]!;
      icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showFeeDetails(BuildContext context, FeeEntityClass fee) {
    showDialog(
      context: context,
      builder: (context) => FeeDetailsDialog(fee: fee),
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

  String _getPaymentMethodIcon(PaymentMethodEnum method) {
    switch (method) {
      case PaymentMethodEnum.jazzCash:
        return 'assets/icons/jazzcash.png';
      case PaymentMethodEnum.easyPaisa:
        return 'assets/icons/easypaisa.png';
      case PaymentMethodEnum.ubl:
        return 'assets/icons/ubl.png';
      case PaymentMethodEnum.cashPayment:
        return 'assets/icons/cash.png';
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

  /// Neomorphic decoration helper
  BoxDecoration _neoDecoration({double radius = 20}) {
    return BoxDecoration(
      color: const Color(0xFFEAF3FB),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color(0xFFB0D4F1), // soft light-blue shadow
          offset: Offset(4, 4),
          blurRadius: 8,
        ),
        BoxShadow(
          color: Colors.white, // highlight
          offset: Offset(-4, -4),
          blurRadius: 8,
        ),
      ],
    );
  }
}
