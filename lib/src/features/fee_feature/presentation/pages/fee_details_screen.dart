import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
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
        body: BlocConsumer<FeeAdminBloc, FeeAdminState>(
          listener: (context, state) {
            if (state is AddingFeeDefaulterCompleteState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Added to defaulters ")));
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
                color: const Color.fromARGB(255, 101, 232, 19),
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
                                  DataColumn(label: Text("title")),
                                  DataColumn(label: Text("Due Date")),
                                  DataColumn(label: Text("Total")),
                                  DataColumn(label: Text("Paid")),
                                  DataColumn(label: Text("Status")),
                                  DataColumn(label: Text("Action")),
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
                                  backgroundColor: const Color(0xFF8B0000),
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
                                  backgroundColor: Colors.green.shade700,
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
                        thisTimepaidamount = amount;
                        installment = installment;

                        context.read<FeeAdminBloc>().add(
                          AddToPendingFee2Event(
                            student: student,
                            instalment: installment,
                            paidAmount: amount,
                            paymentMethod: method,
                          ),
                        );
                      },
                    ),
              ).then((_) {
                isRefreshed = false;
              });
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

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/pay_fee_modal.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/screen_header.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
// import 'package:intl/intl.dart';

// class FeeDetailsScreen extends StatefulWidget {
//   final String studentId;
//   final String groupId;
//   final bool isDefaulter;

//   const FeeDetailsScreen({
//     super.key,
//     required this.studentId,
//     required this.groupId,
//     required this.isDefaulter,
//   });

//   @override
//   State<FeeDetailsScreen> createState() => _FeeDetailsScreenState();
// }

// class _FeeDetailsScreenState extends State<FeeDetailsScreen> {
//   late StudentFeeFeatureEntityClass student;
//   FeeInstallmentEntityClass? installment;
//   int index = -1;
//   bool isRefreshed = false;
//   double? thisTimepaidamount;
//   @override
//   void initState() {
//     super.initState();
//   }

//   void _refreshData() {
//     context.read<FeeAdminBloc>().add(
//       GetStudentInstalmentEvent(
//         studentId: widget.studentId,
//         groupId: widget.groupId,
//       ),
//     );
//     isRefreshed = true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isTablet = MediaQuery.of(context).size.width > 600;
//     final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');

//     return GradientBackground(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: BlocConsumer<FeeAdminBloc, FeeAdminState>(
//           listener: (context, state) {
//             if (state is AddingFeeDefaulterCompleteState) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text("Added to defaulters ")));
//             }
//           },
//           builder: (context, state) {
//             if (state is StudentLoadedState) {
//               student = state.student;
//             }
//             if (state is StudentInstalmentLoadingState) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (state is StudentLoadFailureState) {
//               return Container(
//                 width: 400,
//                 height: 700,
//                 color: const Color.fromARGB(255, 101, 232, 19),
//               );
//             }

//             if (state is AddedToPendingFee) {
//               student = state.student;
//               _refreshData();
//             }

