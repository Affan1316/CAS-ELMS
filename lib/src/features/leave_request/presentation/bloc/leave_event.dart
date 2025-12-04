part of 'leave_bloc.dart';

abstract class LeaveEvent {
  const LeaveEvent();
}

class SubmitLeaveRequest extends LeaveEvent {
  final String status;
  final String section;
  final String studentName;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String reason;
  final String currentDate;

  SubmitLeaveRequest({
    required this.status,
    required this.section,
    required this.studentName,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.currentDate,
  });
}

class FetchLeaveRequest extends LeaveEvent {
  final String? studentName;
  final bool isAdmin;

  const FetchLeaveRequest({
    this.studentName,
    this.isAdmin = false,
  });
}

class LeaveStatusUpdateEvent extends LeaveEvent {
  final Leave leave;
  LeaveStatusUpdateEvent(this.leave);
}

// class DeleteLeaveEvent extends LeaveEvent {
//   final String leaveId;
//   const DeleteLeaveEvent(this.leaveId);
// }