import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_home_page/presentation/widgets/buildStatItem.dart';

Widget buildStatsCard() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: const Color(
        0xFFE5E7EB,
      ), // Light gray background for neumorphic effect
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        // Dark shadow (bottom-right)
        BoxShadow(
          color: const Color(0xFFD1D5DB).withOpacity(0.8),
          blurRadius: 15,
          offset: const Offset(8, 8),
          spreadRadius: 1,
        ),
        // Light shadow (top-left)
        BoxShadow(
          color: Colors.white.withOpacity(0.9),
          blurRadius: 15,
          offset: const Offset(-8, -8),
          spreadRadius: 1,
        ),
        // Inner shadow for depth
        BoxShadow(
          color: const Color(0xFFD1D5DB).withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(4, 4),
          spreadRadius: 0,
          // inset: true, // Note: Flutter doesn't support inset directly, this is conceptual
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Semester',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '6 Courses • 18 Credits',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  buildStatItem('GPA', '3.8', Color(0xFF10B981)),
                  const SizedBox(width: 24),
                  buildStatItem('Attendance', '95%', Color(0xFF6366F1)),
                ],
              ),
            ],
          ),
        ),
        // Neumorphic icon container
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              // Dark shadow (bottom-right)
              BoxShadow(
                color: const Color(0xFFD1D5DB).withOpacity(0.8),
                blurRadius: 10,
                offset: const Offset(4, 4),
                spreadRadius: 1,
              ),
              // Light shadow (top-left)
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                blurRadius: 10,
                offset: const Offset(-4, -4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            Icons.school_rounded,
            color: const Color(0xFF667eea),
            size: 40,
          ),
        ),
      ],
    ),
  );
}
