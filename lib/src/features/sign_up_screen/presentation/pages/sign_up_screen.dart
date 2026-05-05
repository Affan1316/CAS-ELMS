import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cas_app_main/src/auth/data/service/AuthService.dart';
import '../widgets/signup_email_field.dart';
import '../widgets/signup_password_field.dart';
import '../widgets/signup_confirm_password_field.dart';
import '../widgets/signup_button.dart';
import '../widgets/signup_footer.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────

class _T {
  static const pageBg = Color(0xFFF5F5F5);
  static const cardBg = Color(0xFFFFFFFF);
  static const surfaceBg = Color(0xFFEAEAEA);
  static const heroBg = Color(0xFF111111);
  static const inkDeep = Color(0xFF111111);
  static const inkSoft = Color(0xFFAAAAAA);
  static const divider = Color(0xFFEBEBEB);
  static const errorColor = Color(0xFFE24B4A);

  // Unsplash: students collaborating / studying together
  static const heroImageUrl =
      'https://images.unsplash.com/photo-1523240795612-9a054b0db644'
      '?w=800&q=80&auto=format&fit=crop';
}

// ── Page ──────────────────────────────────────────────────────────────────────

class SignUpScreen extends StatefulWidget {
  final String id;
  const SignUpScreen({super.key, required this.id});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<bool> _isStudentIdValid(String studentId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(studentId)
              .get();
      return doc.exists;
    } catch (e) {
      print('Error validating student ID: $e');
      return false;
    }
  }

  Future<bool> _isStudentIdAlreadyRegistered(String studentId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(studentId)
              .get();
      if (doc.exists) {
        final data = doc.data();
        return data != null &&
            data.containsKey('uid') &&
            data['uid'] != null &&
            data['uid'].toString().isNotEmpty;
      }
      return false;
    } catch (e) {
      print('Error checking student ID registration: $e');
      return false;
    }
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final isValidId = await _isStudentIdValid(widget.id);
        if (!isValidId) {
          setState(() => _isLoading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Invalid Student ID. Please contact administration.',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
          }
          return;
        }

        final isAlreadyRegistered = await _isStudentIdAlreadyRegistered(
          widget.id,
        );
        if (isAlreadyRegistered) {
          setState(() => _isLoading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'This Student ID is already registered with another account.',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
          }
          return;
        }

        final result = await _authService.signUpWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          studentId: widget.id,
        );

        setState(() => _isLoading = false);
        if (!mounted) return;

        if (result.success && result.uid != null) {
          await FirebaseFirestore.instance
              .collection('students')
              .doc(widget.id)
              .update({
                'email': _emailController.text.trim(),
                'uid': result.uid,
                'registeredAt': FieldValue.serverTimestamp(),
              });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An unexpected error occurred: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }
  // ── END LOGIC ─────────────────────────────────────────────────────────────

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
      body: Column(
        children: [
          // ── Hero image ────────────────────────────────────────────────
          _HeroImage(onBack: () => Navigator.of(context).pop()),

          // ── Scrollable form ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header copy
                      const Text(
                        'CAS LEARNING',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: _T.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Join us.',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.7,
                          height: 1.1,
                          color: _T.inkDeep,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Register your student account to get started.',
                        style: TextStyle(
                          fontSize: 13,
                          color: _T.inkSoft,
                          height: 1.55,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ── LOGIC UNCHANGED: widget calls with all original params ──
                      SignUpEmailField(
                        controller: _emailController,
                        validator: _validateEmail,
                      ),

                      const SizedBox(height: 10),

                      SignUpPasswordField(
                        controller: _passwordController,
                        validator: _validatePassword,
                        isPasswordVisible: _isPasswordVisible,
                        onToggleVisibility:
                            () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                      ),

                      const SizedBox(height: 10),

                      SignUpConfirmPasswordField(
                        controller: _confirmPasswordController,
                        validator: _validateConfirmPassword,
                        isPasswordVisible: _isConfirmPasswordVisible,
                        onToggleVisibility:
                            () => setState(
                              () =>
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible,
                            ),
                      ),

                      const SizedBox(height: 22),

                      SignUpButton(
                        isLoading: _isLoading,
                        onPressed: _handleSignUp,
                      ),

                      const SizedBox(height: 18),

                      SignUpFooter(id: widget.id),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
      height: 210 + topPad,
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
              loadingBuilder: (_, child, progress) {
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

          // Bottom gradient
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
              'Create account',
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
