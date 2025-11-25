import 'package:flutter/material.dart';

class NewPasswordStep extends StatelessWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final VoidCallback onToggleNewPassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onSubmit;
  final String? Function(String?) validatePassword;
  final String? Function(String?) validateConfirmPassword;

  const NewPasswordStep({
    super.key,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.isNewPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.onToggleNewPassword,
    required this.onToggleConfirmPassword,
    required this.onSubmit,
    required this.validatePassword,
    required this.validateConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: newPasswordController,
          validator: validatePassword,
          obscureText: !isNewPasswordVisible,
          decoration: InputDecoration(
            labelText: "New Password",
            suffixIcon: IconButton(
              icon: Icon(
                isNewPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onToggleNewPassword,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: confirmPasswordController,
          validator: validateConfirmPassword,
          obscureText: !isConfirmPasswordVisible,
          decoration: InputDecoration(
            labelText: "Confirm Password",
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: onToggleConfirmPassword,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Done"),
        ),
      ],
    );
  }
}
