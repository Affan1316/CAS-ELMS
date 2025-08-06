// ............................................................................

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/payment_method.dart';

class FeeDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isAmount;
  final bool isStatus;
  final bool isPaymentMethod;
  final PaymentMethod? paymentMethod;

  const FeeDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isAmount = false,
    this.isStatus = false,
    this.isPaymentMethod = false,
    this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              isPaymentMethod
                  ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPaymentMethodColor(paymentMethod!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                  : Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isAmount || isStatus
                              ? FontWeight.bold
                              : FontWeight.normal,
                      color:
                          isStatus && value == "Completed"
                              ? Colors.green[700]
                              : Colors.black,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getPaymentMethodColor(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.jazzCash:
        return Colors.red[400]!;
      case PaymentMethod.easyPaisa:
        return Colors.green[400]!;
      case PaymentMethod.ubl:
        return Colors.blue[400]!;
    }
  }
}
