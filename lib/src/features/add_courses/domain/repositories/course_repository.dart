import 'package:flutter_cas_app_main/src/features/add_courses/domain/entities/course.dart';

abstract class CourseRepository {
  Future<void> addCourse(Course course);
  Future<List<Course>> getCourse();
}
