import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/super_admin_fee_bloc.dart';

class AllGroupsFeeCard extends StatefulWidget {
  const AllGroupsFeeCard({super.key, required this.names});
  final List<String> names;

  @override
  State<AllGroupsFeeCard> createState() => _AllGroupsFeeCardState();
}

class _AllGroupsFeeCardState extends State<AllGroupsFeeCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Business logic remains the same
    final summaries = context.read<SuperAdminFeeBloc>().getGroupSummaries;
    double totalAll = 0.0;
    double receivedAll = 0.0;
    int loadedCount = 0;

    summaries.forEach((k, v) {
      if (v != null) {
        totalAll += v.total;
        receivedAll += v.received;
        loadedCount++;
      }
    });

    double filteredTotal = 0.0;
    double filteredReceived = 0.0;
    for (final name in widget.names) {
      final s = summaries[name];
      if (s != null) {
        filteredTotal += s.total;
        filteredReceived += s.received;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
      elevation: 2, // Soft shadow to lift it off the white background
      shadowColor: const Color(0xFF6366F1).withOpacity(0.2), // Tinted shadow
      // M3 Light Primary Container (Soft Indigo/Blue tint)
      color: const Color(0xFFEEF2FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(
          color: Color(0xFFC7D2FE),
          width: 1.5,
        ), // Distinct border
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => setState(() => isExpanded = !isExpanded),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Fix: Keeps card height tight
              children: [
                isExpanded
                    ? _buildExpandedLayout(
                      totalAll,
                      receivedAll,
                      filteredTotal,
                      filteredReceived,
                      loadedCount,
                    )
                    : _buildCollapsedLayout(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.auto_graph_rounded,
          color: Color(0xFF4338CA),
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(
          'Tap to see All Groups',
          style: TextStyle(
            color: const Color(0xFF4338CA),
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.add_circle_outline_rounded,
          color: Color(0xFF4338CA),
          size: 16,
        ),
      ],
    );
  }

  Widget _buildExpandedLayout(
    double total,
    double received,
    double fTotal,
    double fReceived,
    int count,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Keeps the card height tight
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "All Groups - Totals",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Color(0xFF312E81), // Deep Navy Indigo
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4338CA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "$count Groups",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Global Totals Section
        _verticalMetricItem(
          "Groups Amount",
          _compactAmount(total),
          const Color(0xFF475569),
        ),
        _verticalMetricItem(
          "Amount Received",
          _compactAmount(received),
          const Color(0xFF059669),
        ),
        _verticalMetricItem(
          "Amount Remaining",
          _compactAmount(total - received),
          const Color(0xFFDC2626),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(color: Color(0xFFC7D2FE), height: 1, thickness: 1),
        ),

        // Filtered Results Section
        const Text(
          "FILTERED RESULTS",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6366F1),
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        _verticalMetricItem(
          "Filtered Groups",
          _compactAmount(fTotal),
          const Color(0xFF475569),
        ),
        _verticalMetricItem(
          "Filtered Amount Rec.",
          _compactAmount(fReceived),
          const Color(0xFF059669),
        ),
        _verticalMetricItem(
          "Filtered Amount Remaining.",
          _compactAmount(fTotal - fReceived),
          const Color(0xFFDC2626),
        ),
      ],
    );
  }

  // New vertical helper method to replace the old _dataItem
  Widget _verticalMetricItem(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

String _compactAmount(double value) {
  if (value.abs() >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
  if (value.abs() >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
  return value.toStringAsFixed(2);
}
