part of 'group_time_tracker_bloc.dart';

@immutable
abstract class GroupTimeTrackerEvent {}

class SelectCourseEvent extends GroupTimeTrackerEvent {
  final String courseName;

  SelectCourseEvent(this.courseName);
}

class LoadAllGroupsDataEvent extends GroupTimeTrackerEvent {}

class SelectGroupEvent extends GroupTimeTrackerEvent {
  final String groupName;

  SelectGroupEvent(this.groupName);
}
