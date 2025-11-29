// FILE: lib/src/features/admin_home_page/presentation/widgets/buildAdminOverviewSection.dart

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/widgets/buildAdminFeatureCard.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Widget buildAdminOverviewSection() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final size = MediaQuery.of(context).size;
      final isTablet = size.width >= 600;
      final isDesktop = size.width >= 1024;

      // Responsive padding and sizes
      final horizontalPadding = isDesktop ? 40.0 : (isTablet ? 32.0 : 24.0);
      final barWidth = isDesktop ? 5.0 : 4.0;
      final barHeight = isDesktop ? 28.0 : 24.0;
      final spacing = isDesktop ? 14.0 : 12.0;
      final fontSize = isDesktop ? 28.0 : (isTablet ? 26.0 : 24.0);

      return Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          children: [
            Container(
              width: barWidth,
              height: barHeight,
              decoration: BoxDecoration(
                color: Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: spacing),
            Text(
              'Overview',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// FILE: lib/src/features/admin_home_page/presentation/widgets/buildFeaturesGrid.dart

Widget buildFeaturesGrid(
  AnimationController animationController, {
  int? pendingLeaveCount,
}) {
  final features = [
    // {
    //   'title': 'Add Instructor',
    //   'subtitle': 'Manage faculty',
    //   'icon': Icons.person_add_outlined,
    // },
    {
      'title': 'Pay Fee',
      'subtitle': 'Payment portal',
      'icon': Icons.payment_outlined,
    },
    {
      'title': 'Fee Defaulter',
      'subtitle': 'Track pending fees',
      'icon': Icons.warning_amber_outlined,
    },
    {
      'title': 'Create Group',
      'subtitle': 'Student groups',
      'icon': Icons.group_add_outlined,
    },
    {
      'title': 'Add Student',
      'subtitle': 'Register students',
      'icon': Icons.person_add_alt_1_rounded,
    },
    {
      'title': 'Add Courses',
      'subtitle': 'Manage curriculum',
      'icon': Icons.book_outlined,
    },
    {
      'title': 'Inquiry detail',
      'subtitle': 'View inquiries',
      'icon': Icons.info_outline,
    },
    {
      'title': 'Fee History',
      'subtitle': 'Payment records',
      'icon': Icons.history_outlined,
    },
    {
      'title': 'Add Inquiry',
      'subtitle': 'New inquiries',
      'icon': Icons.contact_mail_outlined,
    },
    {
      'title': 'All Groups',
      'subtitle': 'View all groups',
      'icon': Icons.groups_outlined,
    },
    {
      'title': 'Workshop Time Tracker',
      'subtitle': 'Track workshop hours',
      'icon': Icons.timer_outlined,
    },
    // {
    //   'title': 'Update Group Data',
    //   'subtitle': 'Time management',
    //   'icon': Icons.schedule_outlined,
    // },
    {
      'title': 'Leave Management System',
      'subtitle': 'Manage absences',
      'icon': Icons.event_busy_outlined,
    },
  ];

  return LayoutBuilder(
    builder: (context, constraints) {
      final size = MediaQuery.of(context).size;
      final isTablet = size.width >= 600;
      final isDesktop = size.width >= 1024;

      // Responsive grid settings
      final horizontalPadding = isDesktop ? 40.0 : (isTablet ? 32.0 : 24.0);
      final crossAxisCount = isDesktop ? 4 : (isTablet ? 3 : 2);
      final crossAxisSpacing = isDesktop ? 20.0 : (isTablet ? 18.0 : 16.0);
      final mainAxisSpacing = isDesktop ? 20.0 : (isTablet ? 18.0 : 16.0);
      final childAspectRatio = isDesktop ? 0.85 : (isTablet ? 0.82 : 0.8);

      return Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final slideAnimation = Tween<Offset>(
                  begin: Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animationController,
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
                    badgeCount: badgeCount,
                  ),
                );
              },
            );
          },
        ),
      );
    },
  );
}
