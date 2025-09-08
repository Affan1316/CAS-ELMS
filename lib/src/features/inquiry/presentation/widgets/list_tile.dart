import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/entities/inquiry.dart';

class MyListTile extends StatelessWidget {
  final Inquiry inquiry;

  const MyListTile({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person, color: Colors.blue),
      title: Text(inquiry.studentName,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("${inquiry.courseIntersted} • ${inquiry.phoneNo}"),
    );
  }
}
