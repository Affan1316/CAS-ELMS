import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'add_course_button.dart';

class CourseForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const CourseForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.isLoading,
    required this.onSubmit,
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
            CustomTextField(
              controller: nameController,
              label: 'Name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: descriptionController,
              label: 'Description',
              icon: Icons.description_outlined,
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a description' : null,
            ),
            const SizedBox(height: 32),
            AddCourseButton(
              isLoading: isLoading,
              onPressed: isLoading ? null : onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
