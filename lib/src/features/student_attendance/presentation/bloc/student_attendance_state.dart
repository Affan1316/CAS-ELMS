part of 'student_attendance_bloc.dart';

sealed class StudentAttendanceState extends Equatable {
  const StudentAttendanceState();
  
  @override
  List<Object> get props => [];
}

final class StudentAttendanceInitial extends StudentAttendanceState {}

final class StudentAttendanceLoadingState extends StudentAttendanceState {}

final class StudentAttendanceLoadedState extends StudentAttendanceState{
  final List<Attendance> attendanceList;
  const StudentAttendanceLoadedState({required this.attendanceList});
}

final class StudentAttendanceErorState extends StudentAttendanceState{
  final String message;
  const StudentAttendanceErorState({required this.message});
}
