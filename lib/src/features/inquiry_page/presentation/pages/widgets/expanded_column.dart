import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/pages/widgets/info_row.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/pages/widgets/model/inquiry.dart';

class ExpandedColumn extends StatelessWidget {
  const ExpandedColumn({super.key, required this.inquiry});
  final Inquiry inquiry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(icon: Icons.person, text: inquiry.name),
          InfoRow(icon: Icons.badge, text: 'ID: ${inquiry.id}'),
          InfoRow(icon: Icons.school, text: inquiry.course ?? '-'),
          InfoRow(icon: Icons.phone, text: inquiry.phone ?? '-'),
          InfoRow(icon: Icons.email, text: inquiry.email ?? '-'),
          InfoRow(
            icon: Icons.calendar_month,
            text:
                '${inquiry.date.day}/${inquiry.date.month}/${inquiry.date.year}.',
          ),
        ],
      ),
    );
  }
}
