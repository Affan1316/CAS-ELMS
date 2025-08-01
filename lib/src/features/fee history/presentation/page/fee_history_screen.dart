// ............................................................................

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/fee.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/payment_method.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/sort_option.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/bloc/fee_history_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/bloc/fee_history_event.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/bloc/fee_history_state.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/widget/fee_detail_row.dart';
import 'package:intl/intl.dart';

class FeeHistoryScreen extends StatelessWidget {
  const FeeHistoryScreen({super.key});
  static const List<String> monthNames = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fee History"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<FeeHistoryBloc>().add(ResetFilters()),
            tooltip: "Reset Filters",
          ),
        ],
      ),
      body: BlocBuilder<FeeHistoryBloc, FeeHistoryState>(
        builder: (context, state) {
          if (state is FeeHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FeeHistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading data",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed:
                        () => context.read<FeeHistoryBloc>().add(LoadFees()),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state is FeeHistoryLoaded) {
            return _buildLoadedState(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, FeeHistoryLoaded state) {
    return Column(
      children: [
        // Date Filter Section
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openDatePicker(context, true, state),
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    state.startDate != null
                        ? _formatDate(state.startDate)
                        : "Start Date",
                    style: TextStyle(
                      color:
                          state.startDate != null
                              ? Theme.of(context).primaryColor
                              : null,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color:
                          state.startDate != null
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openDatePicker(context, false, state),
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    state.endDate != null
                        ? _formatDate(state.endDate)
                        : "End Date",
                    style: TextStyle(
                      color:
                          state.endDate != null
                              ? Theme.of(context).primaryColor
                              : null,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color:
                          state.endDate != null
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Filter Info and Sort Button
        if (state.startDate != null || state.endDate != null)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Showing ${state.filteredFees.length} of ${state.allFees.length} records",
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                TextButton.icon(
                  onPressed:
                      () => context.read<FeeHistoryBloc>().add(
                        FilterByDate(startDate: null, endDate: null),
                      ),
                  icon: const Icon(Icons.filter_alt_off, size: 18),
                  label: const Text("Clear Filters"),
                  style: TextButton.styleFrom(foregroundColor: Colors.red[400]),
                ),
              ],
            ),
          ),
        // Sort Button
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _showSortOptions(context, state),
                icon: const Icon(Icons.sort, size: 18),
                label: Text("Sort: ${state.sortOption.title}"),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Fee Table
        Expanded(
          child:
              state.filteredFees.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No fees found",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Try adjusting your date filters",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed:
                              () => context.read<FeeHistoryBloc>().add(
                                ResetFilters(),
                              ),
                          icon: const Icon(Icons.refresh),
                          label: const Text("Reset Filters"),
                        ),
                      ],
                    ),
                  )
                  : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: DataTable(
                        columnSpacing: 12,
                        horizontalMargin: 16,
                        columns: const [
                          DataColumn(label: Text('Date')),
                          // Removed Fee ID column
                          // Removed Description column
                          DataColumn(label: Text('Amount'), numeric: true),
                          DataColumn(
                            label: Text('Payment Method'),
                          ), // Added Payment Method column
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows:
                            state.filteredFees.map((fee) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      DateFormat(
                                        'dd MMM yyyy',
                                      ).format(fee.date),
                                    ),
                                  ),
                                  // Removed Fee ID cell
                                  // Removed Description cell
                                  DataCell(
                                    Text(
                                      "₹${fee.amount.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Added Payment Method cell
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getPaymentMethodColor(
                                          fee.paymentMethod,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _getPaymentMethodText(
                                          fee.paymentMethod,
                                        ),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        fee.status,
                                        style: TextStyle(
                                          color: Colors.green[800],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    TextButton(
                                      onPressed:
                                          () => _showFeeDetails(context, fee),
                                      child: const Text("View Details"),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  ),
        ),
      ],
    );
  }

  // Helper method to get payment method text
  String _getPaymentMethodText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.jazzCash:
        return "JazzCash";
      case PaymentMethod.easyPaisa:
        return "EasyPaisa";
      case PaymentMethod.ubl:
        return "UBL";
    }
  }

  // Helper method to get payment method color
  Color _getPaymentMethodColor(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.jazzCash:
        return Colors.red[400]!;
      case PaymentMethod.easyPaisa:
        return Colors.green[400]!;
      case PaymentMethod.ubl:
        return Colors.blue[400]!;
    }
  }

  void _openDatePicker(
    BuildContext context,
    bool isStart,
    FeeHistoryLoaded state,
  ) {
    // Get reference to the BLoC before showing the modal
    final bloc = context.read<FeeHistoryBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) {
        DateTime selected =
            isStart
                ? (state.startDate ?? DateTime.now())
                : (state.endDate ?? DateTime.now());
        int selectedDay = selected.day;
        int selectedMonth = selected.month;
        int selectedYear = selected.year;
        int daysInMonth = _getDaysInMonth(selectedYear, selectedMonth);
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: 350,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      isStart ? "Select Start Date" : "Select End Date",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: Row(
                        children: [
                          // Day Picker
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: FixedExtentScrollController(
                                initialItem: (selectedDay - 1).clamp(
                                  0,
                                  daysInMonth - 1,
                                ),
                              ),
                              itemExtent: 40,
                              diameterRatio: 1.2,
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  selectedDay = value + 1;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: daysInMonth,
                                builder: (context, index) {
                                  bool isSelected = (index + 1) == selectedDay;
                                  return Center(
                                    child: Container(
                                      decoration:
                                          isSelected
                                              ? BoxDecoration(
                                                color: Colors.blue.withOpacity(
                                                  0.2,
                                                ),
                                                shape: BoxShape.circle,
                                              )
                                              : null,
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                          fontSize: isSelected ? 22 : 18,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color:
                                              isSelected
                                                  ? Theme.of(
                                                    context,
                                                  ).primaryColor
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Month Picker
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: FixedExtentScrollController(
                                initialItem: (selectedMonth - 1).clamp(0, 11),
                              ),
                              itemExtent: 40,
                              diameterRatio: 1.2,
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  selectedMonth = value + 1;
                                  daysInMonth = _getDaysInMonth(
                                    selectedYear,
                                    selectedMonth,
                                  );
                                  if (selectedDay > daysInMonth) {
                                    selectedDay = daysInMonth;
                                  }
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 12,
                                builder: (context, index) {
                                  bool isSelected =
                                      (index + 1) == selectedMonth;
                                  return Center(
                                    child: Container(
                                      decoration:
                                          isSelected
                                              ? BoxDecoration(
                                                color: Colors.blue.withOpacity(
                                                  0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              )
                                              : null,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        monthNames[index],
                                        style: TextStyle(
                                          fontSize: isSelected ? 22 : 18,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color:
                                              isSelected
                                                  ? Theme.of(
                                                    context,
                                                  ).primaryColor
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Year Picker
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: FixedExtentScrollController(
                                initialItem: (selectedYear - 2020).clamp(0, 19),
                              ),
                              itemExtent: 40,
                              diameterRatio: 1.2,
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  selectedYear = 2020 + value;
                                  daysInMonth = _getDaysInMonth(
                                    selectedYear,
                                    selectedMonth,
                                  );
                                  if (selectedDay > daysInMonth) {
                                    selectedDay = daysInMonth;
                                  }
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 20,
                                builder: (context, index) {
                                  bool isSelected =
                                      (2020 + index) == selectedYear;
                                  return Center(
                                    child: Container(
                                      decoration:
                                          isSelected
                                              ? BoxDecoration(
                                                color: Colors.blue.withOpacity(
                                                  0.2,
                                                ),
                                                shape: BoxShape.circle,
                                              )
                                              : null,
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        "${2020 + index}",
                                        style: TextStyle(
                                          fontSize: isSelected ? 22 : 18,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color:
                                              isSelected
                                                  ? Theme.of(
                                                    context,
                                                  ).primaryColor
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                            ),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              int maxDay = _getDaysInMonth(
                                selectedYear,
                                selectedMonth,
                              );
                              int validDay = selectedDay.clamp(1, maxDay);
                              final pickedDate = DateTime(
                                selectedYear,
                                selectedMonth.clamp(1, 12),
                                validDay,
                              );
                              if (isStart) {
                                bloc.add(
                                  FilterByDate(
                                    startDate: pickedDate,
                                    endDate: state.endDate,
                                  ),
                                );
                              } else {
                                if (state.startDate != null &&
                                    pickedDate.isBefore(state.startDate!)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "End date cannot be before start date.",
                                      ),
                                      backgroundColor: Colors.red[400],
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                bloc.add(
                                  FilterByDate(
                                    startDate: state.startDate,
                                    endDate: pickedDate,
                                  ),
                                );
                              }
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Select"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSortOptions(BuildContext context, FeeHistoryLoaded state) {
    // Get reference to the BLoC before showing the modal
    final bloc = context.read<FeeHistoryBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sort By",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ...SortOption.values.map((option) {
                return RadioListTile<SortOption>(
                  title: Text(option.title),
                  value: option,
                  groupValue: state.sortOption,
                  onChanged: (value) {
                    if (value != null) {
                      bloc.add(SortFees(value));
                    }
                    Navigator.pop(context);
                  },
                  activeColor: Theme.of(context).primaryColor,
                );
              }).toList(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showFeeDetails(BuildContext context, Fee fee) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fee Details",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  FeeDetailRow(
                    icon: Icons.receipt_long,
                    label: "Fee ID",
                    value: fee.id, // Still showing in details
                  ),
                  const SizedBox(height: 12),
                  FeeDetailRow(
                    icon: Icons.calendar_today,
                    label: "Date",
                    value: _formatDate(fee.date),
                  ),
                  const SizedBox(height: 12),
                  FeeDetailRow(
                    icon: Icons.description,
                    label: "Description",
                    value: fee.description, // Still showing in details
                  ),
                  const SizedBox(height: 12),
                  FeeDetailRow(
                    icon: Icons.currency_rupee,
                    label: "Amount",
                    value: "₹${fee.amount.toStringAsFixed(2)}",
                    isAmount: true,
                  ),
                  const SizedBox(height: 12),
                  FeeDetailRow(
                    icon: Icons.payment,
                    label: "Payment Method",
                    value: _getPaymentMethodText(fee.paymentMethod),
                    isPaymentMethod: true,
                    paymentMethod: fee.paymentMethod,
                  ),
                  const SizedBox(height: 12),
                  FeeDetailRow(
                    icon: Icons.check_circle,
                    label: "Payment Status",
                    value: fee.status,
                    isStatus: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('dd MMM yyyy').format(date);
  }

  int _getDaysInMonth(int year, int month) {
    if (month == 2) {
      return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)
          ? 29
          : 28;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    } else {
      return 31;
    }
  }
}
