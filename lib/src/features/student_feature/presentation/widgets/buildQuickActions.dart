import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cas_app_main/src/features/alumni_page/presentation/pages/year_selector_page.dart';
import 'package:flutter_cas_app_main/src/features/assignment_screen/presentation/pages/assignments_page.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/pages/list_of_request_leave_page.dart';
import 'package:flutter_cas_app_main/src/features/quiz/presentation/pages/quiz_home_screen.dart';
import 'package:flutter_cas_app_main/src/features/request_leave/presentation/pages/history_leaves_page.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_profile_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../my_student_attendence/presentation/student_adentence_page.dart';

Widget buildQuickActions(String studentName, String section) {
  final List<Map<String, dynamic>> studentFeatures = [
    {
      'title': 'My Assignments',
      'icon': Icons.assignment_rounded,
      'color': Color(0xFF6366F1),
      'count': '5 Due',
      'isUrgent': true,
      'screen': InterviewStagesPage(),
    },
    {
      'title': 'IQ Test',
      'icon': LucideIcons.brain,
      'color': Color(0xFF10B981),
      'count': '3.8 GPA',
      'isUrgent': false,
      'screen': QuizHomeScreen(),
    },
    {
      'title': 'Workshop Tracker',
      'icon': Icons.schedule_rounded,
      'color': Color(0xFF8B5CF6),
      'count': '6 Today',
      'isUrgent': false,
      'screen': LeaveScreen(),
    },
    {
      'title': 'Leave Request',
      'icon': Icons.event_note_rounded,
      'color': Color(0xFFF59E0B),
      'count': '2 Pending',
      'isUrgent': false,
      'screen': ListOfRequestLeaveScreen(section: section, name: studentName),
    },
    {
      'title': 'Library',
      'icon': Icons.library_books_rounded,
      'color': Color(0xFF06B6D4),
      'count': '2 Borrowed',
      'isUrgent': false,
      'screen': Container(child: Text("Not set yet")),
    },
    {
      'title': 'Study Groups',
      'icon': Icons.group_rounded,
      'color': Color(0xFFEF4444),
      'count': '3 Active',
      'isUrgent': false,
      'screen': Container(child: Text("Coming soon")),
    },
    {
      'title': 'Attendance',
      'icon': Icons.event_available_rounded,
      'color': Color(0xFF84CC16),
      'count': '95%',
      'isUrgent': false,
      'screen': StudentAdentencePage(),
    },
  ];

  return LayoutBuilder(
    builder: (context, constraints) {
      // Determine responsive layout parameters
      final screenWidth = constraints.maxWidth;
      final isTablet = screenWidth >= 600;
      final isDesktop = screenWidth >= 1200;

      // Responsive cross axis count
      int crossAxisCount;
      if (isDesktop) {
        crossAxisCount = 4;
      } else if (isTablet) {
        crossAxisCount = 3;
      } else {
        crossAxisCount = 2;
      }

      // Responsive spacing
      final spacing = isTablet ? 20.0 : 16.0;
      final horizontalPadding = isTablet ? 32.0 : 24.0;

      // Responsive aspect ratio (slightly wider on larger screens)
      final aspectRatio = isDesktop ? 1.1 : (isTablet ? 1.05 : 1.0);

      // Responsive font sizes
      final titleFontSize = isTablet ? 28.0 : 24.0;
      final cardTitleSize = isTablet ? 15.0 : 14.0;
      final countFontSize = isTablet ? 13.0 : 12.0;
      final iconSize = isTablet ? 70.0 : 64.0;
      final iconInnerSize = isTablet ? 36.0 : 32.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: isTablet ? 20 : 16,
            ),
            child: Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                letterSpacing: -0.5,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: aspectRatio,
              ),
              itemCount: studentFeatures.length,
              itemBuilder: (context, index) {
                final feature = studentFeatures[index];
                return _QuickActionCard(
                  title: feature['title'],
                  icon: feature['icon'],
                  color: feature['color'],
                  count: feature['count'],
                  isUrgent: feature['isUrgent'],
                  iconSize: iconSize,
                  iconInnerSize: iconInnerSize,
                  cardTitleSize: cardTitleSize,
                  countFontSize: countFontSize,
                  isTablet: isTablet,
                  onTap: () {
                    if (feature['screen'] != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => feature['screen'],
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
        ],
      );
    },
  );
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String count;
  final bool isUrgent;
  final double iconSize;
  final double iconInnerSize;
  final double cardTitleSize;
  final double countFontSize;
  final bool isTablet;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
    required this.isUrgent,
    required this.iconSize,
    required this.iconInnerSize,
    required this.cardTitleSize,
    required this.countFontSize,
    required this.isTablet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = isTablet ? 28.0 : 24.0;
    final padding = isTablet ? 24.0 : 20.0;
    final shadowOffset = isTablet ? 10.0 : 8.0;
    final shadowBlur = isTablet ? 18.0 : 15.0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD1D5DB).withOpacity(0.6),
            blurRadius: shadowBlur,
            offset: Offset(shadowOffset, shadowOffset),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: shadowBlur,
            offset: Offset(-shadowOffset, -shadowOffset),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon container with gradient background
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(iconSize * 0.28),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: iconInnerSize),
                ),
                SizedBox(height: isTablet ? 18 : 16),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: cardTitleSize,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
