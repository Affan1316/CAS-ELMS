import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/time_graph_page/presentation/bloc/time_graph_page_bloc.dart';

class _MyChoiceChip extends StatelessWidget {
  const _MyChoiceChip({
    required this.label,
    required this.value,
    required this.selectedFilter,
    this.onSelected,
  });
  final String label;
  final String value;
  final String selectedFilter;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedFilter == value,
      onSelected: onSelected,
      selectedColor: AppColors.primaryColor,
      labelStyle: TextStyle(
        color: selectedFilter == value ? Colors.white : const Color(0xFF3D4C5F),
      ),
      backgroundColor: const Color(0xFFE6E9EF),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFD1D9E6)),
      ),
    );
  }
}

class MyChoiceChips extends StatefulWidget {
  const MyChoiceChips({super.key, required this.selectedFilter});
  final String selectedFilter;

  @override
  State<MyChoiceChips> createState() => _MyChoiceChipsState();
}

class _MyChoiceChipsState extends State<MyChoiceChips> {
  DateTimeRange? _selectedDateRange;
  String selectedFilter = 'This Week';

  @override
  Widget build(BuildContext context) {
    // String selectedFilter = context.watch<TimeGraphPageBloc>().selectiveFilter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _MyChoiceChip(
            label: 'This Week',
            value: 'This Week',
            selectedFilter: selectedFilter,
            onSelected: (selected) {
              setState(() {
                context.read<TimeGraphPageBloc>().add(ThisWeekEvent());
                selectedFilter = 'This Week';
                if ('This Week' != 'Custom') {
                  _selectedDateRange = null;
                }
              });
            },
          ),
          _MyChoiceChip(
            label: 'Last Week',
            value: 'Last Week',
            selectedFilter: selectedFilter,
            onSelected: (value) {
              context.read<TimeGraphPageBloc>().add(const LastWeekEvent());
              setState(() {
                selectedFilter = 'Last Week';
                if ('Last Week' != 'Custom') {
                  _selectedDateRange = null;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
