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
    print("🔍 CourseDropdown - courses: $courses"); // Debug print
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Interested',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Theme(
          data: ThemeData.light().copyWith(
            canvasColor: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            initialValue: courses.contains(selectedCourse) ? selectedCourse : null,
            hint: Text(
              courses.isEmpty ? 'Loading courses...' : 'Select a course',
              style: const TextStyle(color: Color(0xFF9CA3AF)),
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
            dropdownColor: Colors.white,
            items: courses.isEmpty
                ? null
                : courses
                    .map(
                      (course) => DropdownMenuItem(
                        value: course,
                        child: Text(course),
                      ),
                    )
                    .toList(),
            onChanged: courses.isEmpty ? null : onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
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
        ),
      ],
    );
  }
}