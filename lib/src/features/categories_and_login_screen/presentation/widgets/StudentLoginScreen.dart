import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/auth/data/service/AuthService.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';
import 'package:flutter_cas_app_main/src/features/forget_password_screen/presentation/page/forget_password_screen.dart';
import 'package:flutter_cas_app_main/src/features/sign_up_screen/presentation/pages/sign_up_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_home_page.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────

class _T {
  static const pageBg = Color(0xFFF5F5F5);
  static const cardBg = Color(0xFFFFFFFF);
  static const surfaceBg = Color(0xFFEAEAEA);
  static const heroBg = Color(0xFF111111);
  static const inkDeep = Color(0xFF111111);
  static const inkMid = Color(0xFF555555);
  static const inkSoft = Color(0xFFAAAAAA);
  static const divider = Color(0xFFEBEBEB);
  static const focusBorder = Color(0xFF111111);

  // Unsplash: student at laptop, warm study atmosphere
  static const heroImageUrl =
      'https://images.unsplash.com/photo-1531482615713-2afd69097998'
      '?w=800&q=80&auto=format&fit=crop';
}

// ── Page ──────────────────────────────────────────────────────────────────────

class StudentLoginScreen extends StatefulWidget {
  final String studentid;
  const StudentLoginScreen({super.key, required this.studentid});

  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<String> errorMessage = ValueNotifier<String>('');
  final _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

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

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

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
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(widget.studentid)
              .get();

