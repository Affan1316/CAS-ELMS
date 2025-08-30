import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/auth/data/service/AuthService.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';
import 'package:flutter_cas_app_main/src/features/forget_password_screen/presentation/page/forget_password_screen.dart';
import 'package:flutter_cas_app_main/src/features/sign_up_screen/presentation/pages/sign_up_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_home_page.dart';

class StudentLoginScreen extends StatefulWidget {
  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<String> errorMessage = ValueNotifier<String>('');
  final _authService = AuthService(); // Add Firebase Auth Service

  bool _isPasswordVisible = false;
  bool _isLoading = false; // Add loading state

  // Add validation methods
  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Please enter your password';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // Updated login handler with Firebase Auth
  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Client-side validation
    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);

    if (emailError != null) {
      _showErrorMessage(emailError);
      return;
    }

    if (passwordError != null) {
      _showErrorMessage(passwordError);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() => _isLoading = false);

      if (result.success) {
        // Update BLoC if needed
        context.read<OnboardingBloc>().add(LoginEvent(email));

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StudentHomePage()),
        );
      } else {
        // Show Firebase error message
        _showErrorMessage(result.message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorMessage('An unexpected error occurred. Please try again.');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final safeArea = MediaQuery.of(context).padding;

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
          'Student Login',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
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
                  Positioned.fill(
                    child: SlideInWidget(
                      delay: const Duration(milliseconds: 600),
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
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
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Subtitle
                  SlideInWidget(
                    delay: const Duration(milliseconds: 1000),
                    begin: const Offset(0, 0.5),
                    child: Text(
                      'Sign in with your email and password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ),

                  SizedBox(height: titleSpacing),

                  // Email input
                  SlideInWidget(
                    delay: const Duration(milliseconds: 1200),
                    begin: const Offset(0, 0.5),
                    child: _buildInputField(
                      controller: _emailController,
                      hintText: 'Enter Email',
                      icon: Icons.email_outlined,
                      fontSize: inputFontSize,
                      isSmallScreen: isSmallScreen,
                      keyboardType: TextInputType.emailAddress,
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

                  SizedBox(height: 10),

                  // Forgot Password
                  SlideInWidget(
                    delay: const Duration(milliseconds: 1600),
                    begin: const Offset(0, 0.5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13.0 : 14.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Sign up link
                  SlideInWidget(
                    delay: const Duration(milliseconds: 1600),
                    begin: const Offset(0, 0.5),
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13.0 : 14.0,
                              color: Colors.grey.shade600,
                            ),
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Updated Login Button with Firebase Auth
                  SlideInWidget(
                    delay: const Duration(milliseconds: 1800),
                    begin: const Offset(0, 0.5),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DD0E1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
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
    TextInputType keyboardType = TextInputType.text,
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
        obscureText: isPassword ? !_isPasswordVisible : false,
        keyboardType: keyboardType,
        onChanged: (value) {
          if (errorMessage.value.isNotEmpty) {
            errorMessage.value = '';
          }
        },
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
                  ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                      size: isSmallScreen ? 20 : 24,
                    ),
                  )
                  : null,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    errorMessage.dispose();
    super.dispose();
  }
}
