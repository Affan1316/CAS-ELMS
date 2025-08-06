// import 'package:flutter/material.dart';
// import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/bloc/student_enrollment_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/bloc/student_enrollment_event.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/bloc/student_enrollment_state.dart';

class StudentEnrollmentForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController studentIdController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController cnicController;
  final TextEditingController fatherNameController;
  final TextEditingController fatherOccupationController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final String selectedGender;
  final Function(String gender) onGenderChanged;

  const StudentEnrollmentForm({
    super.key,
    required this.formKey,
    required this.studentIdController,
    required this.nameController,
    required this.emailController,
    required this.cnicController,
    required this.fatherNameController,
    required this.fatherOccupationController,
    required this.phoneController,
    required this.addressController,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(
              studentIdController,
              'Student ID',
              Icons.badge_outlined,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Student ID is required';

                return null;
              },
            ),
            _buildInputField(
              nameController,
              'Full Name',
              Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Name is required';
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return 'Only letters allowed';
                }
                return null;
              },
            ),
            _buildInputField(
              emailController,
              'Email Address',
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            _buildInputField(
              cnicController,
              'CNIC',
              Icons.credit_card_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'CNIC is required';
                if (!RegExp(r'^\d{13}$').hasMatch(value))
                  return 'Enter 13 digit CNIC';
                return null;
              },
            ),
            _buildInputField(
              fatherNameController,
              'Father\'s Name',
              Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Father\'s name is required';
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return 'Only letters allowed';
                }
                return null;
              },
            ),
            _buildInputField(
              fatherOccupationController,
              'Father\'s Occupation',
              Icons.business_center_outlined,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Occupation is required';
                return null;
              },
            ),
            _buildInputField(
              phoneController,
              'Phone Number',
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Phone number is required';
                if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                  return 'Enter 11-digit Pakistani number';
                }
                return null;
              },
            ),
            _buildInputField(
              addressController,
              'Address',
              Icons.location_on_outlined,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Address is required';
                return null;
              },
            ),

            const SizedBox(height: 24),
            _buildGenderSelector(),
            const SizedBox(height: 32),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator:
            validator ?? (v) => v == null || v.isEmpty ? 'Enter $label' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: 'Enter $label',
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(child: _genderOptionTile('Male', Icons.male)),
        const SizedBox(width: 16),
        Expanded(child: _genderOptionTile('Female', Icons.female)),
      ],
    );
  }

  Widget _genderOptionTile(String gender, IconData icon) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => onGenderChanged(gender),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(color: isSelected ? Colors.blue : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<StudentEnrollmentBloc, StudentEnrollmentState>(
      builder: (context, state) {
        final isLoading = state is StudentEnrollmentSubmitting;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed:
                isLoading
                    ? null
                    : () {
                      if (formKey.currentState!.validate()) {
                        context.read<StudentEnrollmentBloc>().add(
                          SubmitEnrollmentFormEvent(
                            id: studentIdController.text,
                            name: nameController.text,
                            email: emailController.text,
                            cnic: cnicController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                            gender: selectedGender,
                          ),
                        );
                      }
                    },
            child:
                isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Enrollment'),
          ),
        );
      },
    );
  }
}
