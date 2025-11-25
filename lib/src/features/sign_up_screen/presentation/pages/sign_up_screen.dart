import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/auth/data/service/AuthService.dart';
import '../widgets/signup_email_field.dart';
import '../widgets/signup_password_field.dart';
import '../widgets/signup_confirm_password_field.dart';
import '../widgets/signup_button.dart';
import '../widgets/signup_footer.dart';

class SignUpScreen extends StatefulWidget {
  final String id;
  const SignUpScreen({super.key, required this.id});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final result = await _authService.signUpWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          studentId: widget.id,
        );

        setState(() => _isLoading = false);

        if (result.success) {
          // ✅ Update Firestore student record with the entered email
          await FirebaseFirestore.instance
              .collection('students') // change to your actual collection name
              .doc(
                widget.id,
              ) // assuming admin saved student with id as documentId
              .update({'email': _emailController.text.trim()});

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );

          Navigator.of(context).pop();
        } else {
          // Show error message
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade700),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Company Name
                Text(
                  'Center of Advance Studies !',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Sign Up Text
                Text(
                  'Create your account',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Email Field
                SignUpEmailField(
                  controller: _emailController,
                  validator: _validateEmail,
                ),

                const SizedBox(height: 16),

                // Password Field
                SignUpPasswordField(
                  controller: _passwordController,
                  validator: _validatePassword,
                  isPasswordVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                SignUpConfirmPasswordField(
                  controller: _confirmPasswordController,
                  validator: _validateConfirmPassword,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(
                      () =>
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible,
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Sign Up Button
                SignUpButton(isLoading: _isLoading, onPressed: _handleSignUp),

                const SizedBox(height: 24),

                // Footer
                SignUpFooter(id: widget.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
