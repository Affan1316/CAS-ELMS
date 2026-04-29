// =========================
// PRESENTATION LAYER (UI) - RESPONSIVE VERSION WITH PAYMENT SUMMARY
// DARK MODE FIX: All colors are now static (light mode) using Theme override
// =========================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_history_screen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/payment_summary_bottom_sheet.dart';

class DayWiseFeePage extends StatelessWidget {
  const DayWiseFeePage({super.key});

  /// Shows payment summary by fetching detailed fee data for the date range
  void _showPaymentSummaryForDateRange(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) async {
    debugPrint("========================================");
    debugPrint("_showPaymentSummaryForDateRange: START");
    debugPrint("Start Date: $startDate");
    debugPrint("End Date: $endDate");
    debugPrint("========================================");

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: Card(
              color: Colors.white, // FIX: static color
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading payment details...',
                      style: TextStyle(color: Colors.black87), // FIX
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    // Create a temporary bloc to fetch the detailed data
    final tempBloc = FeeAdminBloc();
    tempBloc.add(FetchFeesByDateRange(startDate, endDate));

    // Wait for the state to be loaded
    await for (final state in tempBloc.stream) {
      if (state is FeeHistoryLoaded) {
        // Close loading dialog
        if (context.mounted) Navigator.pop(context);

        // Show payment summary bottom sheet
        if (context.mounted) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => PaymentSummaryBottomSheet(state: state),
          );
        }

        tempBloc.close();
        break;
      } else if (state is FeeHistoryError) {
        // Close loading dialog
        if (context.mounted) Navigator.pop(context);

        // Show error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading payment details: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        tempBloc.close();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("========================================");
    debugPrint("DayWiseFeePage: build() called");
    debugPrint("========================================");

    // FIX: Wrap entire page in ThemeData.light() to force light mode colors
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        dialogTheme: DialogThemeData(backgroundColor: Colors.white),
      ),
      child: BlocProvider(
        create: (_) {
          debugPrint("DayWiseFeePage: Creating FeeAdminBloc");
          final bloc = FeeAdminBloc();
          final now = DateTime.now();

          // Get the first and last day of the current month
          final firstDayOfMonth = DateTime(now.year, now.month, 1);
          final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

          debugPrint(
            "DayWiseFeePage: Dispatching FetchDayWiseFees for current month",
          );
          debugPrint("Start Date (First day of month): $firstDayOfMonth");
          debugPrint("End Date (Last day of month): $lastDayOfMonth");

          bloc.add(FetchDayWiseFees(firstDayOfMonth, lastDayOfMonth));
          return bloc;
        },
        child: Builder(
          builder:
              (context) => Scaffold(
                backgroundColor: Colors.white, // FIX: static white background
                appBar: AppBar(
                  title: const Text('Day Wise Fee History'),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white, // FIX: ensure white icons/text
                  elevation: 2,
                  actions: [
                    // 🧹 One-time cleanup button — remove after running once
                    IconButton(
                      icon: const Icon(
                        Icons.cleaning_services,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                backgroundColor: Colors.white, // FIX
                                title: const Text(
                                  'Cleanup Duplicate Records',
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ), // FIX
                                ),
                                content: const Text(
                                  'This will scan fee history and remove any '
                                  'duplicate records. Run this once to fix duplicates.',
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ), // FIX
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      context.read<FeeAdminBloc>().add(
                                        const CleanupDuplicateFeeHistory(),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, // FIX
                                      foregroundColor: Colors.white, // FIX
                                    ),
                                    child: const Text('Cleanup'),
                                  ),
                                ],
                              ),
                        );
                      },
                      tooltip: 'Cleanup Duplicates',
                    ),
                    // Add Payment Summary button
                    BlocBuilder<FeeAdminBloc, FeeAdminState>(
                      builder: (context, state) {
                        if (state is DayWiseFeesLoaded &&
                            state.startDate != null &&
                            state.endDate != null) {
                          return IconButton(
                            icon: const Icon(
                              Icons.payment,
                              color: Colors.white,
                            ),
                            onPressed:
                                () => _showPaymentSummaryForDateRange(
                                  context,
                                  state.startDate!,
                                  state.endDate!,
                                ),
                            tooltip: 'Payment Summary',
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                body: BlocListener<FeeAdminBloc, FeeAdminState>(
                  listener: (context, state) {
                    if (state is FeeHistoryRepairComplete) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.repairedCount > 0
                                ? '✅ Removed ${state.repairedCount} duplicate records!'
                                : '✅ No duplicates found — all data is clean.',
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 5),
                        ),
                      );
                      // Auto-refresh after repair
                      final now = DateTime.now();
                      final firstDay = DateTime(now.year, now.month, 1);
                      final lastDay = DateTime(now.year, now.month + 1, 0);
                      context.read<FeeAdminBloc>().add(
                        FetchDayWiseFees(firstDay, lastDay),
                      );
                    }
                  },
                  child: ColoredBox(
                    color: Colors.white, // FIX: static white body background
                    child: Column(
                      children: [
                        _DateFilterBar(
                          onShowPaymentSummary: _showPaymentSummaryForDateRange,
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE0E0E0), // FIX: static divider color
                        ),
                        const Expanded(child: _FeeList()),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}

// ========================================
// DATE FILTER BAR - RESPONSIVE
// ========================================
class _DateFilterBar extends StatelessWidget {
  final void Function(BuildContext, DateTime, DateTime)? onShowPaymentSummary;

  const _DateFilterBar({this.onShowPaymentSummary});

  @override
  Widget build(BuildContext context) {
    debugPrint("_DateFilterBar: build() called");

    return BlocBuilder<FeeAdminBloc, FeeAdminState>(
      builder: (context, state) {
        debugPrint(
          "_DateFilterBar: BlocBuilder rebuilding with state: ${state.runtimeType}",
        );

        DateTime? startDate;
        DateTime? endDate;

        if (state is DayWiseFeesLoaded) {
          startDate = state.startDate;
          endDate = state.endDate;
          debugPrint("_DateFilterBar: Start Date = $startDate");
          debugPrint("_DateFilterBar: End Date = $endDate");
        } else {
          debugPrint(
            "_DateFilterBar: State is not DayWiseFeesLoaded, using null dates",
          );
        }

        // Responsive layout
        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 400;

            return Container(
              color: Colors.blue, // already static
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _DateChip(
                      label: 'Start Date',
                      date: startDate,
                      onTap:
                          () => _selectStartDate(context, startDate, endDate),
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 4 : 8,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: isSmallScreen ? 16 : 20,
                    ),
                  ),
                  Expanded(
                    child: _DateChip(
                      label: 'End Date',
                      date: endDate,
                      onTap: () => _selectEndDate(context, startDate, endDate),
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectStartDate(
    BuildContext context,
    DateTime? currentStartDate,
    DateTime? currentEndDate,
  ) async {
    debugPrint("========================================");
    debugPrint("_selectStartDate: Opening date picker");
    debugPrint("Current Start Date: $currentStartDate");
    debugPrint("Current End Date: $currentEndDate");
    debugPrint("========================================");

    final now = DateTime.now();
    final initialDate =
        currentStartDate != null && currentStartDate.isAfter(now)
            ? now
            : (currentStartDate ?? now);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: 'Select Start Date',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      debugPrint("_selectStartDate: Date picked = $picked");

      final endDate =
          (currentEndDate == null || currentEndDate.isBefore(picked))
              ? picked
              : currentEndDate;

      debugPrint("_selectStartDate: Dispatching FetchDayWiseFees");
      debugPrint("Start Date: $picked");
      debugPrint("End Date: $endDate");

      context.read<FeeAdminBloc>().add(FetchDayWiseFees(picked, endDate));
    } else {
      debugPrint("_selectStartDate: No date selected or context not mounted");
    }
  }

  Future<void> _selectEndDate(
    BuildContext context,
    DateTime? currentStartDate,
    DateTime? currentEndDate,
  ) async {
    debugPrint("========================================");
    debugPrint("_selectEndDate: Opening date picker");
    debugPrint("Current Start Date: $currentStartDate");
    debugPrint("Current End Date: $currentEndDate");
    debugPrint("========================================");

    final now = DateTime.now();
    final initialDate =
        currentEndDate != null && currentEndDate.isAfter(now)
            ? now
            : (currentEndDate ?? now);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: currentStartDate ?? DateTime(2020),
      lastDate: now,
      helpText: 'Select End Date',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      debugPrint("_selectEndDate: Date picked = $picked");

      final startDate =
          (currentStartDate == null || currentStartDate.isAfter(picked))
              ? picked
              : currentStartDate;

      debugPrint("_selectEndDate: Dispatching FetchDayWiseFees");
      debugPrint("Start Date: $startDate");
      debugPrint("End Date: $picked");

      context.read<FeeAdminBloc>().add(FetchDayWiseFees(startDate, picked));
    } else {
      debugPrint("_selectEndDate: No date selected or context not mounted");
    }
  }
}

// ========================================
// DATE CHIP WIDGET - RESPONSIVE
// ========================================
class _DateChip extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final bool isSmallScreen;

  const _DateChip({
    required this.label,
    required this.date,
    required this.onTap,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayText =
        date != null
            ? '${date!.day} ${_getMonthName(date!.month)} ${date!.year}'
            : 'Select Date';

    debugPrint("_DateChip: Displaying $label - $displayText");

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 12,
          vertical: isSmallScreen ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white, // FIX: static white
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.blue,
                fontSize: isSmallScreen ? 10 : 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: isSmallScreen ? 2 : 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 11 : 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 2 : 4),
                Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                  size: isSmallScreen ? 12 : 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

// ========================================
// FEE LIST WIDGET - RESPONSIVE
// ========================================
class _FeeList extends StatelessWidget {
  const _FeeList();

  @override
  Widget build(BuildContext context) {
    debugPrint("_FeeList: build() called");

    return BlocBuilder<FeeAdminBloc, FeeAdminState>(
      builder: (context, state) {
        debugPrint("========================================");
        debugPrint("_FeeList: BlocBuilder rebuilding");
        debugPrint("Current State: ${state.runtimeType}");
        debugPrint("========================================");

        if (state is FeeHistoryLoading) {
          debugPrint("_FeeList: Showing loading indicator");
          return const ColoredBox(
            color: Colors.white, // FIX
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 16),
                  Text(
                    'Loading fees...',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is DayWiseFeesLoaded) {
          debugPrint("_FeeList: State is DayWiseFeesLoaded");
          debugPrint(
            "_FeeList: Total days with fees = ${state.dayWiseFees.length}",
          );

          if (state.dayWiseFees.isEmpty) {
            debugPrint("_FeeList: No fees available for display");
            return ColoredBox(
              color: Colors.white, // FIX
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No fees found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (state.startDate != null && state.endDate != null) ...[
                        Text(
                          'for the selected date range',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatDate(state.startDate!)} to ${_formatDate(state.endDate!)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text(
                        'Try selecting a different date range',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Sort dates in descending order (most recent first)
          final sortedDates =
              state.dayWiseFees.keys.toList()..sort((a, b) => b.compareTo(a));

          debugPrint("_FeeList: Day-wise totals:");
          for (var date in sortedDates) {
            debugPrint(
              "  ${date.toString().split(' ')[0]}: ${state.dayWiseFees[date]}",
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 400;
              final isTablet = constraints.maxWidth >= 600;

              return ColoredBox(
                color:
                    Colors.white, // FIX: static white background for list area
                child: Column(
                  children: [
                    // Enhanced Summary Card with responsive layout
                    Container(
                      margin: EdgeInsets.all(isSmallScreen ? 8 : 12),
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: Colors.white, // FIX: static white
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0), // FIX: static grey
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child:
                          isTablet
                              ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _SummaryItem(
                                    icon: Icons.event_note,
                                    label: 'Total Days',
                                    value: '${sortedDates.length}',
                                    isSmallScreen: isSmallScreen,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 1,
                                    color: const Color(0xFFE0E0E0), // FIX
                                  ),
                                  _SummaryItem(
                                    icon: Icons.account_balance_wallet,
                                    label: 'Total Received',
                                    value: _formatCurrency(
                                      state.dayWiseFees.values.fold(
                                        0.0,
                                        (sum, amount) => sum + amount,
                                      ),
                                    ),
                                    isSmallScreen: isSmallScreen,
                                    isAmount: true,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 1,
                                    color: const Color(0xFFE0E0E0), // FIX
                                  ),
                                  _SummaryItem(
                                    icon: Icons.insights,
                                    label: 'Average/Day',
                                    value: _formatCurrency(
                                      state.dayWiseFees.values.fold(
                                            0.0,
                                            (sum, amount) => sum + amount,
                                          ) /
                                          sortedDates.length,
                                    ),
                                    isSmallScreen: isSmallScreen,
                                    isAmount: true,
                                  ),
                                ],
                              )
                              : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _SummaryItem(
                                        icon: Icons.event_note,
                                        label: 'Total Days',
                                        value: '${sortedDates.length}',
                                        isSmallScreen: isSmallScreen,
                                      ),
                                      _SummaryItem(
                                        icon: Icons.account_balance_wallet,
                                        label: 'Total Received',
                                        value: _formatCurrency(
                                          state.dayWiseFees.values.fold(
                                            0.0,
                                            (sum, amount) => sum + amount,
                                          ),
                                        ),
                                        isSmallScreen: isSmallScreen,
                                        isAmount: true,
                                      ),
                                    ],
                                  ),
                                  if (!isSmallScreen) ...[
                                    const SizedBox(height: 12),
                                    const Divider(
                                      color: Color(0xFFE0E0E0), // FIX
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 12),
                                    _SummaryItem(
                                      icon: Icons.insights,
                                      label: 'Average per Day',
                                      value: _formatCurrency(
                                        state.dayWiseFees.values.fold(
                                              0.0,
                                              (sum, amount) => sum + amount,
                                            ) /
                                            sortedDates.length,
                                      ),
                                      isSmallScreen: isSmallScreen,
                                      isAmount: true,
                                      centered: true,
                                    ),
                                  ],
                                ],
                              ),
                    ),
                    // List Header
                    _HeaderRow(isSmallScreen: isSmallScreen),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE0E0E0), // FIX: static color
                    ),
                    // List Items
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          top: isSmallScreen ? 8 : 12,
                          bottom: isSmallScreen ? 8 : 16,
                        ),
                        itemCount: sortedDates.length,
                        itemBuilder: (context, index) {
                          final date = sortedDates[index];
                          final amount = state.dayWiseFees[date]!;
                          final dateKey = _formatDateForDisplay(date);

                          debugPrint(
                            "_FeeList: Building row $index for $dateKey with amount $amount",
                          );

                          return _FeeListItem(
                            date: dateKey,
                            amount: amount,
                            dateTime: date,
                            isToday: _isToday(date),
                            isSmallScreen: isSmallScreen,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        if (state is FeeHistoryError) {
          debugPrint("_FeeList: Error state - ${state.message}");
          return ColoredBox(
            color: Colors.white, // FIX
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Oops! Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        final now = DateTime.now();
                        final firstDayOfMonth = DateTime(
                          now.year,
                          now.month,
                          1,
                        );
                        final lastDayOfMonth = DateTime(
                          now.year,
                          now.month + 1,
                          0,
                        );
                        context.read<FeeAdminBloc>().add(
                          FetchDayWiseFees(firstDayOfMonth, lastDayOfMonth),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        debugPrint("_FeeList: No data available (initial state)");
        return const ColoredBox(
          color: Colors.white, // FIX
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select a date range to view fees',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateForDisplay(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

// ========================================
// SUMMARY ITEM WIDGET
// ========================================
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isSmallScreen;
  final bool isAmount;
  final bool centered;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.isSmallScreen = false,
    this.isAmount = false,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.blue, size: isSmallScreen ? 16 : 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 11 : 12,
                color: Colors.black87, // FIX: static dark color
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 4 : 6),
        Text(
          isAmount ? 'PKR $value' : value,
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.black, // FIX: static black
          ),
        ),
      ],
    );
  }
}

// ========================================
// FEE LIST ITEM WIDGET - RESPONSIVE
// ========================================
class _FeeListItem extends StatelessWidget {
  final String date;
  final double amount;
  final DateTime dateTime;
  final bool isToday;
  final bool isSmallScreen;

  const _FeeListItem({
    required this.date,
    required this.amount,
    required this.dateTime,
    this.isToday = false,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12,
        vertical: isSmallScreen ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color:
            isToday
                ? const Color(0xFFE3F2FD) // FIX: static Colors.blue.shade50
                : Colors.white, // FIX: static white
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isToday
                  ? const Color(0xFF90CAF9) // FIX: static Colors.blue.shade200
                  : const Color(0xFFEEEEEE), // FIX: static Colors.grey.shade200
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        tileColor:
            Colors.transparent, // FIX: prevent ListTile from using theme color
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 6 : 8,
        ),
        leading: Container(
          width: isSmallScreen ? 40 : 48,
          height: isSmallScreen ? 40 : 48,
          decoration: BoxDecoration(
            color:
                isToday
                    ? Colors.blue
                    : const Color(
                      0xFFBBDEFB,
                    ), // FIX: static Colors.blue.shade100
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.calendar_today,
            color: isToday ? Colors.white : Colors.blue,
            size: isSmallScreen ? 20 : 24,
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                date,
                style: TextStyle(
                  fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                  fontSize: isSmallScreen ? 13 : 15,
                  color: Colors.black, // FIX: static dark color
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isToday) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'TODAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 9 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          'Received',
          style: TextStyle(
            color: const Color(0xFF757575), // FIX: static Colors.grey[600]
            fontSize: isSmallScreen ? 11 : 13,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'PKR ${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 16,
                    color:
                        isToday
                            ? Colors.blue
                            : Colors.black87, // FIX: static color
                  ),
                ),
                Text(
                  'View Details',
                  style: TextStyle(
                    color: const Color(
                      0xFF1565C0,
                    ), // FIX: static Colors.blue.shade700
                    fontSize: isSmallScreen ? 10 : 12,
                  ),
                ),
              ],
            ),
            SizedBox(width: isSmallScreen ? 4 : 8),
            Icon(
              Icons.arrow_forward_ios,
              size: isSmallScreen ? 14 : 16,
              color: const Color(0xFFBDBDBD), // FIX: static Colors.grey[400]
            ),
          ],
        ),
        onTap: () {
          debugPrint("========================================");
          debugPrint("_FeeListItem: Tapped on $date");
          debugPrint("_FeeListItem: DateTime = $dateTime");
          debugPrint("_FeeListItem: Navigating to FeeHistoryScreen");
          debugPrint("========================================");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      FeeHistoryScreen(startDate: dateTime, endDate: dateTime),
            ),
          );
        },
      ),
    );
  }
}

// ========================================
// HEADER ROW WIDGET - RESPONSIVE
// ========================================
class _HeaderRow extends StatelessWidget {
  final bool isSmallScreen;

  const _HeaderRow({this.isSmallScreen = false});

  @override
  Widget build(BuildContext context) {
    debugPrint("_HeaderRow: build() called");
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 10 : 12,
      ),
      color: const Color(0xFFEEEEEE), // FIX: static Colors.grey.shade200
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.black87, // FIX: static color
            ),
          ),
          Text(
            'Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.black87, // FIX: static color
            ),
          ),
          Text(
            'Amount',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.black87, // FIX: static color
            ),
          ),
        ],
      ),
    );
  }
}
