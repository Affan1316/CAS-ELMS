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
          Text(
            "👤 ${inquiry.studentName}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "📞 ${inquiry.phoneNo}",
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            "📧 ${inquiry.emailAddress}",
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            "👨 Father: ${inquiry.fatherName}",
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            "📚 Course: ${inquiry.courseIntersted}",
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            "👥 Group: ${inquiry.groupName}",
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            "⚧ Gender: ${inquiry.gender}",
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