//             return SafeArea(
//               child: ResponsivePadding(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ScreenHeader(
//                       title: student.name,
//                       trailing: IconButton(
//                         onPressed: _refreshData,
//                         icon: Icon(Icons.refresh_sharp),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     NeuCard(
//                       child: Padding(
//                         padding: EdgeInsets.all(isTablet ? 28 : 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ResponsiveText(
//                               text:
//                                   "Total Fee: ${currencyFormat.format(student.totalFee)}",
//                               phoneSize: 16,
//                               tabletSize: 20,
//                               weight: FontWeight.bold,
//                             ),
//                             const SizedBox(height: 8),
//                             ResponsiveText(
//                               text:
//                                   "Total Received: ${currencyFormat.format(student.paidAmount)}",
//                               phoneSize: 16,
//                               tabletSize: 20,
//                             ),
//                             const SizedBox(height: 8),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: NeuCard(
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: DataTable(
//                                 columnSpacing: isTablet ? 40 : 20,
//                                 columns: const [
//                                   DataColumn(
//                                     label: Text(
//                                       "title",
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                   DataColumn(
//                                     label: Text(
//                                       "Due Date",
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                   DataColumn(
//                                     label: Text(
//                                       "Total",
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                   DataColumn(
//                                     label: Text(
//                                       "Paid",
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                   DataColumn(
//                                     label: Text(
//                                       "Status",
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                   DataColumn(
//                                     label: Text(
//                                       "Action",
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                 ],
//                                 rows:
//                                     student.installments.map((installment) {
//                                       index = index + 1;
//                                       return _buildRow(
//                                         installment,
//                                         context,
//                                         index,
//                                       );
//                                     }).toList(),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Center(
//                       child:
//                           !widget.isDefaulter
//                               ? ElevatedButton(
//                                 onPressed: () {
//                                   if (isRefreshed) {
//                                     if (student.totalFee - student.paidAmount ==
//                                         0) {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(
//                                           content: Text(
//                                             "Can not add to defaulters complete fee paid",
//                                           ),
//                                         ),
//                                       );
//                                       return;
//                                     }
//                                     final remainingFee =
//                                         student.totalFee - student.paidAmount;
//                                     context.read<FeeAdminBloc>().add(
//                                       AddFeeDefaulterEvent(
//                                         name: student.name,
//                                         remaingFee: remainingFee,
//                                         rollnum: student.groupId,
//                                         studentId: student.id,
//                                         group: student.groupId,
//                                       ),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text("please refresh first"),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   splashFactory: InkRipple.splashFactory,
//                                   overlayColor: Colors.black.withOpacity(0.2),
//                                   backgroundColor: const Color(0xFF8B0000),
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 24,
//                                     vertical: 12,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   "Add to Defaulter",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               )
//                               : ElevatedButton.icon(
//                                 icon: const Icon(
//                                   Icons.check_circle_outline,
//                                   color: Colors.white,
//                                 ),
//                                 label: const Text(
//                                   "Remove from Defaulter",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   if (thisTimepaidamount == null) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                           "Pay installment to remove from defaulter",
//                                         ),
//                                       ),
//                                     );
//                                     return;
//                                   } else {
//                                     if (isRefreshed) {
//                                       context.read<FeeAdminBloc>().add(
//                                         RemoveStudentFromDefaultersEvent(
//                                           groupId: student.groupId,
//                                           paidAmount: thisTimepaidamount!,
//                                           studentId: student.id,
//                                           totalReaminingFeeForThisStudent:
//                                               student.totalFee -
//                                               student.paidAmount,
//                                         ),
//                                       );
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         const SnackBar(
//                                           content: Text(
//                                             "student removed from defaulters",
//                                           ),
//                                         ),
//                                       );
//                                     } else {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(
//                                           content: Text(
//                                             "please refresh first ",
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green.shade700,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 14,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14),
//                                   ),
//                                   elevation: 4,
//                                   shadowColor: Colors.black54,
//                                 ),
//                               ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   DataRow _buildRow(
//     FeeInstallmentEntityClass installment,
//     BuildContext context,
//     int index,
//   ) {
//     final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
//     Color statusColor = Colors.green;

//     if (installment.status == "pending") {
//       statusColor = Colors.orange;
//     } else if (installment.status == "Unpaid") {
//       statusColor = Colors.red;
//     }

//     return DataRow(
//       cells: [
//         DataCell(
//           Text(installment.title, style: TextStyle(color: Colors.black)),
//         ),
//         DataCell(
//           Text(
//             DateFormat('MMM dd, yyyy').format(installment.dueDate),
//             style: TextStyle(color: Colors.black),
//           ),
//         ),
//         DataCell(
//           Text(
//             currencyFormat.format(installment.totalAmount),
//             style: TextStyle(color: Colors.black),
//           ),
//         ),

//         DataCell(
//           Text(
//             currencyFormat.format(installment.paidAmount),
//             style: TextStyle(color: Colors.black),
//           ),
//         ),
//         DataCell(
//           Text(
//             installment.status,
//             style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
//           ),
//         ),
//         DataCell(
//           ElevatedButton(
//             onPressed: () {
//               showDialog(
//                 context: context,

//                 builder:
//                     (_) => PayFeeModal(
//                       totalFee: installment.totalAmount,
//                       onPay: (amount, method, date) {
//                         thisTimepaidamount = amount;
//                         installment = installment;

//                         context.read<FeeAdminBloc>().add(
//                           AddToPendingFee2Event(
//                             student: student,
//                             instalment: installment,
//                             paidAmount: amount,
//                             paymentMethod: method,
//                           ),
//                         );
//                       },
//                     ),
//               ).then((_) {
//                 isRefreshed = false;
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF3E206D),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text("Pay Fee", style: TextStyle(color: Colors.white)),
//           ),
//         ),
//       ],
//     );
//   }
// }
