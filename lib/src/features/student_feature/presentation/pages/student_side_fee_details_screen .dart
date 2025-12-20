import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:animate_do/animate_do.dart';

import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';

import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';

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

  /// Builds neumorphic header with back button
  Widget _buildNeumorphicHeader(BuildContext context, String studentName) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;
    final titleFontSize = size.width * 0.07;
    final iconSize = size.width * 0.065;
    final backButtonPadding = size.width * 0.04;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding * 0.8,
        vertical: size.height * 0.02,
      ),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 8,
          intensity: 0.65,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(size.width * 0.06),
          ),
          color: Colors.white,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding * 1.2,
            vertical: size.height * 0.025,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width * 0.06),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.9),
                const Color(0xFFF5F5F5).withOpacity(0.8),
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              FadeInDown(
                delay: const Duration(milliseconds: 300),
                child: NeumorphicButton(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  style: NeumorphicStyle(
                    boxShape: const NeumorphicBoxShape.circle(),
                    depth: 6,
                    intensity: 0.8,
                    shape: NeumorphicShape.flat,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(backButtonPadding),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: iconSize,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.04),
              
              // Title Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      delay: const Duration(milliseconds: 400),
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.01,
                            height: titleFontSize * 0.65,
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(size.width * 0.01),
                            ),
                          ),
                          SizedBox(width: size.width * 0.025),
                          Flexible(
                            child: Text(
                              studentName,
                              style: TextStyle(
                                fontSize: titleFontSize * 0.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.008),
                    FadeInDown(
                      delay: const Duration(milliseconds: 500),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primaryDark,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          'Fee Details',
                          style: TextStyle(
                            fontSize: titleFontSize * 1.1,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Refresh Button
              FadeInDown(
                delay: const Duration(milliseconds: 600),
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(refreshController),
                  child: NeumorphicButton(
                    onPressed: () {
                      refreshController.forward(from: 0);
                      context.read<StudentFeatureBloc>().add(
                        GetStudentSideFeeEvent(studentId: widget.studentId),
                      );
                    },
                    style: NeumorphicStyle(
                      boxShape: const NeumorphicBoxShape.circle(),
                      depth: 6,
                      intensity: 0.8,
                      shape: NeumorphicShape.flat,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(backButtonPadding),
                    child: Icon(
                      Icons.refresh_rounded,
                      size: iconSize,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<StudentFeatureBloc, StudentFeatureState>(
          builder: (context, state) {
            // ---------- LOADING ----------
            if (state is StudentSideFeeLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            // ---------- ERROR ----------
            if (state is StudentFeeLoadFailureState) {
              return const Center(
                child: Text(
                  "Failed to load fee details.",
                  style: TextStyle(color: Colors.black),
                ),
              );
            }

            // ---------- SUCCESS ----------
            if (state is StudentFeeLoadedState) {
              final student = state.student;

              return Column(
                children: [
                  // Neumorphic Header with SafeArea
                  SafeArea(
                    bottom: false,
                    child: _buildNeumorphicHeader(context, student.name),
                  ),
                  
                  // Main Content
                  Expanded(
                    child: ResponsivePadding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingRowColor: WidgetStateProperty.all(
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
                                        DataColumn(
                                          label: Text(
                                            "Installment",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Due Date",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Total",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Paid",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Status",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
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
                  ),
                ],
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
            color: Colors.black,
          ),
        ),
        Text(
          format.format(amount),
          style: TextStyle(
            fontSize: 17,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
            color: highlight ? AppColors.primary : Colors.black,
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
        DataCell(
          Text(installment.title, style: const TextStyle(color: Colors.black)),
        ),
        DataCell(
          Text(
            DateFormat('MMM dd, yyyy').format(installment.dueDate),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        DataCell(
          Text(
            currencyFormat.format(installment.totalAmount),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        DataCell(
          Text(
            currencyFormat.format(installment.paidAmount),
            style: const TextStyle(color: Colors.black),
          ),
        ),
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