import 'package:flutter_cas_app_main/src/features/add_courses/data/datasources/course_remote_data_source.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/data/repositories/course_repository_impl.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/domain/repositories/course_repository.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/domain/usecases/create_course.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/domain/usecases/get_course.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/presentation/bloc/add_course_bloc.dart';
import 'package:get_it/get_it.dart';

Future<void> initCourses(GetIt sl) async {
  
  // DataSource
  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSource(sl()),
  );

  // Repository (register only the abstraction with its implementation)
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton<CreateCourse>(
    () => CreateCourse(sl()),
  );

  sl.registerLazySingleton<GetCourses>(
    () => GetCourses(sl())
  );

  // Bloc
  sl.registerFactory<AddCourseBloc>(
    () => AddCourseBloc(sl(),sl()),
  );
}
