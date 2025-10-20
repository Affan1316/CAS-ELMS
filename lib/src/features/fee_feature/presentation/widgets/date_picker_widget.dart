import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';

class DatePickerWidget extends StatefulWidget {
  final bool isStart;
  final FeeHistoryLoaded state;
  final List<String> monthNames;

  const DatePickerWidget({
    super.key,
    required this.isStart,
    required this.state,
    required this.monthNames,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime selected;
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;
  late int daysInMonth;

  @override
  void initState() {
    super.initState();
    selected =
        widget.isStart
            ? (widget.state.startDate ?? DateTime.now())
            : (widget.state.endDate ?? DateTime.now());
    selectedDay = selected.day;
    selectedMonth = selected.month;
    selectedYear = selected.year;
    daysInMonth = _daysInMonth(selectedYear, selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  widget.isStart ? Icons.calendar_today : Icons.event,
                  color: Colors.blue[600],
                ),
                const SizedBox(width: 8),
                Text(
                  widget.isStart ? 'Select Start Date' : 'Select End Date',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                _buildDateWheel(
                  context,
                  'Day',
                  daysInMonth,
                  selectedDay - 1,
                  (value) => setState(() {
                    selectedDay = value + 1;
                  }),
                  (index) => '${index + 1}',
                ),
                _buildDateWheel(
                  context,
                  'Month',
                  12,
                  selectedMonth - 1,
                  (value) {
                    setState(() {
                      selectedMonth = value + 1;
                      daysInMonth = _daysInMonth(selectedYear, selectedMonth);
                      if (selectedDay > daysInMonth) selectedDay = daysInMonth;
                    });
                  },
                  (index) => widget.monthNames[index],
                ),
                _buildDateWheel(context, 'Year', 20, selectedYear - 2020, (
                  value,
                ) {
                  setState(() {
                    selectedYear = 2020 + value;
                    daysInMonth = _daysInMonth(selectedYear, selectedMonth);
                    if (selectedDay > daysInMonth) selectedDay = daysInMonth;
                  });
                }, (index) => '${2020 + index}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final picked = DateTime(
                        selectedYear,
                        selectedMonth,
                        selectedDay,
                      );
                      context.read<FeeAdminBloc>().add(
                        UpdateSelectedDate(
                          startDate:
                              widget.isStart ? picked : widget.state.startDate,
                          endDate:
                              widget.isStart ? widget.state.endDate : picked,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Select'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateWheel(
    BuildContext context,
    String label,
    int itemCount,
    int selectedIndex,
    ValueChanged<int> onChanged,
    String Function(int) itemBuilder,
  ) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: ListWheelScrollView.useDelegate(
              controller: FixedExtentScrollController(
                initialItem: selectedIndex,
              ),
              itemExtent: 50,
              diameterRatio: 1.5,
              onSelectedItemChanged: onChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: itemCount,
                builder: (context, index) {
                  final isSelected = index == selectedIndex;
                  return Container(
                    alignment: Alignment.center,
                    decoration:
                        isSelected
                            ? BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            )
                            : null,
                    child: Text(
                      itemBuilder(index),
                      style: TextStyle(
                        fontSize: isSelected ? 18 : 16,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? Colors.blue[700] : Colors.grey[700],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _daysInMonth(int year, int month) {
    if (month == 2) {
      return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)
          ? 29
          : 28;
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30;
    }
    return 31;
  }
}
