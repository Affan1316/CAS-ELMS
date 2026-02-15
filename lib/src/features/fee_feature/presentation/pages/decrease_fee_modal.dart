import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecreaseFeeModal extends StatefulWidget {
  final double currentTotalFee;
  final double currentPaidAmount;
  final Function(double favouredAmount, String description) onDecrease;

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
  final TextEditingController _descriptionController =
      TextEditingController(); // NEW
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose(); // NEW
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text.trim(); // NEW
      Navigator.of(context).pop();
      widget.onDecrease(amount, description); // NEW: Pass description
    }
  }

  @override
  Widget build(BuildContext context) {
    final remainingFee = widget.currentTotalFee - widget.currentPaidAmount;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Decrease Fee in Favour',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SingleChildScrollView(
        // NEW: Added scrolling for longer content
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Total Fee: ${widget.currentTotalFee.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                'Paid Amount: ${widget.currentPaidAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                'Remaining Fee: ${remainingFee.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Amount Field
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Favoured Amount',
                  hintText: 'Enter amount to decrease',
                  prefixIcon: const Icon(Icons.money_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
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

              const SizedBox(height: 16),

              // NEW: Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Reason for Favour',
                  hintText:
                      'Enter reason (e.g., Financial hardship, Merit scholarship)',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                maxLines: 3,
                maxLength: 200,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a reason for the favour';
                  }
                  if (value.trim().length < 10) {
                    return 'Please provide a more detailed reason (min 10 characters)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Warning Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.amber.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This will permanently decrease the total fee for this student.',
                        style: TextStyle(
                          fontSize: 12,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Decrease Fee',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
