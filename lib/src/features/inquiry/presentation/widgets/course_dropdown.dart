import 'package:flutter/material.dart';

class CourseDropdown extends StatelessWidget {
  final String? selectedCourse;
  final List<String> courses;
  final ValueChanged<String?> onChanged;

  const CourseDropdown({
    super.key,
    required this.selectedCourse,
    required this.courses,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Course Interested', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
      initialValue: courses.contains(selectedCourse) ? selectedCourse : null,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: courses
          .map((course) =>
              DropdownMenuItem(value: course, child: Text(course)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    )
    ]
    );
  }
}
