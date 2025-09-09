part of 'add_course_bloc.dart';

@immutable
abstract class AddCourseEvent {}

class SubmitCourse extends AddCourseEvent {
  final String name;
  final String description;

  SubmitCourse(this.name, this.description);
}

class LoadCourses extends AddCourseEvent{}
