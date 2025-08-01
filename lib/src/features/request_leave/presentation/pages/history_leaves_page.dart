import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import '../widgets/leave_item_widget.dart';
import 'new_leave_page.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  List<Map<String, dynamic>> leaveItems = [
    {
      'type': 'Half Day Application',
      'date': 'Wed, 16 Dec',
      'category': 'Casual',
      'status': 'Awaiting',
      'statusColor': Colors.orange,
    },
    {
      'type': 'Full Day Application',
      'date': 'Mon, 28 Nov',
      'category': 'Sick',
      'status': 'Approved',
      'statusColor': Colors.green,
    },
    {
      'type': '3 Days Application',
      'date': 'Tue, 22 Nov - Fri, 25 Nov',
      'category': 'Casual',
      'status': 'Declined',
      'statusColor': Colors.red,
    },
    {
      'type': 'Full Day Application',
      'date': 'Wed, 02 Nov',
      'category': 'Sick',
      'status': 'Approved',
      'statusColor': Colors.green,
    },
  ];

  void _navigateToNewLeavePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewLeavePage()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        leaveItems.insert(0, {
          'type': result['cause']!,
          'date': result['fromDate']!,
          'category': 'N/A',
          'status': 'Awaiting',
          'statusColor': Colors.orange,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Leave Request',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      for (var item in leaveItems)
                        LeaveItemWidget(item: item),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: NeumorphicFloatingActionButton(
          onPressed: _navigateToNewLeavePage,
          style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: const NeumorphicBoxShape.circle(),
            depth: 4,
            color: Colors.blue,
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
