import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/forget_password_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/forget_password_event.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/forget_password_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  late ForgotPasswordBloc _forgotPasswordBloc;

  @override
  void initState() {
    super.initState();
    _forgotPasswordBloc = ForgotPasswordBloc();
  }

  void _verifyAdminId() {
    _forgotPasswordBloc.add(
      AdminIdVerificationRequested(adminId: _adminIdController.text.trim()),
    );
  }

  void _changePassword(String verifiedAdminId) {
    _forgotPasswordBloc.add(
      PasswordChangeRequested(
        adminId: verifiedAdminId,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordBloc>(
      create: (context) => _forgotPasswordBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 235, 235),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Reset Password',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          bloc: _forgotPasswordBloc,
          listener: (context, state) {
            if (state is AdminIdVerificationFailed) {
              _showMessage(state.message, isError: true);
            } else if (state is AdminIdVerified) {
              _showMessage('Admin ID verified! Enter new password.');
            } else if (state is PasswordChangeFailure) {
              _showMessage(state.message, isError: true);
            } else if (state is PasswordChangeSuccess) {
              _showMessage('Password changed successfully!');

              // Navigate back after delay
              Future.delayed(Duration(milliseconds: 1500), () {
                if (mounted) {
                  _adminIdController.clear();
                  _newPasswordController.clear();
                  _confirmPasswordController.clear();
                  Navigator.of(context).pop();
                }
              });
            }
          },
          child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
            bloc: _forgotPasswordBloc,
            builder: (context, state) {
              bool isLoading = state is ForgotPasswordLoading;
              bool isIdVerified = state is AdminIdVerified;
              String verifiedAdminId =
                  isIdVerified ? (state as AdminIdVerified).adminId : '';

              return SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),

                    // Header
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_reset,
                          size: 50,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    Text(
                      'Reset Admin Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      isIdVerified
                          ? 'Enter your new password below.'
                          : 'Enter your Admin ID to verify your identity.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    SizedBox(height: 30),

                    // Admin ID Field
                    if (!isIdVerified) ...[
                      Text(
                        'Admin ID',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _adminIdController,
                        decoration: InputDecoration(
                          hintText: 'Enter your Admin ID',
                          prefixIcon: Icon(Icons.admin_panel_settings),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _verifyAdminId,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              isLoading
                                  ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    'Verify Admin ID',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),
                    ],

                    // Password Fields
                    if (isIdVerified) ...[
                      Text(
                        'New Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        decoration: InputDecoration(
                          hintText: 'Enter new password',
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: GestureDetector(
                            onTap:
                                () => setState(
                                  () =>
                                      _obscureNewPassword =
                                          !_obscureNewPassword,
                                ),
                            child: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Confirm New Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm new password',
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: GestureDetector(
                            onTap:
                                () => setState(
                                  () =>
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword,
                                ),
                            child: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () => _changePassword(verifiedAdminId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              isLoading
                                  ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    'Change Password',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _adminIdController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _forgotPasswordBloc.close();
    super.dispose();
  }
}
