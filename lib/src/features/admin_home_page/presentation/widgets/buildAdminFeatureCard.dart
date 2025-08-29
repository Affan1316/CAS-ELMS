import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cas_app_main/src/features/add_inquiry/presentation/pages/add_instructor_screen.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/pages/AddInstructorScreen.dart';
import 'package:flutter_cas_app_main/src/features/creategroup/presentation/pages/create_group_page.dart';
import 'package:flutter_cas_app_main/src/features/enrollstudent/presentation/pages/enroll_student_page.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/page/fee_history_screen.dart';
import 'package:flutter_cas_app_main/src/features/feedefaulters/presentation/pages/fee_defaulters.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/pages/inquiry_page.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/pages/installment_page.dart';
import 'package:flutter_cas_app_main/src/features/pay_fee/presentation/pages/groups_page.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/pages/student_enrollment_screen.dart';
import 'package:flutter_cas_app_main/src/features/student%20in%20each%20group%20screen/presentation/page/students_screen.dart';
import 'package:flutter_cas_app_main/src/features/student%20in%20each%20group%20screen/presentation/page/update_group_screen.dart';
import 'package:flutter_cas_app_main/src/features/student%20in%20each%20group%20screen/presentation/widget/group_page.dart';

Widget buildAdminFeatureCard(
  Map<String, dynamic> feature,
  int index,
  BuildContext context,
) {
  return GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      _navigateToScreen(context, index);
    },
    child: Container(
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
    ),
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
          MaterialPageRoute(builder: (_) => AddInstructorPage()),
        );
        break;
      case 1: // Pay Fee
        print('Navigating to Pay Fee');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupsPage()),
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
      case 5: // Enroll Student
        print('Navigating to Student Enrollment');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EnrollStudentPage()),
        );
        break;
      case 6: // Add Inquiry
        print('Navigating to Inquiry Page');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => InquiryPage()),
        );
        break;
      case 7: // Fee History (but you're using AddInquiryScreen)
        print('Navigating to Add Inquiry');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FeeHistoryScreen()),
        );
        break;
      case 8: // Add Course
        print('Add Course - Not implemented yet');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddInquiryScreen()),
        );
        break;
      case 9: // Add Fee Plan
        print('Add Fee Plan - Not implemented yet');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupMainDetailPage()),
        );
        break;
      case 10: // Leaves Approved
        print('Leaves Approved - Not implemented yet');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Leaves Approved feature coming soon!')),
        );
        break;
      case 11: // Update Group Data
        print('Update Group Data - Not implemented yet');
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => CreateFeePlanPage()));
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
