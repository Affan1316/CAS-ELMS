part of 'student_attendence_bloc_bloc.dart';

// BLoC States
abstract class AttendanceState {}

/// Initial state, shows a loading indicator
class AttendanceLoading extends AttendanceState {}

/// State when data has been successfully loaded
class AttendanceLoaded extends AttendanceState {
  final Student student;
  final List<AttendanceRecord> records;

  AttendanceLoaded({required this.student, required this.records});
}

/// State for when data loading fails
class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError({required this.message});
}
