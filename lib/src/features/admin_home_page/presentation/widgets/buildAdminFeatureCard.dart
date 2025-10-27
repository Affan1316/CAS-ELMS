import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/presentation/pages/add_course_page.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/pages/AddInstructorScreen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_history_screen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/groups_list_screen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_defaulters.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/pages/create_group_page.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/pages/read_group_page.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/pages/add_inquiry_page.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/pages/inquiry_detail_page.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/pages/admin_leave_request_management.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_enrollment_screen.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/pages/super_admin_fee_notifications_screen.dart';
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/pages/workshop_time_tracker.dart';
import 'package:badges/badges.dart' as badges;

Widget buildAdminFeatureCard(
  Map<String, dynamic> feature,
  int index,
  BuildContext context, {
  int? badgeCount,
}) {
  Widget cardContent = Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Color(0xFFF3F4F6), width: 1),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF000000).withOpacity(0.06),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
        BoxShadow(
          color: Color(0xFF000000).withOpacity(0.04),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE2E8F0), width: 1),
            ),
            child: Icon(
              feature['icon'] as IconData,
              size: 32,
              color: Color(0xFF3B82F6),
            ),
          ),
          SizedBox(height: 16),
          Text(
            feature['title'] as String,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            feature['subtitle'] as String,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  // Wrap with badge if badgeCount is provided and greater than 0
  if (badgeCount != null && badgeCount > 0) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _navigateToScreen(context, index);
      },
      child: badges.Badge(
        badgeContent: Text(
          badgeCount.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        badgeStyle: badges.BadgeStyle(
          badgeColor: Colors.red,
          padding: EdgeInsets.all(11),
          borderRadius: BorderRadius.circular(16),
          elevation: 12,
        ),
        position: badges.BadgePosition.topEnd(top: -10, end: -5),
        child: cardContent,
      ),
    );
  }

  return GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      _navigateToScreen(context, index);
    },
    child: cardContent,
  );
}

void _navigateToScreen(BuildContext context, int index) {
  print('Navigation triggered for index: $index');

  try {
    switch (index) {
      case 0: // Add Instructor
        print('Navigating to Add Instructor');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SuperAdminFeeNotificationsScreen()),
        );
        break;
      case 1: // Pay Fee
        print('Navigating to Pay Fee');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupsListScreen()),
        );
        break;
      case 2: // Fee Defaulter
        print('Navigating to Fee Defaulter');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FeeDefaulters()),
        );
        break;
      case 3: // Create Group
        print('Navigating to Create Group');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CreateGroupPage()),
        );
        break;
      case 4: // Add Student (but you're using EnrollStudentPage)
        print('Navigating to Enroll Student');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StudentEnrollmentScreen()),
        );
        break;
      case 5: // Add Courses
        print('Navigating to Student Enrollment');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddCoursesPage()),
        );
        break;
      case 6: // Inquiry Details
        print('Navigating to Inquiry Page');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => InquiryDetailPage()),
        );
        break;
      case 7: // Fee History (but you're using AddInquiryScreen)
        print('Navigating to Add Inquiry');
        // context.read<FeeAdminBloc>().add(FetchTodayFees());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const FeeHistoryScreen();
            },
          ),
        );
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder:
        //         (_) => BlocProvider(
        //           create:
        //               (_) =>
        //                   FeeHistoryBloc(repository: FeeHistoryRepository())
        //                     ..add(FetchTodayFees()),
        //           child: const FeeHistoryScreen(),
        //         ),
        //   ),
        // );

        break;
      case 8: // Add Inquiry
        print('Add Course - Not implemented yet');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddInquiryPage()),
        );
        break;
      case 9: // Add Fee Plan
        print('Add Fee Plan - Not implemented yet');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupMainDetailPage()),
        );
        break;
      case 10: 
        print('Leaves Approved - Not implemented yet');
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => WorkshopTimeTracker()));
        break;
      case 11: // Update Group Data
        print('Update Group Data - Not implemented yet');
        // Navigator.of(
        //   context,
        // ).push(MaterialPageRoute(builder: (context) => CreateFeePlanPage()));
        break;
      case 12: // Leaves Approved
        print('Navigating to Admin Leave Management System');
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AdminLeaveRequestManagement()));
      break;
      default:
        print('Invalid index: $index');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Feature not available')));
        break;
    }
  } catch (e) {
    print('Navigation error: $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigation error: $e')));
  }
}
