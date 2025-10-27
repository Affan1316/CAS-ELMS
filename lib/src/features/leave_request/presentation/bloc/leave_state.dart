part of 'leave_bloc.dart';

abstract class LeaveState{
  const LeaveState();
}

class LeaveInitial extends LeaveState {}

class LeaveLoading extends LeaveState {}

class LeaveSuccess extends LeaveState {}

class LeaveFailure extends LeaveState {
  final String message;
  LeaveFailure(this.message);
}

class LeaveListLoaded extends LeaveState {
  final List<Leave> leaves;
  LeaveListLoaded(this.leaves);
}

class LeaveStatusUpdated extends LeaveState {}

class LeaveStatusUpdateFailed extends LeaveState {
  final String error;
  LeaveStatusUpdateFailed(this.error);
}


