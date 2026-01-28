// =========================
// PRESENTATION LAYER (UI) - RESPONSIVE VERSION
// =========================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_history_screen.dart';

class DayWiseFeePage extends StatelessWidget {
  const DayWiseFeePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("========================================");
    debugPrint("DayWiseFeePage: build() called");
    debugPrint("========================================");

    return BlocProvider(
      create: (_) {
        debugPrint("DayWiseFeePage: Creating FeeAdminBloc");
        final bloc = FeeAdminBloc();
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        debugPrint("DayWiseFeePage: Dispatching FetchDayWiseFees for today");
        debugPrint("Date: $today");

        bloc.add(FetchDayWiseFees(today, today));
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Day Wise Fee History'),
          backgroundColor: Colors.blue,
          elevation: 2,
        ),
        body: Column(
          children: [
            _DateFilterBar(),
            const Divider(height: 1, thickness: 1),
            Expanded(child: _FeeList()),
            // Bottom bar removed - data now shown in summary card
          ],
        ),
      ),
    );
  }
}

// ========================================
// DATE FILTER BAR - RESPONSIVE
// ========================================
class _DateFilterBar extends StatelessWidget {
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
              color: Colors.blue,
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

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select Start Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
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

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentEndDate ?? DateTime.now(),
      firstDate: currentStartDate ?? DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select End Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
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
          color: Colors.white,
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
          return const Center(
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
          );
        }

        if (state is DayWiseFeesLoaded) {
          debugPrint("_FeeList: State is DayWiseFeesLoaded");
          debugPrint(
            "_FeeList: Total days with fees = ${state.dayWiseFees.length}",
          );

          if (state.dayWiseFees.isEmpty) {
            debugPrint("_FeeList: No fees available for display");
            return Center(
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
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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

              return Column(
                children: [
                  // Enhanced Summary Card with responsive layout
                  Container(
                    margin: EdgeInsets.all(isSmallScreen ? 8 : 12),
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  color: Colors.grey.shade300,
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
                                  color: Colors.grey.shade300,
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
                                  Divider(
                                    color: Colors.grey.shade300,
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
                  const Divider(height: 1, thickness: 1),
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
              );
            },
          );
        }

        if (state is FeeHistoryError) {
          debugPrint("_FeeList: Error state - ${state.message}");
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
                      final today = DateTime(now.year, now.month, now.day);
                      context.read<FeeAdminBloc>().add(
                        FetchDayWiseFees(today, today),
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
          );
        }

        debugPrint("_FeeList: No data available (initial state)");
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select a date range to view fees',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
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
// SUMMARY ITEM WIDGET - NEW
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
                color: Colors.black87,
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
            color: Colors.black,
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
        color: isToday ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isToday ? Colors.blue.shade200 : Colors.grey.shade200,
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
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 6 : 8,
        ),
        leading: Container(
          width: isSmallScreen ? 40 : 48,
          height: isSmallScreen ? 40 : 48,
          decoration: BoxDecoration(
            color: isToday ? Colors.blue : Colors.blue.shade100,
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
            color: Colors.grey[600],
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
                    color: isToday ? Colors.blue : Colors.black87,
                  ),
                ),
                Text(
                  'View Details',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: isSmallScreen ? 10 : 12,
                  ),
                ),
              ],
            ),
            SizedBox(width: isSmallScreen ? 4 : 8),
            Icon(
              Icons.arrow_forward_ios,
              size: isSmallScreen ? 14 : 16,
              color: Colors.grey[400],
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
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.black87,
            ),
          ),
          Text(
            'Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.black87,
            ),
          ),
          Text(
            'Amount',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
