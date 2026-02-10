import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecreaseFeeModal extends StatefulWidget {
  final double currentTotalFee;
  final double currentPaidAmount;
  final Function(double favouredAmount) onDecrease;

  const DecreaseFeeModal({
    super.key,
    required this.currentTotalFee,
    required this.currentPaidAmount,
    required this.onDecrease,
  });

  @override
  State<DecreaseFeeModal> createState() => _DecreaseFeeModalState();
}

class _DecreaseFeeModalState extends State<DecreaseFeeModal> {
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      Navigator.of(context).pop();
      widget.onDecrease(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final remainingFee = widget.currentTotalFee - widget.currentPaidAmount;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      title: const Text(
        'Decrease Fee in Favour',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),

      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FeeInfoRow(
              label: 'Current Total Fee',
              value: widget.currentTotalFee,
            ),
            const SizedBox(height: 8),
            _FeeInfoRow(label: 'Paid Amount', value: widget.currentPaidAmount),
            const SizedBox(height: 8),
            _FeeInfoRow(
              label: 'Remaining Fee',
              value: remainingFee,
              highlight: true,
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Favoured Amount',
                hintText: 'Enter amount to decrease',
                prefixIcon: const Icon(Icons.money_off_rounded),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null) {
                  return 'Please enter a valid number';
                }
                if (amount <= 0) {
                  return 'Amount must be greater than 0';
                }
                if (amount > remainingFee) {
                  return 'Amount cannot exceed remaining fee';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This action will permanently reduce the total fee for this student.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Decrease Fee',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/* ----------------------- SUPPORTING WIDGET ------------------------ */

class _FeeInfoRow extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;

  const _FeeInfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        const Spacer(),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: highlight ? Colors.orange.shade700 : Colors.black87,
          ),
        ),
      ],
    );
  }
}
