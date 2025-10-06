import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/group_student_entity_class.dart';

class MemberCardContent extends StatelessWidget {
  final StudentFeatureGroupStudentEntityClass student;
  final String groupId;

  /// Callback to trigger fee check/navigation
  final void Function(StudentFeatureGroupStudentEntityClass) onViewFee;

  const MemberCardContent({
    super.key,
    required this.student,
    required this.groupId,
    required this.onViewFee,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF009688),
          child: Text(
            student.name.split(' ').map((e) => e[0]).take(2).join(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: isTablet ? 24 : 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                text: student.name,
                phoneSize: 16,
                tabletSize: 20,
                weight: FontWeight.w600,
              ),
              ResponsiveText(
                text: student.rollNum,
                phoneSize: 13,
                tabletSize: 15,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF009688),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => onViewFee(student),
          child: const ResponsiveText(
            text: "View Fee",
            phoneSize: 13,
            tabletSize: 16,
            color: Colors.white,
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
