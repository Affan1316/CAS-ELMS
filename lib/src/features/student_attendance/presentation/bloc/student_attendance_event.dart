part of 'student_attendance_bloc.dart';

sealed class StudentAttendanceEvent {
  const StudentAttendanceEvent();
}

final class LoadAttendanceEvent extends StudentAttendanceEvent {
  final String studentId;
  const LoadAttendanceEvent({required this.studentId});
}
