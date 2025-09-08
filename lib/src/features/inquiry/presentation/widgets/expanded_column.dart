import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/entities/inquiry.dart';

class ExpandedColumn extends StatelessWidget {
  final Inquiry inquiry;

  const ExpandedColumn({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("👤 ${inquiry.studentName}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("📞 ${inquiry.phoneNo}"),
          Text("📧 ${inquiry.emailAddress}"),
          Text("👨 Father: ${inquiry.fatherName}"),
          Text("📚 Course: ${inquiry.courseIntersted}"),
          Text("👥 Group: ${inquiry.groupName}"),
          Text("⚧ Gender: ${inquiry.gender}"),
        ],
      ),
    );
  }
}
