import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/payment_summary_bottom_sheet.dart';

class FeeHistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isFilterExpanded;
  final VoidCallback onFilterToggle;
  final VoidCallback onRefresh;

  const FeeHistoryAppBar({
    super.key,
    required this.isFilterExpanded,
    required this.onFilterToggle,
    required this.onRefresh,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showPaymentMethodsBottomSheet(
    BuildContext context,
    FeeHistoryLoaded state,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PaymentSummaryBottomSheet(state: state),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Primary Color (Gradient Start) used for Header background
    final Color background = const Color(0xFF3B82F6);
    return AppBar(
      elevation: 0,
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Fee History',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: Colors.white, // Header Text must be White
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: AnimatedRotation(
            turns: isFilterExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(
              Icons.tune,
              color: Colors.white,
            ), // Header Icon White
          ),
          onPressed: onFilterToggle,
          tooltip: 'Filters',
        ),
        IconButton(
          icon: const Icon(
            Icons.refresh_rounded,
            color: Colors.white,
          ), // Header Icon White
          onPressed: onRefresh,
          tooltip: 'Refresh',
        ),
        // Add new button for payment methods summary
        BlocBuilder<FeeAdminBloc, FeeAdminState>(
          builder: (context, state) {
            return IconButton(
              icon: const Icon(
                Icons.payment,
                color: Colors.white,
              ), // Header Icon White
              onPressed:
                  state is FeeHistoryLoaded
                      ? () => _showPaymentMethodsBottomSheet(context, state)
                      : null,
              tooltip: 'Payment Summary',
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
