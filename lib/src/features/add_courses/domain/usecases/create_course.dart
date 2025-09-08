import 'package:flutter_cas_app_main/src/features/add_courses/domain/entities/course.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/domain/repositories/course_repository.dart';

class CreateCourse{
  final CourseRepository courseRepository;

  CreateCourse(this.courseRepository);

  Future<void> call(Course course) {
    return courseRepository.addCourse(course);
  }
}
