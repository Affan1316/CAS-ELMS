import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/full_screen_image.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/group_student_entity_class.dart';

class MemberCardContent extends StatelessWidget {
  final StudentFeatureGroupStudentEntityClass student;
  final String groupId;

  /// Callback to trigger fee check/navigation
  final void Function(StudentFeatureGroupStudentEntityClass) onViewFee;
  final bool isNavigateToAttendence;
  final bool isNavigateToWorkShopGraphPage;

  const MemberCardContent({
    super.key,
    required this.student,
    required this.groupId,
    required this.onViewFee,
    required this.isNavigateToAttendence,
    required this.isNavigateToWorkShopGraphPage,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Open full screen image on tap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => const FullScreenImage(
                      imagePath:
                          "assets/images/orignal_student_image_placeholder.jpg",
                    ),
              ),
            );
          },
          child: const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF5D5FEF),
            backgroundImage: AssetImage(
              "assets/images/orignal_student_image_placeholder.jpg",
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
                color: Color(0xFF374151),
              ),
              ResponsiveText(
                text: student.rollNum,
                phoneSize: 13,
                tabletSize: 15,
                color: Color(0xFF374151),
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5D5FEF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => onViewFee(student),
          child: ResponsiveText(
            text:
                isNavigateToAttendence
                    ? "View Attendence"
                    : isNavigateToWorkShopGraphPage
                    ? "workshop time"
                    : "View Fee",
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
