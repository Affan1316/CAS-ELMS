import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/date_picker_widget.dart';
import 'package:intl/intl.dart';

class FeeHistoryFilterSection extends StatelessWidget {
  final FeeHistoryLoaded state;
  final Color background;

  const FeeHistoryFilterSection({
    super.key,
    required this.state,
    required this.background,
  });

  static const List<String> monthNames = [
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
    final bloc = context.read<FeeAdminBloc>();
    final canSearch =
        state.startDate != null &&
        state.endDate != null &&
        !state.endDate!.isBefore(state.startDate!);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: _neoDecoration(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.filter_alt_rounded,
                color: Color(0xFF3B82F6), // Primary Gradient Start
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Filter by Date Range',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- Date Inputs ---
          Row(
            children: [
              Expanded(
                child: _buildDateInput(
                  context,
                  'Start Date',
                  state.startDate,
                  Icons.calendar_today_outlined,
                  () => _openDatePicker(context, true, state),
                  state.startDate != null
                      ? () => bloc.add(
                        UpdateSelectedDate(
                          startDate: null,
                          endDate: state.endDate,
                        ),
                      )
                      : null,
                  background,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateInput(
                  context,
                  'End Date',
                  state.endDate,
                  Icons.event_outlined,
                  () => _openDatePicker(context, false, state),
                  state.endDate != null
                      ? () => bloc.add(
                        UpdateSelectedDate(
                          startDate: state.startDate,
                          endDate: null,
                        ),
                      )
                      : null,
                  background,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 16),

          // --- Quick Filters ---
          Text(
            'Quick Ranges',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildQuickFilterChip('Today', Icons.today, () {
                bloc.add(FetchTodayFees());
              }),
              _buildQuickFilterChip('Last 7 days', Icons.date_range, () {
                _applyQuickRange(context, 7);
              }),
              _buildQuickFilterChip('Last 30 days', Icons.calendar_month, () {
                _applyQuickRange(context, 30);
              }),
              _buildQuickFilterChip(
                'This Month',
                Icons.calendar_view_month,
                () {
                  final now = DateTime.now();
                  final start = DateTime(now.year, now.month, 1);
                  final end = DateTime(now.year, now.month + 1, 0);
                  _applyDateRange(context, start, end);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 16),

          // --- Action Buttons ---
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed:
                      canSearch
                          ? () => bloc.add(
                            FetchFeesByDateRange(
                              state.startDate!,
                              state.endDate!,
                            ),
                          )
                          : null,
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF3B82F6,
                    ), // Primary Gradient Start
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    bloc.add(
                      UpdateSelectedDate(startDate: null, endDate: null),
                    );
                    bloc.add(FetchTodayFees());
                  },
                  icon: const Icon(Icons.clear, color: Color(0xFF374151)),
                  label: const Text(
                    'Clear',
                    style: TextStyle(color: Color(0xFF374151)),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),

          // --- Validation Message ---
          if (!canSearch && (state.startDate != null || state.endDate != null))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.startDate != null &&
                              state.endDate != null &&
                              state.endDate!.isBefore(state.startDate!)
                          ? 'End date must be after start date'
                          : 'Select both dates to search',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterChip(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
      label: Text(label, style: const TextStyle(color: Color(0xFF374151))),
      onPressed: onTap,
      backgroundColor: const Color(0xFFF8F9FD), // App Background
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      side: const BorderSide(color: Color(0xFFE5E7EB)),
    );
  }

  Widget _buildDateInput(
    BuildContext context,
    String label,
    DateTime? value,
    IconData icon,
    VoidCallback onTap,
    VoidCallback? onClear,
    Color background,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _neoDecoration(radius: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: const Color(0xFF6B7280),
                ), // Input Icons
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280), // Input Icons/Label Color
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (onClear != null) ...[
                  const Spacer(),
                  GestureDetector(
                    onTap: onClear,
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFF9CA3AF),
                    ), // Placeholder Color
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value != null ? _formatDate(value) : 'Select date',
              style: TextStyle(
                fontSize: 16,
                color:
                    value != null
                        ? const Color(0xFF111827)
                        : const Color(
                          0xFF9CA3AF,
                        ), // Primary Text vs Placeholder
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyQuickRange(BuildContext context, int days) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days - 1));
    _applyDateRange(context, start, now);
  }

  void _applyDateRange(BuildContext context, DateTime start, DateTime end) {
    final bloc = context.read<FeeAdminBloc>();
    bloc.add(
      UpdateSelectedDate(
        startDate: DateTime(start.year, start.month, start.day),
        endDate: DateTime(end.year, end.month, end.day),
      ),
    );
    bloc.add(
      FetchFeesByDateRange(
        DateTime(start.year, start.month, start.day),
        DateTime(end.year, end.month, end.day),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _openDatePicker(
    BuildContext context,
    bool isStart,
    FeeHistoryLoaded state,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DatePickerWidget(
            isStart: isStart,
            state: state,
            monthNames: monthNames,
          ),
    );
  }

  /// Neomorphic decoration helper
  BoxDecoration _neoDecoration({double radius = 20}) {
    return BoxDecoration(
      color: const Color(0xFFFFFFFF), // Component Background
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: const Color(0xFFE5E7EB)), // Border
      boxShadow: const [
        BoxShadow(
          color: Color(0xFFE5E7EB), // Very Light Gray shadow
          offset: Offset(4, 4),
          blurRadius: 8,
        ),
        BoxShadow(
          color: Colors.white, // highlight
          offset: Offset(-4, -4),
          blurRadius: 8,
        ),
      ],
    );
  }
}
