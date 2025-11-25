// Data Models

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:intl/intl.dart';

class PayFeeModal extends StatefulWidget {
  final double totalFee;
  final void Function(double amount, String method, DateTime date)? onPay;

  const PayFeeModal({super.key, required this.totalFee, this.onPay});

  @override
  State<PayFeeModal> createState() => _PayFeeModalState();
}

class _PayFeeModalState extends State<PayFeeModal> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  String _paymentMethod = "Cash";

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _amountController.text = widget.totalFee.toStringAsFixed(2);
    _dateController.text = DateFormat('MMM dd, yyyy').format(_selectedDate!);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: EdgeInsets.all(isTablet ? 60 : 20),
        child: NeuCard(
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 32 : 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ResponsiveText(
                  text: "Pay Fee",
                  phoneSize: 20,
                  tabletSize: 26,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 16),

                Text("Total: ${widget.totalFee.toStringAsFixed(2)}"),

                const SizedBox(height: 16),

                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Paying Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                InkWell(
                  onTap: _pickDate,
                  child: IgnorePointer(
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Select Date",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Column(
                  children: [
                    _buildRadio("cashPayment"),
                    _buildRadio("UBL"),
                    _buildRadio("JazzCash"),
                    _buildRadio("EasyPaisa"),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _modalButton("Pay", Colors.blue, () {
                      final amount = double.tryParse(_amountController.text);

                      if (amount != null && _selectedDate != null) {
                        widget.onPay?.call(
                          amount,
                          _paymentMethod,
                          _selectedDate!,
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter valid amount & date"),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(String method) {
    return RadioListTile(
      title: Text(method),
      value: method,
      groupValue: _paymentMethod,
      onChanged: (value) {
        setState(() => _paymentMethod = value.toString());
      },
    );
  }

  Widget _modalButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
