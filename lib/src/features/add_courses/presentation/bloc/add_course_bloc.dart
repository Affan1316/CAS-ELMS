import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/domain/entities/course.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/domain/usecases/create_course.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/domain/usecases/get_course.dart';
import 'package:meta/meta.dart';

part 'add_course_event.dart';
part 'add_course_state.dart';

class AddCourseBloc extends Bloc<AddCourseEvent, AddCourseState> {
  final CreateCourse createCourse;
  final GetCourses getCourses;

  AddCourseBloc(this.createCourse, this.getCourses)
    : super(AddCourseInitial()) {
    on<SubmitCourse>((event, emit) async {
      emit(AddCourseLoading());
      try {
        final course = Course(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: event.name,
          description: event.description,
        );
        await createCourse(course);
        emit(AddCourseSuccess());
      } catch (e) {
        if (e.toString().contains("Course already Exits")) {
          emit(AddCourseFailure(message: "Course already Exits"));
        }else{
          emit(AddCourseFailure(message: "Something went wrong"));
        }
      }
    });

    on<LoadCourses>((event, emit) async {
      emit(AddCourseLoading());
      try {
        final courses = await getCourses();
        emit(CourseLoaded(courses));
      } catch (e) {
        emit(AddCourseFailure(message: "Something went wrong"));
      }
    });
  }
}
