import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/request_leave/presentation/pages/history_leaves_page.dart';
import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/pages/assignments_list_page.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/pages/list_of_request_leave_page.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/pages/quiz_home_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../my_student_attendence/presentation/student_adentence_page.dart';

Widget buildQuickActions(String studentName,String section) {
  final List<Map<String, dynamic>> studentFeatures = [
    {
      'title': 'My Assignments',
      'icon': Icons.assignment_rounded,
      'color': Color(0xFF6366F1),
      'count': '5 Due',
      'isUrgent': true,
      'screen': AssignmentsListPage(),
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
      'icon': Icons.schedule_rounded,
      'color': Color(0xFF8B5CF6),
      'count': '6 Today',
      'isUrgent': false,
      'screen': ListOfRequestLeaveScreen(section: section, name: studentName,),
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
    },
    {
      'title': 'Attendance',
      'icon': Icons.event_available_rounded,
      'color': Color(0xFF84CC16),
      'count': '95%',
      'isUrgent': false,
      'screen': StudentAdentencePage()
    },
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
      SizedBox(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          itemCount: studentFeatures.length,
          itemBuilder: (context, index) {
            final feature = studentFeatures[index];
            return Container(
              width: 120,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                // Neumorphic background - same as parent
                color: const Color(0xFFF0F2F5), // Light grey background
                borderRadius: BorderRadius.circular(20),
                // Neumorphic shadows
                boxShadow: [
                  // Dark shadow (bottom right)
                  BoxShadow(
                    color: const Color(0xFFD1D5DB).withOpacity(0.6),
                    blurRadius: 12,
                    offset: const Offset(6, 6),
                    spreadRadius: 0,
                  ),
                  // Light shadow (top left)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    blurRadius: 12,
                    offset: const Offset(-6, -6),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => feature['screen'],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Neumorphic icon container
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            // Matching background color
                            color: const Color(0xFFF0F2F5),
                            borderRadius: BorderRadius.circular(12),
                            // Inner neumorphic shadow for inset effect
                            boxShadow: [
                              // Inner dark shadow
                              BoxShadow(
                                color: const Color(0xFFD1D5DB).withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(3, 3),
                                spreadRadius: -2,
                              ),
                              // Inner light shadow
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                blurRadius: 6,
                                offset: const Offset(-3, -3),
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                          child: Icon(
                            feature['icon'],
                            color: feature['color'],
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          feature['title'],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          feature['count'],
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                feature['isUrgent']
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
