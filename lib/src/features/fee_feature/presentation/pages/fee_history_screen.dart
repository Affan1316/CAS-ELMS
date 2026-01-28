import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/fee_card_widget.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/fee_history_app_bar.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/fee_history_filter_section.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/fee_history_summary_section.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/loading_state_widget.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/sort_dialog_widget.dart';

class FeeHistoryScreen extends StatefulWidget {
  const FeeHistoryScreen({super.key, this.startDate, this.endDate});
  final DateTime? startDate;
  final DateTime? endDate;
  @override
  State<FeeHistoryScreen> createState() => _FeeHistoryScreenState();
}

class _FeeHistoryScreenState extends State<FeeHistoryScreen>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  bool _isFilterExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<FeeAdminBloc>().add(
      widget.startDate == null
          ? FetchTodayFees()
          : FetchFeesByDateRange(widget.startDate!, widget.endDate!),
    );
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

  Widget _buildLoadingState() {
    return const Center(child: LoadingStateWidget());
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
              style: const TextStyle(color: Color(0xFF374151), fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  () => context.read<FeeAdminBloc>().add(FetchTodayFees()),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
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
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No transactions found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your date range or check back later.',
              style: TextStyle(color: Color(0xFF374151), fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed:
                  () => context.read<FeeAdminBloc>().add(FetchTodayFees()),
              icon: const Icon(Icons.today),
              label: const Text('Show Today'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFFF8F9FD);
    return Scaffold(
      backgroundColor: background,
      appBar: FeeHistoryAppBar(
        isFilterExpanded: _isFilterExpanded,
        onFilterToggle: _toggleFilter,
        onRefresh: () => _refreshData(context),
      ),
      body: BlocConsumer<FeeAdminBloc, FeeAdminState>(
        listener: (context, state) {
          // Listener logic remains the same
        },
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<FeeAdminBloc>().add(FetchTodayFees()),
        icon: const Icon(Icons.today),
        label: const Text('Today'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
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
                        child: FeeHistoryFilterSection(
                          state: state,
                          background: background,
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ),

          // Summary Stats
          SliverToBoxAdapter(child: FeeHistorySummarySection(state: state)),

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
                      child: FeeCardWidget(
                        fee: fee,
                        index: index,
                        background: background,
                      ),
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

  Widget _buildContentHeader(BuildContext context, FeeHistoryLoaded state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => _showSortDialog(context, state),
            icon: Icon(state.sortOption.icon, size: 18),
            label: const Text('Sort'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context, FeeHistoryLoaded state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortDialogWidget(state: state),
    );
  }

  /// Neomorphic decoration helper
  BoxDecoration _neoDecoration({double radius = 20}) {
    return BoxDecoration(
      color: const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color(0xFFE5E7EB), // Border color acting as shadow
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
