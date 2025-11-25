import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulter_entity.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulters_collective.dart';

class FeeDefaultersGroupDetailPage extends StatelessWidget {
  final FeeDefaultersCollective feeDefaultersCollective;
  final List<FeeDefaulterEntity> listOfFeeDefaulterEntity;
  final String groupName;

  const FeeDefaultersGroupDetailPage({
    super.key,
    required this.feeDefaultersCollective,
    required this.listOfFeeDefaulterEntity,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    final double headerHeight = height * 0.3;
    final double cardWidth = width * 0.9;

    // Safe access to potentially null fields
    final String remainingFeeText =
        'PKR ${feeDefaultersCollective.remaingFee.toString() ?? '0'}';
    final String totalDefaultersText =
        feeDefaultersCollective.total.toString() ?? '0';

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Stack(
          children: [
            // 🔹 Custom Gradient Header
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: headerHeight,
                width: width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0E96C5), // Primary blue
                      Color(0xFF4CC9F0), // Light Aqua Blue
                      Color(0xFF8E9EFF), // Soft Light Purple
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: Text(
                      '$groupName Group Details',
                      style: TextStyle(
                        fontSize: width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 🔹 White Bottom Section
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: width,
                height: height * 0.75,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: double.infinity, height: 2),

                    // 🔹 Summary Card
                    Container(
                      width: cardWidth,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow("Remaining Fee", remainingFeeText),
                          const Divider(height: 22, thickness: 1),
                          _buildInfoRow("Defaulters", totalDefaultersText),
                        ],
                      ),
                    ),

                    // 🔹 Section Title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Text(
                          "Defaulters",
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    // 🔹 Defaulters List
                    SizedBox(
                      width: width,
                      height: height * 0.3,
                      child:
                          listOfFeeDefaulterEntity.isEmpty
                              ? const Center(
                                child: Text(
                                  'No defaulters found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                              : ListView.builder(
                                itemCount: listOfFeeDefaulterEntity.length,
                                itemBuilder: (context, index) {
                                  final student =
                                      listOfFeeDefaulterEntity[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 6,
                                    ),
                                    child: _buildDefaulterCard(
                                      context,
                                      name: student.name ?? 'Unknown',
                                      pending:
                                          (student.remaingFee ?? 0).toDouble(),
                                      width: cardWidth,
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Info Row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Defaulter Card
  Widget _buildDefaulterCard(
    BuildContext context, {
    required String name,
    required double pending,
    required double width,
  }) {
    final double fontSize = MediaQuery.of(context).size.width * 0.04;

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Pending: PKR $pending",
                style: TextStyle(fontSize: fontSize * 0.9, color: Colors.grey),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.redAccent),
            ),
            child: const Text(
              "Not Paid",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
