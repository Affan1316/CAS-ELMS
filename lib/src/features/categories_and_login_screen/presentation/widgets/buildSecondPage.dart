import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';

Widget buildSecondPage(BuildContext context, OnboardingInitial state) {
  final TextEditingController userIdController = TextEditingController();

  return Column(
    children: [
      Expanded(
        flex: 5,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 216, 240, 239),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                top: 40,
                left: 20,
                child: SlideInWidget(
                  delay: const Duration(milliseconds: 200),
                  begin: const Offset(-1, -1),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                right: 30,
                child: SlideInWidget(
                  delay: const Duration(milliseconds: 400),
                  begin: const Offset(1, -1),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              // Main illustration
              Center(
                child: SlideInWidget(
                  delay: const Duration(milliseconds: 600),
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Image.network(
                      'assets/images/login.webp',
                      width: 350,
                      height: 350,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.blue.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.laptop,
                                      size: 24,
                                      color: Colors.orange.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom half with white background and content
      Expanded(
        flex: 4,
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Title
              SlideInWidget(
                delay: const Duration(milliseconds: 800),
                begin: const Offset(0, 0.5),
                child: const Text(
                  'Are You a CASIAN ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              SlideInWidget(
                delay: const Duration(milliseconds: 1000),
                begin: const Offset(0, 0.5),
                child: const Text(
                  'Login to see the result.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Store name input
              SlideInWidget(
                delay: const Duration(milliseconds: 1200),
                begin: const Offset(0, 0.5),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: userIdController,
                    decoration: const InputDecoration(
                      hintText: 'Your Id',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
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
}
