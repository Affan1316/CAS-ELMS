// Data Models

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/data_service_fee_feature.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/pay_fee_modal.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/screen_header.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature.dart';
import 'package:intl/intl.dart';

class FeeDetailsScreen extends StatefulWidget {
  final String studentId;
  const FeeDetailsScreen({super.key, required this.studentId});

  @override
  State<FeeDetailsScreen> createState() => _FeeDetailsScreenState();
}

class _FeeDetailsScreenState extends State<FeeDetailsScreen> {
  late StudentFeeFeature student;

  @override
  void initState() {
    super.initState();
    student = DataServiceFeeFeature.getStudent(widget.studentId);
  }

  void _refreshData() {
    setState(() {
      student = DataServiceFeeFeature.getStudent(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');

    return GradientBackground(
      child: Scaffold(
        body: SafeArea(
          child: ResponsivePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenHeader(title: student.name),
                const SizedBox(height: 20),
                NeuCard(
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 28 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveText(
                          text:
                              "Total Fee: ${currencyFormat.format(student.totalFee)}",
                          phoneSize: 16,
                          tabletSize: 20,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 8),
                        ResponsiveText(
                          text:
                              "Total Received: ${currencyFormat.format(student.totalPaid)}",
                          phoneSize: 16,
                          tabletSize: 20,
                        ),
                        const SizedBox(height: 8),
                        ResponsiveText(
                          text:
                              "Remaining: ${currencyFormat.format(student.remainingAmount)}",
                          phoneSize: 16,
                          tabletSize: 20,
                          color:
                              student.remainingAmount > 0
                                  ? Colors.redAccent
                                  : Colors.green,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: NeuCard(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: isTablet ? 40 : 20,
                          columns: const [
                            DataColumn(label: Text("Id")),
                            DataColumn(label: Text("Due Date")),
                            DataColumn(label: Text("Total")),
                            DataColumn(label: Text("Paid")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Action")),
                          ],
                          rows:
                              student.installments.map((installment) {
                                return _buildRow(installment, context);
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(FeeInstallment installment, BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    Color statusColor = Colors.green;

    if (installment.status == "Partial") {
      statusColor = Colors.orange;
    } else if (installment.status == "Unpaid") {
      statusColor = Colors.red;
    }

    return DataRow(
      cells: [
        DataCell(Text(installment.id)),
        DataCell(Text(DateFormat('MMM dd, yyyy').format(installment.dueDate))),
        DataCell(Text(currencyFormat.format(installment.totalAmount))),
        DataCell(Text(currencyFormat.format(installment.paidAmount))),
        DataCell(
          Text(
            installment.status,
            style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
          ),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (_) => PayFeeModal(
                      totalFee: installment.totalAmount,
                      onPay: (amount, method, date) {
                        DataServiceFeeFeature.updateInstallment(
                          widget.studentId,
                          installment.id,
                          amount,
                          method,
                          date,
                        );
                        _refreshData();
                      },
                    ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E206D),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Pay Fee", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
