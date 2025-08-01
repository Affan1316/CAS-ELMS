import 'package:flutter/material.dart';

class GroupDetailPage extends StatelessWidget {
  final String groupName;
  final int totalStudents;
  final int totalDefaulters;
  final double installment;
  final double totalFee;
  final double concession;
  final double remainingFee;
  final List<Map<String, dynamic>> defaulters;

  const GroupDetailPage({
    super.key,
    required this.groupName,
    required this.totalStudents,
    required this.totalDefaulters,
    required this.installment,
    required this.totalFee,
    required this.concession,
    required this.remainingFee,
    required this.defaulters,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Size(:width, :height) = size;
    final double headerHeight = size.height * 0.3;
    final double cardWidth = size.width * 0.9;

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
                      Color(0xFF0E96C5), // Your primary blue
                      Color(0xFF4CC9F0), // Light Aqua Blue
                      Color(0xFF8E9EFF), // Soft Light Purple (not pink)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(bottom: 70),
                      child: Text(
                        '$groupName Group Details',
                        style: TextStyle(
                          fontSize: size.width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: width,
                height: height * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: width, height: 2),
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
                          _buildInfoRow("Total Fee", "PKR $totalFee"),
                          _buildInfoRow("Concession", "PKR $concession"),
                          _buildInfoRow("Remaining Fee", "PKR $remainingFee"),
                          const Divider(height: 22, thickness: 1),
                          _buildInfoRow("Total Students", "$totalStudents"),
                          _buildInfoRow("Defaulters", "$totalDefaulters"),
                          _buildInfoRow("Installment", "PKR $installment"),
                        ],
                      ),
                    ),
      
                    // 🔹 Defaulters Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        child: Text(
                          "Defaulters",
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
      
                    // 🔹 Defaulter Cards
                    SizedBox(
                      width: width,
                      height: height * 0.3,
                      child: ListView.builder(
                        itemCount: defaulters.length,
                        itemBuilder: (context, index) => defaulters
                            .map(
                              (student) => Padding(
                                padding: EdgeInsetsGeometry.only(left: 20, right: 20),
                                child: _buildDefaulterCard(
                                  context,
                                  name: student['name'],
                                  pending: student['pending'],
                                  width: cardWidth,
                                ),
                              ),
                            )
                            .toList()[index],
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
