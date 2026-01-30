import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';

class PaymentSummaryBottomSheet extends StatelessWidget {
  final FeeHistoryLoaded state;

  const PaymentSummaryBottomSheet({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600; // breakpoint
        final horizontalPadding = isTablet ? 40.0 : 24.0;
        final verticalPadding = isTablet ? 32.0 : 24.0;
        final fontScale = isTablet ? 1.2 : 1.0;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: screenWidth * 0.12,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.payment_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: isTablet ? 32 : 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Payment Methods Summary',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize:
                                (Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.fontSize ??
                                    20) *
                                fontScale,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Payment Method Cards
                  Wrap(
                    runSpacing: 12,
                    spacing: 12,
                    children: [
                      _buildPaymentMethodCard(
                        context,
                        'Cash Payments',
                        'assets/icons/cash.png',
                        Colors.green,
                        state.cashPaymentTotal,
                      ),
                      _buildPaymentMethodCard(
                        context,
                        'JazzCash',
                        'assets/icons/jazzcash.png',
                        Colors.red,
                        state.JazzCashTotal,
                      ),
                      _buildPaymentMethodCard(
                        context,
                        'UBL Bank',
                        'assets/icons/ubl.png',
                        Colors.blue,
                        state.UBLTotal,
                      ),
                      _buildPaymentMethodCard(
                        context,
                        'EasyPaisa',
                        'assets/icons/easypaisa.png',
                        Colors.green[600]!,
                        state.easyPaisaTotal,
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Total Row
                  Container(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.request_quote_outlined,
                          color: Colors.blue[700],
                          size: isTablet ? 28 : 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Grand Total',
                          style: TextStyle(
                            fontSize: 16 * fontScale,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Rs ${state.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18 * fontScale,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    String title,
    String assetPath,
    Color color,
    double amount,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                assetPath,
                // optional (remove if image is colored)
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs ${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
        ],
      ),
    );
  }
}
