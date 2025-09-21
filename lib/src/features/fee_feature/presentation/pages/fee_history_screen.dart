import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/payment_method_enum.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/sort_option_enum.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:intl/intl.dart';

class FeeHistoryScreen extends StatefulWidget {
  const FeeHistoryScreen({super.key});

  @override
  State<FeeHistoryScreen> createState() => _FeeHistoryScreenState();
}

class _FeeHistoryScreenState extends State<FeeHistoryScreen>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  bool _isFilterExpanded = false;

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
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _toggleFilter() {
    setState(() {
      _isFilterExpanded = !_isFilterExpanded;
      if (_isFilterExpanded) {
        _slideController.forward();
      } else {
        _slideController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFFEAF3FB); // light blue/grey
    return Scaffold(
      backgroundColor: background,
      appBar: _buildAppBar(context, Colors.deepPurple),
      body: BlocBuilder<FeeAdminBloc, FeeAdminState>(
        builder: (context, state) {
          if (state is FeeHistoryLoading) {
            return _buildLoadingState();
          } else if (state is FeeHistoryError) {
            return _buildErrorState(context, state.message);
          } else if (state is FeeHistoryLoaded) {
            return _buildLoadedState(context, state, background);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Color background) {
    return AppBar(
      elevation: 0,
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Fee History',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: AnimatedRotation(
            turns: _isFilterExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(Icons.tune),
          ),
          onPressed: _toggleFilter,
          tooltip: 'Filters',
        ),
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () => _refreshData(context),
          tooltip: 'Refresh',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading fee records...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _neoDecoration(radius: 50),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  () => context.read<FeeAdminBloc>().add(FetchTodayFees()),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
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

  Widget _buildLoadedState(
    BuildContext context,
    FeeHistoryLoaded state,
    Color background,
  ) {
    return RefreshIndicator(
      onRefresh: () async => _refreshData(context),
      child: CustomScrollView(
        slivers: [
          // Animated Filter Section
          SliverToBoxAdapter(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child:
                  _isFilterExpanded
                      ? SlideTransition(
                        position: _slideAnimation,
                        child: _buildFilterSection(context, state, background),
                      )
                      : const SizedBox.shrink(),
            ),
          ),

          // Summary Stats
          SliverToBoxAdapter(
            child: _buildSummarySection(context, state, background),
          ),

          // Content Header
          SliverToBoxAdapter(child: _buildContentHeader(context, state)),

          // Fee List
          state.fees.isEmpty
              ? SliverFillRemaining(
                child: _buildEmptyState(context, background),
              )
              : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final fee = state.fees[index];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 100 * index),
                      child: _buildFeeCard(context, fee, index, background),
                    );
                  }, childCount: state.fees.length),
                ),
              ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    FeeHistoryLoaded state,
    Color background,
  ) {
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
              Icon(
                Icons.filter_alt_rounded,
                color: Theme.of(context).colorScheme.primary,
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
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                  style: FilledButton.styleFrom(
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
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
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
                Icon(icon, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (onClear != null) ...[
                  const Spacer(),
                  GestureDetector(
                    onTap: onClear,
                    child: Icon(Icons.close, size: 16, color: Colors.grey[400]),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value != null ? _formatDate(value) : 'Select date',
              style: TextStyle(
                fontSize: 16,
                color: value != null ? Colors.black87 : Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(
    BuildContext context,
    FeeHistoryLoaded state,
    Color background,
  ) {
    if (state.fees.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: _neoDecoration(radius: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs ${state.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.blue[300],
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Records',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${state.fees.length}',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentHeader(BuildContext context, FeeHistoryLoaded state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Text(
            'Recent Transactions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => _showSortDialog(context, state),
            icon: Icon(state.sortOption.icon, size: 18),
            label: Text('Sort'),
            style: TextButton.styleFrom(foregroundColor: Colors.blue[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeCard(
    BuildContext context,
    FeeEntityClass fee,
    int index,
    Color background,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _neoDecoration(radius: 16),
      child: InkWell(
        onTap: () => _showFeeDetails(context, fee),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Payment method icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getPaymentMethodColor(
                    fee.paymentMethod,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getPaymentMethodIcon(fee.paymentMethod),
                  color: _getPaymentMethodColor(fee.paymentMethod),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Fee details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPaymentMethodLabel(fee.paymentMethod),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(fee.date),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    _buildStatusChip(fee.status),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rs ${fee.paidAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    final lower = status.toLowerCase();
    if (lower.contains('pending')) {
      backgroundColor = Colors.orange[100]!;
      textColor = Colors.orange[800]!;
      icon = Icons.pending;
    } else if (lower.contains('failed') || lower.contains('error')) {
      backgroundColor = Colors.red[100]!;
      textColor = Colors.red[800]!;
      icon = Icons.error_outline;
    } else {
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[800]!;
      icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color background) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: _neoDecoration(radius: 60),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No transactions found',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your date range or check back later.',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed:
                  () => context.read<FeeAdminBloc>().add(FetchTodayFees()),
              icon: const Icon(Icons.today),
              label: const Text('Show Today'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.read<FeeAdminBloc>().add(FetchTodayFees()),
      icon: const Icon(Icons.today),
      label: const Text('Today'),
      backgroundColor: Colors.blue[600],
      foregroundColor: Colors.white,
    );
  }

  // Helper methods

  Color _getPaymentMethodColor(PaymentMethodEnum method) {
    switch (method) {
      case PaymentMethodEnum.jazzCash:
        return Colors.red[600]!;
      case PaymentMethodEnum.easyPaisa:
        return Colors.green[600]!;
      case PaymentMethodEnum.ubl:
        return Colors.blue[600]!;
      case PaymentMethodEnum.cashPayment:
        return Colors.greenAccent;
    }
  }

  IconData _getPaymentMethodIcon(PaymentMethodEnum method) {
    switch (method) {
      case PaymentMethodEnum.jazzCash:
        return Icons.phone_android;
      case PaymentMethodEnum.easyPaisa:
        return Icons.account_balance_wallet;
      case PaymentMethodEnum.ubl:
        return Icons.account_balance;
      case PaymentMethodEnum.cashPayment:
        return Icons.account_balance_wallet_outlined;
    }
  }

  String _getPaymentMethodLabel(PaymentMethodEnum method) {
    switch (method) {
      case PaymentMethodEnum.jazzCash:
        return 'JazzCash';
      case PaymentMethodEnum.easyPaisa:
        return 'EasyPaisa';
      case PaymentMethodEnum.ubl:
        return 'UBL Bank';
      case PaymentMethodEnum.cashPayment:
        return 'Cash';
    }
  }

  void _refreshData(BuildContext context) {
    final bloc = context.read<FeeAdminBloc>();
    final state = bloc.state;
    if (state is FeeHistoryLoaded) {
      if (state.startDate != null && state.endDate != null) {
        bloc.add(FetchFeesByDateRange(state.startDate!, state.endDate!));
      } else {
        bloc.add(FetchTodayFees());
      }
    } else {
      bloc.add(FetchTodayFees());
    }
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

  void _showSortDialog(BuildContext context, FeeHistoryLoaded state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sort Options',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...SortOptionEnum.values.map(
                        (option) => ListTile(
                          leading: Icon(option.icon),
                          title: Text(option.title),
                          trailing:
                              state.sortOption == option
                                  ? Icon(Icons.check, color: Colors.blue[600])
                                  : null,
                          onTap: () {
                            context.read<FeeAdminBloc>().add(SortFees(option));
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showFeeDetails(BuildContext context, FeeEntityClass fee) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  _getPaymentMethodIcon(fee.paymentMethod),
                  color: _getPaymentMethodColor(fee.paymentMethod),
                ),
                const SizedBox(width: 8),
                const Text('Transaction Details'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  'Amount',
                  'Rs ${fee.paidAmount.toStringAsFixed(2)}',
                ),
                _buildDetailRow(
                  'Payment Method',
                  _getPaymentMethodLabel(fee.paymentMethod),
                ),
                _buildDetailRow('Status', fee.status),
                _buildDetailRow(
                  'Date',
                  DateFormat('dd MMM yyyy, hh:mm a').format(fee.date),
                ),
                _buildDetailRow(
                  'Transaction ID',
                  fee.id.isEmpty ? 'N/A' : fee.id,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _openDatePicker(
    BuildContext context,
    bool isStart,
    FeeHistoryLoaded state,
  ) {
    final bloc = context.read<FeeAdminBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        DateTime selected =
            isStart
                ? (state.startDate ?? DateTime.now())
                : (state.endDate ?? DateTime.now());
        int selectedDay = selected.day;
        int selectedMonth = selected.month;
        int selectedYear = selected.year;
        int daysInMonth = _daysInMonth(selectedYear, selectedMonth);

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
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
                          isStart ? Icons.calendar_today : Icons.event,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isStart ? 'Select Start Date' : 'Select End Date',
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
                              daysInMonth = _daysInMonth(
                                selectedYear,
                                selectedMonth,
                              );
                              if (selectedDay > daysInMonth)
                                selectedDay = daysInMonth;
                            });
                          },
                          (index) => monthNames[index],
                        ),
                        _buildDateWheel(
                          context,
                          'Year',
                          20,
                          selectedYear - 2020,
                          (value) {
                            setState(() {
                              selectedYear = 2020 + value;
                              daysInMonth = _daysInMonth(
                                selectedYear,
                                selectedMonth,
                              );
                              if (selectedDay > daysInMonth)
                                selectedDay = daysInMonth;
                            });
                          },
                          (index) => '${2020 + index}',
                        ),
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
                              bloc.add(
                                UpdateSelectedDate(
                                  startDate: isStart ? picked : state.startDate,
                                  endDate: isStart ? state.endDate : picked,
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
          },
        );
      },
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

  /// Neomorphic decoration helper
  BoxDecoration _neoDecoration({double radius = 20}) {
    return BoxDecoration(
      color: const Color(0xFFEAF3FB),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color(0xFFB0D4F1), // soft light-blue shadow
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
