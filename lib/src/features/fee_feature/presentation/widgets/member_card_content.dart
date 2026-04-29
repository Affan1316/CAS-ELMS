import 'dart:convert';

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

  /// Callback when student name is tapped (to show profile dialog)
  final VoidCallback? onNameTap;

  const MemberCardContent({
    super.key,
    required this.student,
    required this.groupId,
    required this.onViewFee,
    required this.isNavigateToAttendence,
    required this.isNavigateToWorkShopGraphPage,
    this.onNameTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Row(
      children: [
        // ── Avatar with gradient ring ─────────────────────────────────────────
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => FullScreenImage(
                      imageBase64String: student.profileImage,
                    ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF5D5FEF),
                  const Color(0xFF5D5FEF).withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5D5FEF).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage:
                  student.profileImage.isEmpty || student.profileImage == ''
                      ? const AssetImage("assets/images/student-male.png")
                      : MemoryImage(base64Decode(student.profileImage)),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // ── Name and ID Info ──────────────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onNameTap,
                child: Text(
                  student.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.badge_outlined,
                    size: 14,
                    color: const Color(0xFF5D5FEF).withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    student.rollNum,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // ── Action Button ─────────────────────────────────────────────────────
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5D5FEF),
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 12,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.all(
              Colors.white.withOpacity(0.1),
            ),
          ),
          onPressed: () => onViewFee(student),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isNavigateToAttendence
                    ? "Attendance"
                    : isNavigateToWorkShopGraphPage
                    ? "Workshop"
                    : "View Fee",
                style: TextStyle(
                  fontSize: isTablet ? 14 : 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios_rounded, size: 10),
            ],
          ),
        ),
      ],
    );
  }
}
