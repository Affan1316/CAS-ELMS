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
    extends State<StudentSideFeeDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudentFeatureBloc>().add(
      GetStudentSideFeeEvent(studentId: widget.studentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GradientBackground(
      child: Scaffold(
        body: BlocBuilder<StudentFeatureBloc, StudentFeatureState>(
          builder: (context, state) {
            // ========== LOADING ==========
            if (state is StudentSideFeeLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            // ========== ERROR ==========
            if (state is StudentFeeLoadFailureState) {
              return const Center(child: Text("Failed to load fee details."));
            }

            // ========== SUCCESS ==========
            if (state is StudentFeeLoadedState) {
              final student = state.student;

              return SafeArea(
                child: ResponsivePadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ========== HEADER ==========
                      ScreenHeader(
                        title: "Hello, ${student.name}",
                        trailing: IconButton(
                          onPressed: () {
                            context.read<StudentFeatureBloc>().add(
                              GetStudentSideFeeEvent(
                                studentId: widget.studentId,
                              ),
                            );
                          },
                          icon: const Icon(Icons.refresh_sharp),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ========== FEE SUMMARY CARD ==========
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
                                    "Total Paid: ${currencyFormat.format(student.paidAmount)}",
                                phoneSize: 16,
                                tabletSize: 20,
                              ),
                              const SizedBox(height: 8),
                              ResponsiveText(
                                text:
                                    "Remaining Fee: ${currencyFormat.format(student.totalFee - student.paidAmount)}",
                                phoneSize: 16,
                                tabletSize: 20,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ========== INSTALLMENTS TABLE ==========
                      Expanded(
                        child: NeuCard(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: isTablet ? 40 : 20,
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
                    ],
                  ),
                ),
              );
            }

            // ========== UNEXPECTED STATE ==========
            return const SizedBox();
          },
        ),
      ),
    );
  }

  // -------- Installment Row Builder --------
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
          Text(
            installment.status,
            style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
          ),
        ),
      ],
    );
  }
}
