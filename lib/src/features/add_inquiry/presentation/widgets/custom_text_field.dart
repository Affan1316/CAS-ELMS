import 'package:flutter/material.dart';

class CustomTextFieldInquiry extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String validatorMsg;
  final bool isEmail;
  final bool isPhone;

  const CustomTextFieldInquiry({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validatorMsg,
    this.isEmail = false,
    this.isPhone = false,
    required String? Function(dynamic value) validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType:
              isEmail
                  ? TextInputType.emailAddress
                  : isPhone
                  ? TextInputType.phone
                  : null,
          validator: (value) {
            if (value == null || value.isEmpty) return validatorMsg;
            if (isEmail &&
                !RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
            hintText: label,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
