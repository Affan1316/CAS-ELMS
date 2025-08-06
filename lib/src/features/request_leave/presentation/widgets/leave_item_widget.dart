import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'status_chip.dart';

class LeaveItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  const LeaveItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Neumorphic(
        padding: const EdgeInsets.all(16),
        style: NeumorphicStyle(
          depth: 4,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['type'], style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text(item['date'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item['category'], style: const TextStyle(color: Colors.blueGrey)),
                ],
              ),
            ),
            StatusChip(text: item['status'], color: item['statusColor']),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
