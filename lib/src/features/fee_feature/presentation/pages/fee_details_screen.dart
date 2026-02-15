import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/EditDueDateModal%20.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/decrease_fee_modal.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/pay_fee_modal.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/screen_header.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
import 'package:intl/intl.dart';

class FeeDetailsScreen extends StatefulWidget {
  final String studentId;
  final String groupId;
  final bool isDefaulter;

  const FeeDetailsScreen({
    super.key,
    required this.studentId,
    required this.groupId,
    required this.isDefaulter,
  });

  @override
  State<FeeDetailsScreen> createState() => _FeeDetailsScreenState();
}

class _FeeDetailsScreenState extends State<FeeDetailsScreen> {
  late StudentFeeFeatureEntityClass student;
  FeeInstallmentEntityClass? installment;
  int index = -1;
  bool isRefreshed = false;
  double? thisTimepaidamount;
  @override
  void initState() {
    super.initState();
  }

  void _refreshData() {
    context.read<FeeAdminBloc>().add(
      GetStudentInstalmentEvent(
        studentId: widget.studentId,
        groupId: widget.groupId,
      ),
    );
    isRefreshed = true;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');

    return GradientBackground(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD), // App Background
        body: BlocConsumer<FeeAdminBloc, FeeAdminState>(
          listener: (context, state) {
            if (state is AddingFeeDefaulterCompleteState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Added to defaulters ")));
            }
            if (state is FeeDecreasedInFavourState) {
              student = state.student;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Fee decreased successfully in favour of student",
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              _refreshData();
            }
            // NEW: Handle due date update completion
            if (state is InstallmentDueDateUpdatedState) {
              student = state.student;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Due date updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              _refreshData();
            }
          },

          builder: (context, state) {
            if (state is StudentLoadedState) {
              student = state.student;
            }
            if (state is StudentInstalmentLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is StudentLoadFailureState) {
              return Container(
                width: 400,
                height: 700,
                color: const Color(
                  0xFFFFFFFF,
                ), // Component Background (Replacing error green)
              );
            }

            if (state is AddedToPendingFee) {
              student = state.student;
              _refreshData();
            }

            return SafeArea(
              child: ResponsivePadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScreenHeader(
                      title: student.name,
                      trailing: IconButton(
                        onPressed: _refreshData,
                        icon: Icon(Icons.refresh_sharp),
                      ),
                    ),
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
                                  "Total Received: ${currencyFormat.format(student.paidAmount)}",
                              phoneSize: 16,
                              tabletSize: 20,
                            ),
                            const SizedBox(height: 8),
                            ResponsiveText(
                              text:
                                  "remaining: ${currencyFormat.format(student.totalFee - student.paidAmount)}",
                              phoneSize: 16,
                              tabletSize: 20,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: NeuCard(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: isTablet ? 40 : 20,
                                columns: const [
                                  DataColumn(label: Text("ID")),
                                  DataColumn(label: Text("Due Date")),
                                  DataColumn(label: Text("Total")),
                                  DataColumn(label: Text("Paid")),
                                  DataColumn(label: Text("Paid Date")),
                                  DataColumn(label: Text("Status")),
                                  DataColumn(label: Text("Action")),
                                  DataColumn(label: Text("edit due date")),
                                ],
                                rows:
                                    student.installments.map((installment) {
                                      index = index + 1;
                                      return _buildRow(
                                        installment,
                                        context,
                                        index,
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.trending_down,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Decrease Fee (Favour)",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          if (!isRefreshed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please refresh first"),
                              ),
                            );
                            return;
                          }

                          final remainingFee =
                              student.totalFee - student.paidAmount;
                          if (remainingFee <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No remaining fee to decrease"),
                              ),
                            );
                            return;
                          }

                          showDialog(
                            context: context,
                            builder:
                                (_) => DecreaseFeeModal(
                                  currentTotalFee: student.totalFee,
                                  currentPaidAmount: student.paidAmount,
                                  onDecrease: (favouredAmount) {
                                    context.read<FeeAdminBloc>().add(
                                      DecreaseFeeInFavourEvent(
                                        student: student,
                                        favouredAmount: favouredAmount,
                                      ),
                                    );
                                  },
                                ),
                          ).then((_) {
                            isRefreshed = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade600,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                          shadowColor: Colors.black54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child:
                          !widget.isDefaulter
                              ? ElevatedButton(
                                onPressed: () {
                                  if (isRefreshed) {
                                    if (student.totalFee - student.paidAmount ==
                                        0) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Can not add to defaulters complete fee paid",
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    final remainingFee =
                                        student.totalFee - student.paidAmount;
                                    context.read<FeeAdminBloc>().add(
                                      AddFeeDefaulterEvent(
                                        name: student.name,
                                        remaingFee: remainingFee,
                                        rollnum: student.groupId,
                                        studentId: student.id,
                                        group: student.groupId,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("please refresh first"),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  splashFactory: InkRipple.splashFactory,
                                  overlayColor: Colors.black.withOpacity(0.2),
                                  backgroundColor: const Color(
                                    0xFF8B0000,
                                  ), // Semantic Red kept
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Add to Defaulter",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Remove from Defaulter",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  if (thisTimepaidamount == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Pay installment to remove from defaulter",
                                        ),
                                      ),
                                    );
                                    return;
                                  } else {
                                    if (isRefreshed) {
                                      context.read<FeeAdminBloc>().add(
                                        RemoveStudentFromDefaultersEvent(
                                          groupId: student.groupId,
                                          paidAmount: thisTimepaidamount!,
                                          studentId: student.id,
                                          totalReaminingFeeForThisStudent:
                                              student.totalFee -
                                              student.paidAmount,
                                        ),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "student removed from defaulters",
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "please refresh first ",
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors
                                          .green
                                          .shade700, // Semantic Green kept
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors.black54,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  DataRow _buildRow(
    FeeInstallmentEntityClass installment,
    BuildContext context,
    int index,
  ) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    Color statusColor = Colors.green;

    if (installment.status == "pending") {
      statusColor = Colors.orange;
    } else if (installment.status == "Unpaid") {
      statusColor = Colors.red;
    }

    return DataRow(
      cells: [
        DataCell(Text(installment.title)),
        DataCell(Text(DateFormat('MMM dd, yyyy').format(installment.dueDate))),
        DataCell(Text(currencyFormat.format(installment.totalAmount))),
        DataCell(Text(currencyFormat.format(installment.paidAmount))),
        DataCell(
          Text(
            installment.paidDate != null
                ? DateFormat('MMM dd, yyyy').format(installment.paidDate!)
                : "Not paid yet",
            style: TextStyle(
              color:
                  installment.paidDate != null ? Colors.black87 : Colors.grey,
              fontStyle:
                  installment.paidDate != null
                      ? FontStyle.normal
                      : FontStyle.italic,
            ),
          ),
        ),
        DataCell(
          Text(
            installment.status,
            style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (installment.status == "Paid") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("This installment is already paid."),
                      ),
                    );
                    return;
                  }
                  showDialog(
                    context: context,
                    builder:
                        (_) => PayFeeModal(
                          totalFee: installment.totalAmount,
                          onPay: (amount, method, date) {
                            thisTimepaidamount = amount;
                            installment = installment;

                            context.read<FeeAdminBloc>().add(
                              AddToPendingFee2Event(
                                student: student,
                                instalment: installment,
                                paidAmount: amount,
                                paymentMethod: method,
                                paidDate: date,
                              ),
                            );
                          },
                        ),
                  ).then((_) {
                    isRefreshed = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Pay Fee",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => PayFeeModal(
                          totalFee: installment.totalAmount,
                          onPay: (amount, method, date) {
                            thisTimepaidamount = 0;
                            installment = installment;

                            context.read<FeeAdminBloc>().add(
                              AddToPendingFee2Event(
                                student: student,
                                instalment: installment,
                                paidAmount: 0,
                                paymentMethod: "Skipped",
                                paidDate: date,
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Installment skipped. Amount moved to next installment.",
                                ),
                              ),
                            );
                          },
                        ),
                  ).then((_) {
                    isRefreshed = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        // NEW: Due Date cell with edit button
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(DateFormat('MMM dd, yyyy').format(installment.dueDate)),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.edit_calendar, size: 18),
                color: const Color(0xFF3B82F6),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  if (!isRefreshed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please refresh first")),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    builder:
                        (_) => EditDueDateModal(
                          currentDueDate: installment.dueDate,
                          onUpdate: (newDueDate) {
                            context.read<FeeAdminBloc>().add(
                              UpdateInstallmentDueDateEvent(
                                studentId: student.id,
                                installmentId: installment.id,
                                newDueDate: newDueDate,
                              ),
                            );
                          },
                        ),
                  ).then((_) {
                    isRefreshed = false;
                  });
                },
                tooltip: 'Edit Due Date',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
