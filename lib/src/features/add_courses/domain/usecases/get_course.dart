import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourses {
  final CourseRepository courseRepository;

  GetCourses(this.courseRepository);

  Future<List<Course>> call() async {
    return await courseRepository.getCourse();
  }
}
