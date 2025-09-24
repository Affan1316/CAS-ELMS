import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/StudentLoginScreen.dart';

class UserIdInputScreen extends StatefulWidget {
  @override
  _UserIdInputScreenState createState() => _UserIdInputScreenState();
}

class _UserIdInputScreenState extends State<UserIdInputScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _userIdController = TextEditingController();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final isKeyboardOpen = keyboardHeight > 0;

    // Fixed dimensions - don't change when keyboard opens
    final topSectionHeight = screenHeight * 0.35;
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

    // Fixed spacing - don't change when keyboard opens
    final titleSpacing = 15.0;
    final inputSpacing = 18.0;
    final verticalSpacing = 15.0;

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
          'Enter Your ID',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingInitial && state.shouldShake) {
            _shakeController.forward().then((_) {
              _shakeController.reset();
            });
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                child: Stack(
                  children: [
                    // Decorative elements
                    Positioned(
                      top: 20,
                      left: 20,
                      child: SlideInWidget(
                        delay: const Duration(milliseconds: 200),
                        begin: const Offset(-1, -1),
                        child: Container(
                          width: isSmallScreen ? 40 : 60,
                          height: isSmallScreen ? 40 : 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 20 : 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 30,
                      child: SlideInWidget(
                        delay: const Duration(milliseconds: 400),
                        begin: const Offset(1, -1),
                        child: Container(
                          width: isSmallScreen ? 30 : 40,
                          height: isSmallScreen ? 30 : 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 15 : 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Main illustration
                    Center(
                      child: SlideInWidget(
                        delay: const Duration(milliseconds: 600),
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Image.asset(
                            'assets/images/login.webp',
                            width: illustrationSize.clamp(150.0, 220.0),
                            height: illustrationSize.clamp(150.0, 220.0),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: illustrationSize.clamp(120.0, 180.0),
                                height: illustrationSize.clamp(120.0, 180.0),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.blue.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.laptop,
                                        size: 20,
                                        color: Colors.orange.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        'Welcome to CAS!',
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
                        'Please enter your student ID to continue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                    ),

                    SizedBox(height: titleSpacing),

                    // User ID input with shake animation
                    SlideInWidget(
                      delay: const Duration(milliseconds: 1200),
                      begin: const Offset(0, 0.5),
                      child: AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              10.0 *
                                  _shakeAnimation.value *
                                  (1.0 - _shakeAnimation.value) *
                                  2.0 *
                                  (0.5 - _shakeAnimation.value).sign,
                              0.0,
                            ),
                            child: _buildInputField(
                              controller: _userIdController,
                              hintText: 'Enter Your Student ID',
                              icon: Icons.person_outline,
                              fontSize: inputFontSize,
                              isSmallScreen: isSmallScreen,
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 40),

                    // Next Button
                    SlideInWidget(
                      delay: const Duration(milliseconds: 1400),
                      begin: const Offset(0, 0.5),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            final userId = _userIdController.text.trim();
                            if (userId.isNotEmpty) {
                              // Navigate to login screen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          StudentLoginScreen(studentid: userId),
                                ),
                              );
                            } else {
                              // Trigger shake animation via bloc
                              context.read<OnboardingBloc>().add(
                                LoginEvent(''),
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
                          child: const Text(
                            'Next',
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
        style: TextStyle(fontSize: fontSize, color: Colors.black),
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
    _shakeController.dispose();
    super.dispose();
  }
}
