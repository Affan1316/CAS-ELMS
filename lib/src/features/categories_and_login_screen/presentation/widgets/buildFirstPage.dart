import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildRoleCard.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildStudentAvatar.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildTeacherAvatar.dart';

Widget buildFirstPage(BuildContext context, OnboardingInitial state) {
  return Stack(
    children: [
      // Background with curved bottom
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 216, 240, 239),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
      ),

      // Content
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Title
            SlideInWidget(
              delay: const Duration(milliseconds: 200),
              begin: const Offset(0, -0.5),
              child: const Text(
                'Join CAS as a...',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Subtitle
            SlideInWidget(
              delay: const Duration(milliseconds: 400),
              begin: const Offset(0, -0.5),
              child: const Text(
                'Create and sell courses as a Teacher or\nEnhance courses and learn as a Student.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),
            ),

            const SizedBox(height: 60),

            // Role selection cards with exact positioning
            Expanded(
              child: Stack(
                children: [
                  // Teacher card - positioned higher and left
                  Positioned(
                    top: 50,
                    left: 10,
                    child: SlideInWidget(
                      delay: const Duration(milliseconds: 600),
                      begin: const Offset(-1, 0),
                      child: buildRoleCard(
                        context,
                        'Teacher',
                        buildTeacherAvatar(),
                        Colors.teal,
                        state.selectedRole == 'Teacher',
                      ),
                    ),
                  ),

                  // Student card - positioned lower and right
                  Positioned(
                    top: 120,
                    right: 10,
                    child: SlideInWidget(
                      delay: const Duration(milliseconds: 800),
                      begin: const Offset(1, 0),
                      child: buildRoleCard(
                        context,
                        'Student',
                        buildStudentAvatar(),
                        Colors.blue,
                        state.selectedRole == 'Student',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    ],
  );
}
