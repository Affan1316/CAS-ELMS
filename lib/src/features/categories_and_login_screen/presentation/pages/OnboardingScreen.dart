import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/pages/admin_home_page.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/ShakeWidget.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildFirstPage.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildSecondPage.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildTeacherLoginPage.dart';
import 'package:flutter_cas_app_main/src/features/student_home_page/presentation/pages/student_home_page.dart';

class LoginOnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingInitial) {
            _pageController.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else if (state is OnboardingLoginSuccess) {
            // Handle navigation based on selected role
            _navigateBasedOnRole(context, state.selectedRole, state.userId);
          }
        },
        builder: (context, state) {
          // Handle different state types
          if (state is OnboardingLoginSuccess) {
            // Show loading or return empty container while navigating
            return const Center(child: CircularProgressIndicator());
          }

          final currentState = state as OnboardingInitial;

          return Column(
            children: [
              // Top bar with teal background
              SlideInWidget(
                begin: const Offset(0, -1),
                child: Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 216, 240, 239),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (currentState.currentPage > 0)
                            GestureDetector(
                              onTap: () {
                                context.read<OnboardingBloc>().add(
                                  PreviousPageEvent(),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 32),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildFirstPage(context, currentState),

                    // Dynamic login page based on selected role
                    _buildLoginPage(context, currentState),
                  ],
                ),
              ),

              // Bottom section with dots and continue button
              SlideInWidget(
                begin: const Offset(0, 1),
                delay: const Duration(milliseconds: 600),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(2, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentState.currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  currentState.currentPage == index
                                      ? const Color(0xFF4DD0E1)
                                      : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 32),

                      // Continue/Login button
                      ShakeWidget(
                        shouldShake: currentState.shouldShake,
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (currentState.currentPage < 1) {
                                if (currentState.selectedRole == null ||
                                    currentState.selectedRole!.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Select your role'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  context.read<OnboardingBloc>().add(
                                    NextPageEvent(),
                                  );
                                }
                              } else {
                                // Login logic
                                context.read<OnboardingBloc>().add(
                                  LoginEvent(_userIdController.text),
                                );
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
                            child: Text(
                              currentState.currentPage == 1
                                  ? 'Login'
                                  : 'Continue',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Method to build the appropriate login page based on selected role
  Widget _buildLoginPage(BuildContext context, OnboardingInitial state) {
    switch (state.selectedRole) {
      case 'Teacher':
        return buildTeacherLoginPage(
          context,
          state,
          _userIdController,
          _passwordController,
        );
      case 'Student':
        return buildStudentLoginPage(
          context,
          state,
          _userIdController,
          _passwordController,
        );
      default:
        // Fallback to student login if no role is selected
        return buildStudentLoginPage(
          context,
          state,
          _userIdController,
          _passwordController,
        );
    }
  }

  // Navigation method based on selected role
  void _navigateBasedOnRole(BuildContext context, String role, String userId) {
    // Clear the text controllers
    _userIdController.clear();
    _passwordController.clear();

    switch (role) {
      case 'Teacher':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AdminHomePage()));
        break;
      case 'Student':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => StudentHomePage()));
        break;
      default:
        // Default to student if role is not recognized
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => StudentHomePage()));
        break;
    }
  }
}
