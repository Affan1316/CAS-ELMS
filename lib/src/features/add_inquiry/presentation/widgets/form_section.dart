import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'course_dropdown.dart';
import 'gender_selection.dart';
import 'submit_button.dart';

class FormSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController cnicController;
  final String? gender;
  final String? selectedCourse;
  final void Function(String?) onGenderChanged;
  final void Function(String?) onCourseChanged;

  const FormSection({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.addressController,
    required this.emailController,
    required this.phoneController,
    required this.cnicController,
    required this.gender,
    required this.selectedCourse,
    required this.onGenderChanged,
    required this.onCourseChanged,
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
            CustomTextFieldInquiry(
              controller: nameController,
              label: 'Student Name',
              icon: Icons.person_outline,
              validatorMsg: 'Please enter student name',
              validator: (value) {},
            ),
            const SizedBox(height: 20),
            CustomTextFieldInquiry(
              controller: addressController,
              label: 'Father Name',
              icon: Icons.person_2_outlined,
              validatorMsg: 'Please enter father name',
              validator: (value) {},
            ),
            const SizedBox(height: 20),
            CustomTextFieldInquiry(
              controller: emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              validatorMsg: 'Please enter a valid email',
              isEmail: true,
              validator: (value) {},
            ),
            const SizedBox(height: 20),
            CustomTextFieldInquiry(
              controller: phoneController,
              label: 'Mobile Number',
              icon: Icons.phone_outlined,
              validatorMsg: 'Please enter phone number',
              isPhone: true,
              validator: (value) {},
            ),
            const SizedBox(height: 20),
            CustomTextFieldInquiry(
              controller: cnicController,
              label: 'Group Name',
              icon: Icons.group_outlined,
              validatorMsg: 'Please enter group name',
              validator: (value) {},
            ),
            const SizedBox(height: 20),
            CourseDropdown(
              selectedCourse: selectedCourse,
              onChanged: onCourseChanged,
            ),
            const SizedBox(height: 24),
            GenderSelection(gender: gender, onChanged: onGenderChanged),
            const SizedBox(height: 32),
            SubmitButton(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
