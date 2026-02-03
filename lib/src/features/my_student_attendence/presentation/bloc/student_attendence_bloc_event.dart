part of 'student_attendence_bloc_bloc.dart';

// BLoC Events
abstract class AttendanceEvent {}

/// Event to signal the BLoC to load the attendance data
class LoadAttendance extends AttendanceEvent {
  final String? rollNo;
  final String? name;
  final DateTimeRange<DateTime>? dateRange;

  LoadAttendance({this.rollNo, this.name, this.dateRange});
}

class LocationCheckEvent extends AttendanceEvent {}
