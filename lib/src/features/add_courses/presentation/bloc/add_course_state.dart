part of 'add_course_bloc.dart';

@immutable
abstract class AddCourseState {}

class AddCourseInitial extends AddCourseState {}

class AddCourseLoading extends AddCourseState {}

class AddCourseSuccess extends AddCourseState {}

class AddCourseFailure extends AddCourseState {
  
  AddCourseFailure({required String message});
}

class CourseLoaded extends AddCourseState {
  final List<Course> courses;
  CourseLoaded(this.courses);
}
