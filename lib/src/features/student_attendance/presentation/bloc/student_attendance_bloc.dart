import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/domain/entities/attendance.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/domain/usecases/get_attendance_usecase.dart';

part 'student_attendance_event.dart';
part 'student_attendance_state.dart';

class StudentAttendanceBloc
    extends Bloc<StudentAttendanceEvent, StudentAttendanceState> {
  GetAttendanceUsecase getAttendance;
  StudentAttendanceBloc({required this.getAttendance})
    : super(StudentAttendanceInitial()) {
      
    on<LoadAttendanceEvent>((event, emit) async {
      emit(StudentAttendanceLoadingState());
      try {
        final list = await getAttendance(event.studentId);
        emit(StudentAttendanceLoadedState(attendanceList: list));
      } catch (e) {
        emit(StudentAttendanceErorState(message: e.toString()));
      }
    });
  }
}
