import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';

class FeeHistorySummarySection extends StatelessWidget {
  final FeeHistoryLoaded state;

  const FeeHistorySummarySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    color: Color(0xFF374151), // Secondary Text
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs ${state.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF3B82F6), // Primary Color
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
            color: const Color(0xFFE5E7EB), // Border Color
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Records',
                style: TextStyle(
                  color: Color(0xFF374151), // Secondary Text
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${state.fees.length}',
                style: const TextStyle(
                  color: Color(0xFF3B82F6), // Primary Color
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

  /// Neomorphic decoration helper
  BoxDecoration _neoDecoration({double radius = 20}) {
    return BoxDecoration(
      color: const Color(0xFFFFFFFF), // Component Background
      borderRadius: BorderRadius.circular(radius),
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
