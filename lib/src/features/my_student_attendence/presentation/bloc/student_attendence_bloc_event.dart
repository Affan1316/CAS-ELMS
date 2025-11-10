part of 'student_attendence_bloc_bloc.dart';


// BLoC Events
abstract class AttendanceEvent {}

/// Event to signal the BLoC to load the attendance data
class LoadAttendance extends AttendanceEvent {}
class LocationCheckEvent extends AttendanceEvent {}