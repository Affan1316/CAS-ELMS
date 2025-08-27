import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildRoleCard.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildStudentAvatar.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildTeacherAvatar.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildTeacherLoginPage.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildUserIdScreen.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          final currentState =
              state is OnboardingInitial ? state : OnboardingInitial();

          return _buildRoleSelectionContent(context, currentState);
        },
      ),
    );
  }

  Widget _buildRoleSelectionContent(
    BuildContext context,
    OnboardingInitial state,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final safeArea = MediaQuery.of(context).padding;

    // Calculate responsive values
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    final backgroundHeight = screenHeight * 0.45;
    final horizontalPadding = screenWidth * 0.06;
    final responsivePadding = horizontalPadding.clamp(16.0, 32.0);

    final titleFontSize =
        isSmallScreen
            ? 24.0
            : isMediumScreen
            ? 28.0
            : 32.0;
    final subtitleFontSize = isSmallScreen ? 14.0 : 16.0;

    final topSpacing = safeArea.top + (screenHeight * 0.03);
    final titleSpacing = screenHeight * 0.025;
    final subtitleSpacing = screenHeight * 0.05;
    final cardSpacing = screenHeight * 0.04;

    return Stack(
      children: [
        // Background with curved bottom
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: backgroundHeight,
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
          padding: EdgeInsets.symmetric(horizontal: responsivePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: topSpacing),

              // Title
              SlideInWidget(
                delay: const Duration(milliseconds: 200),
                begin: const Offset(0, -0.5),
                child: Text(
                  'Join CAS as a...',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: titleSpacing),

              // Subtitle
              SlideInWidget(
                delay: const Duration(milliseconds: 400),
                begin: const Offset(0, -0.5),
                child: Text(
                  'Create and sell courses as a Teacher or\nEnhance courses and learn as a Student.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: subtitleSpacing),

              // Role selection cards using your buildRoleCard
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableHeight = constraints.maxHeight;
                    final availableWidth = constraints.maxWidth;

                    if (isSmallScreen) {
                      // For very small screens, stack vertically
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SlideInWidget(
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
                          SizedBox(height: cardSpacing),
                          SlideInWidget(
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
                        ],
                      );
                    } else {
                      // For medium and large screens, use positioned layout
                      return Stack(
                        children: [
                          // Teacher card - positioned dynamically
                          Positioned(
                            top: availableHeight * 0.1, // 10% from top
                            left: availableWidth * 0.05, // 5% from left
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

                          // Student card - positioned dynamically
                          Positioned(
                            top: availableHeight * 0.35, // 35% from top
                            right: availableWidth * 0.05, // 5% from right
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
                      );
                    }
                  },
                ),
              ),

              // Continue button
              SlideInWidget(
                delay: const Duration(milliseconds: 1000),
                begin: const Offset(0, 1),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (state.selectedRole == null ||
                            state.selectedRole!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select your role first'),
                              backgroundColor: Colors.orange,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          _navigateToLogin(context, state.selectedRole!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DD0E1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToLogin(BuildContext context, String role) {
    if (role == 'Teacher') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TeacherLoginScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserIdInputScreen()),
      );
    }
  }
}
