import 'package:flutter_cas_app_main/src/features/add_courses/data/datasources/course_remote_data_source.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/data/models/course_model.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/domain/entities/course.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addCourse(Course course) {
    final model = CourseModel(
      id: course.id,
      name: course.name,
      description: course.description,
    );
    return remoteDataSource.addCourses(model);
  }

  @override
  Future<List<Course>> getCourse() async {
    return await remoteDataSource.getCourses();
  }
}
