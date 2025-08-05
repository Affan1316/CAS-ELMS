import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';

Widget buildTeacherLoginPage(
  BuildContext context,
  OnboardingInitial state,
  TextEditingController userIdController, // Accept controller from main screen
  TextEditingController passwordController, // Accept password controller too
) {
  final ValueNotifier<String> errorMessage = ValueNotifier<String>('');

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

              // Main illustration - Teacher themed
              Center(
                child: SlideInWidget(
                  delay: const Duration(milliseconds: 600),
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Image.network(
                      'assets/images/admin_illustration.webp', // Teacher-specific image
                      width: 300,
                      height: 300,
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
                                      color: Colors.teal.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.school, // Teacher icon
                                      size: 40,
                                      color: Colors.teal.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.laptop_mac, // Teaching laptop
                                      size: 24,
                                      color: Colors.green.shade600,
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
              const SizedBox(height: 20),

              // Title - Teacher specific
              SlideInWidget(
                delay: const Duration(milliseconds: 800),
                begin: const Offset(0, 0.5),
                child: const Text(
                  'Welcome Back Teacher!',
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

              // Subtitle - Teacher specific
              SlideInWidget(
                delay: const Duration(milliseconds: 1000),
                begin: const Offset(0, 0.5),
                child: const Text(
                  'Login to access your teaching dashboard.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Teacher ID input with neumorphic inner effect
              SlideInWidget(
                delay: const Duration(milliseconds: 1200),
                begin: const Offset(0, 0.5),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      // Dark shadow (creates depth)
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(-4, -4),
                        blurRadius: 8,
                        spreadRadius: -1,
                      ),
                      // Light shadow (enhances inset effect)
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: -1,
                      ),
                      // Additional inner glow for more depth
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: userIdController, // Use the passed controller
                    onChanged: (value) {
                      if (errorMessage.value.isNotEmpty) {
                        errorMessage.value = '';
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Teacher ID',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      prefixIcon: Icon(
                        Icons.badge_outlined, // Teacher ID icon
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Password input with neumorphic inner effect
              SlideInWidget(
                delay: const Duration(milliseconds: 1400),
                begin: const Offset(0, 0.5),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      // Dark shadow (creates depth)
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(-4, -4),
                        blurRadius: 8,
                        spreadRadius: -1,
                      ),
                      // Light shadow (enhances inset effect)
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: -1,
                      ),
                      // Additional inner glow for more depth
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller:
                        passwordController, // Use the passed password controller
                    obscureText: true,
                    onChanged: (value) {
                      if (errorMessage.value.isNotEmpty) {
                        errorMessage.value = '';
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Forgot Password
              SlideInWidget(
                delay: const Duration(milliseconds: 1600),
                begin: const Offset(0, 0.5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Handle forgot password for teacher
                      print('Teacher forgot password tapped');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
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
}
