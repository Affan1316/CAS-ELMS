part of 'group_time_tracker_bloc.dart';

@immutable
abstract class GroupTimeTrackerState {
  const GroupTimeTrackerState();
}

class GroupTimeTrackerInitial extends GroupTimeTrackerState {}

class GroupTimeTrackerLoading extends GroupTimeTrackerState {}

class GroupLoaded extends GroupTimeTrackerState {
  final List<String> groupNames;
  final String courseName;
  const GroupLoaded({required this.groupNames, required this.courseName});
}

class GroupTimeTrackerError extends GroupTimeTrackerState {
  final String? error;
  const GroupTimeTrackerError({this.error});
}
