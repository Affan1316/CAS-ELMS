import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/widgets/buildAdminFeatureCard.dart'
    show buildAdminFeatureCard;
import 'package:lucide_icons_flutter/lucide_icons.dart';

Widget buildAdminOverviewSection() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 12),
        Text(
          'Overview',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    ),
  );
}

Widget buildFeaturesGrid(
  AnimationController _animationController, {
  int? pendingLeaveCount,
}) {
  final features = [
    {
      'title': 'Add Instructor',
      'subtitle': 'Manage faculty',
      'icon': Icons.person_add_outlined,
    },
    {
      'title': 'Pay Fee',
      'subtitle': 'Payment portal',
      'icon': Icons.payment_outlined,
    },
    {
      'title': 'Fee Defaulter',
      'subtitle': 'View insights',
      'icon': Icons.analytics_outlined,
    },
    {
      'title': 'Create Group',
      'subtitle': 'Student groups',
      'icon': Icons.groups_outlined,
    },
    {
      'title': 'Add Student',
      'subtitle': 'Generate reports',
      'icon': Icons.person_add_alt_1_rounded,
    },
    {
      'title': 'Add Courses',
      'subtitle': 'Time management',
      'icon': Icons.schedule_outlined,
    },
    {
      'title': 'Inquiry detail',
      'subtitle': 'Time management',
      'icon': Icons.schedule_outlined,
    },
    {
      'title': 'Fee History',
      'subtitle': 'Time management',
      'icon': Icons.schedule_outlined,
    },
    {
      'title': 'Add Inquiry',
      'subtitle': 'Time management',
      'icon': Icons.schedule_outlined,
    },
    {
      'title': 'Add Fee Plan',
      'subtitle': 'Time management',
      'icon': LucideIcons.badgeDollarSign,
    },
    {
      'title': 'Installment Section',
      'subtitle': 'Time management',
      'icon': Icons.schedule_outlined,
    },
    {
      'title': 'Update Group Data',
      'subtitle': 'Time management',
      'icon': Icons.schedule_outlined,
    },
    {
      'title': 'Leave Management System',
      'subtitle': 'leave management',
      'icon': Icons.schedule_outlined,
    },
  ];

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final slideAnimation = Tween<Offset>(
              begin: Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(0, 1.0, curve: Curves.easeOutCubic),
              ),
            );

            int? badgeCount =
                (index == 12 &&
                        pendingLeaveCount != null &&
                        pendingLeaveCount > 0)
                    ? pendingLeaveCount
                    : null;
            if (index == 12) {
              print(
                '✨ Leave Approved card: badgeCount = $badgeCount, pendingLeaveCount = $pendingLeaveCount',
              );
            }

            return SlideTransition(
              position: slideAnimation,
              child: buildAdminFeatureCard(
                features[index],
                index,
                context,
                badgeCount: badgeCount, // ← NEW PARAMETER
              ),
            );
          },
        );
      },
    ),
  );
}