      if (!doc.exists) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showErrorMessage("Invalid student ID");
        return;
      }

      final firestoreEmail = doc['email'];
      if (firestoreEmail != email) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showErrorMessage("Email does not match this student ID");
        return;
      }

      final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
        studentId: widget.studentid,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result.success) {
        context.read<OnboardingBloc>().add(LoginEvent(email));
        context.read<OnboardingBloc>().add(
          ReadStudentNameFromFireBaseEvent(id: widget.studentid),
        );
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
      } else {
        _showErrorMessage(result.message);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showErrorMessage("Something went wrong. Please try again.");
      debugPrint("Login error: $e");
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    errorMessage.dispose();
    super.dispose();
  }
  // ── END LOGIC ─────────────────────────────────────────────────────────────

  // Focus tracking (UI only)
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _emailFocused = false;
  bool _passwordFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(
      () => setState(() => _emailFocused = _emailFocus.hasFocus),
    );
    _passwordFocus.addListener(
      () => setState(() => _passwordFocused = _passwordFocus.hasFocus),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: _T.pageBg,
      // ── LOGIC UNCHANGED: BlocListener ─────────────────────────────────
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          print(state);
          if (state is ReadingStudentNameCompleted) {
            debugPrint("$state^^^^^^^^^^^^^^^^^^");
            final studentEntityClass = StudentEntityClass(
              id: state.studentEntityClass.id,
              name: state.studentEntityClass.name,
              email: state.studentEntityClass.email,
              cnic: state.studentEntityClass.cnic,
              phone: state.studentEntityClass.phone,
              address: state.studentEntityClass.address,
              gender: state.studentEntityClass.gender,
              fatherName: state.studentEntityClass.fatherName,
              fatherOccupation: state.studentEntityClass.fatherOccupation,
              group: state.studentEntityClass.group,
            );
            try {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder:
                      (context) => StudentHomePage(
                        id: widget.studentid,
                        studentEntityClass: studentEntityClass,
                      ),
                ),
                (route) => false,
              );
            } catch (e) {
              debugPrint("navigation failed due to $e");
            }
          }
        },
        child: Column(
          children: [
            // ── Hero image ──────────────────────────────────────────────
            _HeroImage(onBack: () => Navigator.pop(context)),

            // ── Scrollable form ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header copy
                      SlideInWidget(
                        delay: const Duration(milliseconds: 150),
                        begin: const Offset(0, 0.3),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CAS LEARNING',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                                color: _T.inkSoft,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Sign in.',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.7,
                                height: 1.1,
                                color: _T.inkDeep,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Access your dashboard with your\nemail and password.',
                              style: TextStyle(
                                fontSize: 13,
                                color: _T.inkSoft,
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Email field
                      SlideInWidget(
                        delay: const Duration(milliseconds: 250),
                        begin: const Offset(0, 0.3),
                        child: _InputField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          label: 'Email',
                          hint: 'Enter your email address',
                          icon: Icons.email_outlined,
                          isFocused: _emailFocused,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) {
                            if (errorMessage.value.isNotEmpty) {
                              errorMessage.value = '';
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Password field
                      SlideInWidget(
                        delay: const Duration(milliseconds: 350),
                        begin: const Offset(0, 0.3),
                        child: _InputField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          label: 'Password',
                          hint: 'Enter your password',
                          icon: Icons.lock_outline_rounded,
                          isFocused: _passwordFocused,
                          isPassword: true,
                          isPasswordVisible: _isPasswordVisible,
                          // LOGIC UNCHANGED: toggle visibility
                          onTogglePassword:
                              () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                          onChanged: (_) {
                            if (errorMessage.value.isNotEmpty) {
                              errorMessage.value = '';
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Forgot password + Sign up row
                      SlideInWidget(
                        delay: const Duration(milliseconds: 420),
                        begin: const Offset(0, 0.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Sign up link — LOGIC UNCHANGED
                            GestureDetector(
                              onTap:
                                  () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SignUpScreen(
                                            id: widget.studentid,
                                          ),
                                    ),
                                  ),
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _T.inkSoft,
                                  ),
                                  children: [
                                    TextSpan(text: "No account? "),
                                    TextSpan(
                                      text: 'Sign up',
                                      style: TextStyle(
                                        color: _T.inkDeep,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Forgot password — LOGIC UNCHANGED
                            GestureDetector(
                              onTap:
                                  () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ForgotPasswordScreen(),
                                    ),
                                  ),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _T.inkDeep,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Sign in button — LOGIC UNCHANGED
                      SlideInWidget(
                        delay: const Duration(milliseconds: 500),
                        begin: const Offset(0, 0.3),
                        child: _SignInButton(
                          isLoading: _isLoading,
                          onTap: _isLoading ? null : _handleSignIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero image ────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final VoidCallback onBack;
  const _HeroImage({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 230 + topPad,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            child: Image.network(
              _T.heroImageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFF1A1A1A),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.white30,
                    ),
                  ),
                );
              },
              errorBuilder:
                  (_, __, ___) => Container(
                    color: _T.heroBg,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              color: Colors.white30,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'CAS Learning System',
                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ),

          // Subtle bottom gradient for label legibility
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 90,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                  ),
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: topPad + 12,
            left: 16,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15,
                    color: _T.inkDeep,
                  ),
                ),
              ),
            ),
          ),

          // Bottom label
          const Positioned(
            left: 20,
            bottom: 16,
            child: Text(
              'Student login',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Input field ───────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final bool isFocused;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePassword;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    required this.isFocused,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePassword,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? _T.focusBorder : _T.divider,
          width: isFocused ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Icon bed
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isFocused ? _T.heroBg : _T.surfaceBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 15,
                color: isFocused ? Colors.white : _T.inkMid,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Label + TextField
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: _T.inkSoft,
                  ),
                ),
                const SizedBox(height: 3),
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: isPassword && !isPasswordVisible,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _T.inkDeep,
                    letterSpacing: -0.1,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: _T.inkSoft,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),

          // Password visibility toggle — LOGIC UNCHANGED
          if (isPassword)
            GestureDetector(
              onTap: onTogglePassword,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: _T.inkSoft,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Sign in button ────────────────────────────────────────────────────────────

class _SignInButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onTap;
  const _SignInButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: isLoading ? const Color(0xFF555555) : _T.heroBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child:
              isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white54,
                    ),
                  )
                  : const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
        ),
      ),
    );
  }
}
