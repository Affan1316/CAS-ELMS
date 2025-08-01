
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/feedefaulters/presentation/pages/group_detail_page.dart';

class FeeDefaulters extends StatefulWidget {
  const FeeDefaulters({super.key});

  @override
  State<FeeDefaulters> createState() => _FeeDefaultersState();
}

class _FeeDefaultersState extends State<FeeDefaulters> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final Size(:width, :height) = size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: width,
                  height: height * 0.3,
                  decoration: BoxDecoration(
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
                  child: Center(
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(bottom: 70),
                      child: Text(
                        'Fee Defaulters',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Color(0xFF0E96C5),
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  Colors.white,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text('Select Month'),
                                  Icon(Icons.arrow_downward_rounded),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
      
                      SizedBox(
                        width: width,
                        height: height * 0.65,
                        child: ListView.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GroupDetailPage(
                                      groupName: 'F22',
                                      totalStudents: 60,
                                      totalDefaulters: 9,
                                      installment: 11,
                                      totalFee: 300000,
                                      concession: 0.0,
                                      remainingFee: 90000,
                                      defaulters: [
                                        {'name' : 'Ali khan', 'pending' : 20000.0},
                                        {'name' : 'Faiq', 'pending' : 9000.0},
                                        {'name' : 'Wahab', 'pending' : 10000.0},
                                        {'name' : 'Umar', 'pending' : 4000.0}
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: GroupCard(
                                groupName: 'F22',
                                totalStudents: 26,
                                totalDefaulters: 9,
                                installment: 11,
                                width: width * 0.8,
                              ),
                            ),
                          ),
                          itemCount: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String groupName;
  final int totalStudents;
  final int totalDefaulters;
  final int installment;
  final double width;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.totalStudents,
    required this.totalDefaulters,
    required this.installment,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // 🔹 Makes height adjust to content
        children: [
          // Group Name
          Text(
            groupName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),

          const SizedBox(height: 6),

          // Total Students
          Text(
            "Total Students: $totalStudents",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),

          const SizedBox(height: 4),

          // Total Defaulters
          Text(
            "Total Defaulters: $totalDefaulters",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          // Installment badge aligned to right
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Installments $installment",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
