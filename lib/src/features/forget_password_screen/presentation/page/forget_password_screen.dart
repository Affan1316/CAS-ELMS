import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_cas_app_main/src/features/forget_password_screen/presentation/widgets/email_step.dart';
import 'package:flutter_cas_app_main/src/features/forget_password_screen/presentation/widgets/new_password_step.dart';
import 'package:flutter_cas_app_main/src/features/forget_password_screen/presentation/widgets/otp_step.dart';

enum ForgotPasswordStep { email, otp, newPassword }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  ForgotPasswordStep _currentStep = ForgotPasswordStep.email;
  bool _isLoading = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Timer? _otpTimer;
  int _otpCountdown = 0;
  bool _canResendOtp = true;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _otpTimer?.cancel();
    super.dispose();
  }

  // Validators
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) return 'Please enter the OTP';
    if (value.length != 6) return 'OTP must be 6 digits';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _newPasswordController.text) return 'Passwords do not match';
    return null;
  }

  // Timer
  void _startOtpTimer() {
    setState(() {
      _canResendOtp = false;
      _otpCountdown = 60;
    });

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_otpCountdown > 0) {
          _otpCountdown--;
        } else {
          _canResendOtp = true;
          timer.cancel();
        }
      });
    });
  }

  // Step Handlers
  Future<void> _handleEmailSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
        _currentStep = ForgotPasswordStep.otp;
      });
      _startOtpTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent to your email!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _handleOtpSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
        _currentStep = ForgotPasswordStep.newPassword;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP verified successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _handleResendOtp() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    _startOtpTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent to your email!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _handlePasswordReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  // Titles
  String _getTitle() {
    switch (_currentStep) {
      case ForgotPasswordStep.email:
        return 'Forgot Password';
      case ForgotPasswordStep.otp:
        return 'Enter OTP';
      case ForgotPasswordStep.newPassword:
        return 'Create New Password';
    }
  }

  String _getSubtitle() {
    switch (_currentStep) {
      case ForgotPasswordStep.email:
        return 'Enter your email to receive reset instructions';
      case ForgotPasswordStep.otp:
        return 'Enter the 6-digit code sent to ${_emailController.text}';
      case ForgotPasswordStep.newPassword:
        return 'Create a strong password for your account';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case ForgotPasswordStep.email:
        return EmailStep(
          emailController: _emailController,
          isLoading: _isLoading,
          onSubmit: _handleEmailSubmit,
          validateEmail: _validateEmail,
        );
      case ForgotPasswordStep.otp:
        return OtpStep(
          otpController: _otpController,
          isLoading: _isLoading,
          canResendOtp: _canResendOtp,
          otpCountdown: _otpCountdown,
          onSubmit: _handleOtpSubmit,
          onResend: _handleResendOtp,
          validateOtp: _validateOtp,
        );
      case ForgotPasswordStep.newPassword:
        return NewPasswordStep(
          newPasswordController: _newPasswordController,
          confirmPasswordController: _confirmPasswordController,
          isLoading: _isLoading,
          isNewPasswordVisible: _isNewPasswordVisible,
          isConfirmPasswordVisible: _isConfirmPasswordVisible,
          onToggleNewPassword:
              () => setState(
                () => _isNewPasswordVisible = !_isNewPasswordVisible,
              ),
          onToggleConfirmPassword:
              () => setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
              ),
          onSubmit: _handlePasswordReset,
          validatePassword: _validatePassword,
          validateConfirmPassword: _validateConfirmPassword,
        );
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
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  _getTitle(),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _getSubtitle(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _buildCurrentStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
