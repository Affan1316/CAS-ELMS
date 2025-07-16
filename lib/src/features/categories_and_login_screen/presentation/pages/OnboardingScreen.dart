import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/ShakeWidget.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildFirstPage.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildSecondPage.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildThirdPage.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final TextEditingController _userIdController = TextEditingController();

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
          }
        },
        builder: (context, state) {
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
                    buildThirdPage(context, currentState),
                    buildSecondPage(context, currentState),
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
                        children: List.generate(3, (index) {
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
                              if (currentState.currentPage < 2) {
                                context.read<OnboardingBloc>().add(
                                  NextPageEvent(),
                                );
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
                              currentState.currentPage == 2
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
}
