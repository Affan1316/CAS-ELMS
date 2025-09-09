import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/pages/admin_home_page.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';

class TeacherLoginScreen extends StatefulWidget {
  @override
  _TeacherLoginScreenState createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final isKeyboardOpen = keyboardHeight > 0;

    final topSectionHeight =
        isKeyboardOpen ? screenHeight * 0.2 : screenHeight * 0.35;
    final horizontalPadding = (screenWidth * 0.06).clamp(16.0, 32.0);
    final illustrationSize =
        isSmallScreen
            ? screenWidth * 0.45
            : isMediumScreen
            ? screenWidth * 0.5
            : screenWidth * 0.4;

    final titleFontSize = isSmallScreen ? 20.0 : 24.0;
    final subtitleFontSize = isSmallScreen ? 13.0 : 14.0;
    final inputFontSize = isSmallScreen ? 15.0 : 16.0;

    final titleSpacing = isKeyboardOpen ? 8.0 : 15.0;
    final inputSpacing = isKeyboardOpen ? 12.0 : 18.0;
    final verticalSpacing = isKeyboardOpen ? 6.0 : 15.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 216, 240, 239),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Teacher Login',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight - keyboardHeight - kToolbarHeight,
          ),
          child: Column(
            children: [
              // Top section with illustration
              Container(
                height: topSectionHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 216, 240, 239),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: SlideInWidget(
                    delay: const Duration(milliseconds: 600),
                    child: Container(
                      margin: EdgeInsets.only(top: isKeyboardOpen ? 10 : 20),
                      width: illustrationSize.clamp(150.0, 220.0),
                      height: illustrationSize.clamp(150.0, 220.0),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.teal.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.school,
                              size: 40,
                              color: Colors.teal.shade600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.laptop_mac,
                              size: 25,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom section with form
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: verticalSpacing),

                    // Title
                    SlideInWidget(
                      delay: const Duration(milliseconds: 800),
                      begin: const Offset(0, 0.5),
                      child: Text(
                        'Welcome Teacher!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),

                    SizedBox(height: isKeyboardOpen ? 4 : 8),

                    // Subtitle
                    SlideInWidget(
                      delay: const Duration(milliseconds: 1000),
                      begin: const Offset(0, 0.5),
                      child: Text(
                        'Access your teaching dashboard.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                    ),

                    SizedBox(height: titleSpacing),

                    // Teacher ID input
                    SlideInWidget(
                      delay: const Duration(milliseconds: 1200),
                      begin: const Offset(0, 0.5),
                      child: _buildInputField(
                        controller: _userIdController,
                        hintText: 'Teacher ID',
                        icon: Icons.badge_outlined,
                        fontSize: inputFontSize,
                        isSmallScreen: isSmallScreen,
                      ),
                    ),

                    SizedBox(height: inputSpacing),

                    // Password input
                    SlideInWidget(
                      delay: const Duration(milliseconds: 1400),
                      begin: const Offset(0, 0.5),
                      child: _buildInputField(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        fontSize: inputFontSize,
                        isSmallScreen: isSmallScreen,
                        isPassword: true,
                      ),
                    ),

                    SizedBox(height: isKeyboardOpen ? 8 : 10),

                    // Forgot Password
                    SlideInWidget(
                      delay: const Duration(milliseconds: 1600),
                      begin: const Offset(0, 0.5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to forgot password screen
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13.0 : 14.0,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Login Button
                    SlideInWidget(
                      delay: const Duration(milliseconds: 1800),
                      begin: const Offset(0, 0.5),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<OnboardingBloc>().add(
                              LoginEvent(_userIdController.text),
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AdminHomePage(),
                              ),
                            );
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('hello')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Login as Teacher',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isKeyboardOpen ? 20 : 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required double fontSize,
    required bool isSmallScreen,
    bool isPassword = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 0),
            blurRadius: 4,
            spreadRadius: -2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: fontSize),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 12 : 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
            size: isSmallScreen ? 20 : 24,
          ),
          suffixIcon:
              isPassword
                  ? Icon(
                    Icons.visibility_off_outlined,
                    color: Colors.grey,
                    size: isSmallScreen ? 20 : 24,
                  )
                  : null,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
