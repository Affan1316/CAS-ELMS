import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'course_dropdown.dart';
import 'gender_selection.dart';
import 'submit_button.dart';

class FormSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController studentNameController;
  final TextEditingController fatherNameController;
  final TextEditingController emailAddressController;
  final TextEditingController phoneNoController;
  final TextEditingController groupNameController;
  final String? gender;
  final String? selectedCourse;
  final void Function(String?) onGenderChanged;
  final void Function(String?) onCourseChanged;
  final List<String> courses;

  const FormSection({
    super.key,
    required this.formKey,
    required this.studentNameController,
    required this.fatherNameController,
    required this.emailAddressController,
    required this.phoneNoController,
    required this.groupNameController,
    required this.gender,
    required this.selectedCourse,
    required this.onGenderChanged,
    required this.onCourseChanged,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    // FIX: Wrapped in Theme widget to force light mode (black text)
    // because the container background is hardcoded to white.
    return Theme(
      data: ThemeData.light(),
      child: Container(
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
              CustomTextField(
                controller: studentNameController,
                label: 'Student Name',
                icon: Icons.person_outline,
                validatorMsg: 'Please enter student name',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: fatherNameController,
                label: 'Father Name',
                icon: Icons.person_2_outlined,
                validatorMsg: 'Please enter father name',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: emailAddressController,
                label: 'Email',
                icon: Icons.email_outlined,
                validatorMsg: 'Please enter a valid email',
                isEmail: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: phoneNoController,
                label: 'Mobile Number',
                icon: Icons.phone_outlined,
                validatorMsg: 'Please enter phone number',
                isPhone: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: groupNameController,
                label: 'Group Name',
                icon: Icons.group_outlined,
                validatorMsg: 'Please enter group name',
              ),
              const SizedBox(height: 20),
              CourseDropdown(
                selectedCourse: selectedCourse,
                onChanged: onCourseChanged,
                courses: courses,
              ),
              const SizedBox(height: 24),
              GenderSelection(gender: gender, onChanged: onGenderChanged),
              const SizedBox(height: 32),
              SubmitButton(
                studentNameController: studentNameController,
                fatherNameController: fatherNameController,
                emailAddressController: emailAddressController,
                phoneNoController: phoneNoController,
                groupNameController: groupNameController,
                selectedCourse: selectedCourse,
                gender: gender,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
