import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/screen_header.dart';

import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';

import 'package:intl/intl.dart';

class StudentSideFeeDetailsScreen extends StatefulWidget {
  final String studentId;

  const StudentSideFeeDetailsScreen({super.key, required this.studentId});

  @override
  State<StudentSideFeeDetailsScreen> createState() =>
      _StudentSideFeeDetailsScreenState();
}

class _StudentSideFeeDetailsScreenState
    extends State<StudentSideFeeDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController refreshController;

  @override
  void initState() {
    super.initState();

    refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    context.read<StudentFeatureBloc>().add(
      GetStudentSideFeeEvent(studentId: widget.studentId),
    );
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GradientBackground(
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body: BlocBuilder<StudentFeatureBloc, StudentFeatureState>(
          builder: (context, state) {
            // ---------- LOADING ----------
            if (state is StudentSideFeeLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            // ---------- ERROR ----------
            if (state is StudentFeeLoadFailureState) {
              return const Center(child: Text("Failed to load fee details."));
            }

            // ---------- SUCCESS ----------
            if (state is StudentFeeLoadedState) {
              final student = state.student;

              return SafeArea(
                child: ResponsivePadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ---------------- HEADER (Floating Neu Container) ----------------
                      Container(
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white.withOpacity(0.6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              offset: const Offset(4, 4),
                              blurRadius: 12,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.6),
                              offset: const Offset(-4, -4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveText(
                              text: "Hello, ${student.name}",
                              phoneSize: 20,
                              tabletSize: 26,
                              weight: FontWeight.bold,
                            ),
                            RotationTransition(
                              turns: Tween(
                                begin: 0.0,
                                end: 1.0,
                              ).animate(refreshController),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 28,
                                ),
                                onPressed: () {
                                  refreshController.forward(from: 0);
                                  context.read<StudentFeatureBloc>().add(
                                    GetStudentSideFeeEvent(
                                      studentId: widget.studentId,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// ---------------- FEE SUMMARY CARD ----------------
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.9, end: 1),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        builder: (context, scale, child) {
                          return Transform.scale(scale: scale, child: child);
                        },
                        child: NeuCard(
                          child: Padding(
                            padding: EdgeInsets.all(isTablet ? 30 : 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _summaryRow(
                                  "Total Fee",
                                  student.totalFee,
                                  currencyFormat,
                                  highlight: true,
                                ),
                                const SizedBox(height: 10),
                                _summaryRow(
                                  "Total Paid",
                                  student.paidAmount,
                                  currencyFormat,
                                ),
                                const SizedBox(height: 10),
                                _summaryRow(
                                  "Remaining",
                                  student.totalFee - student.paidAmount,
                                  currencyFormat,
                                  highlight: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ---------------- INSTALLMENTS TABLE ----------------
                      Expanded(
                        child: NeuCard(
                          // borderRadius: 26,
                          // blur: 12,
                          // distance: 3,
                          // intensity: 0.13,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),

                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStatePropertyAll(
                                    Colors.blueGrey.withOpacity(0.07),
                                  ),
                                  columnSpacing: isTablet ? 45 : 28,
                                  dataRowHeight: 68,
                                  border: TableBorder(
                                    horizontalInside: BorderSide(
                                      color: Colors.grey.withOpacity(0.15),
                                    ),
                                  ),
                                  columns: const [
                                    DataColumn(label: Text("Installment")),
                                    DataColumn(label: Text("Due Date")),
                                    DataColumn(label: Text("Total")),
                                    DataColumn(label: Text("Paid")),
                                    DataColumn(label: Text("Status")),
                                  ],
                                  rows:
                                      student.installments
                                          .map((i) => _buildRow(i))
                                          .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// ---------------------------------------------------------
  /// SUMMARY ROW (Beautiful Neomorphic Typography)
  /// ---------------------------------------------------------
  Widget _summaryRow(
    String label,
    num amount,
    NumberFormat format, {
    bool highlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          format.format(amount),
          style: TextStyle(
            fontSize: 17,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
            color: highlight ? Colors.blueAccent : Colors.black87,
          ),
        ),
      ],
    );
  }

  /// ---------------------------------------------------------
  /// INSTALLMENT ROW (Status chip + clean layout)
  /// ---------------------------------------------------------
  DataRow _buildRow(FeeInstallmentEntityClass installment) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');

    Color statusColor = Colors.green;
    final status = installment.status.toLowerCase();

    if (status == "pending") statusColor = Colors.orange;
    if (status == "unpaid") statusColor = Colors.red;

    return DataRow(
      cells: [
        DataCell(Text(installment.title)),
        DataCell(Text(DateFormat('MMM dd, yyyy').format(installment.dueDate))),
        DataCell(Text(currencyFormat.format(installment.totalAmount))),
        DataCell(Text(currencyFormat.format(installment.paidAmount))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.13),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  offset: const Offset(2, 2),
                  blurRadius: 5,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  offset: const Offset(-2, -2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              installment.status,
              style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
            ),
          ),
        ),
      ],
    );
  }
}
