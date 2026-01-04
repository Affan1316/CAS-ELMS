// presentation/bloc/super_admin_fee_event.dart

abstract class SuperAdminFeeEvent {}

class LoadSuperAdminFeeNotifications extends SuperAdminFeeEvent {}

class ConfirmSuperAdminFeePayment extends SuperAdminFeeEvent {
  final String id;
  final String studentId;

  ConfirmSuperAdminFeePayment({required this.id, required this.studentId});
}

// New event for bulk confirmation
class ConfirmBulkSuperAdminFeePayments extends SuperAdminFeeEvent {
  final List<Map<String, String>> payments;

  ConfirmBulkSuperAdminFeePayments({required this.payments});
}

class FetchGroupFeeHistoryEvent extends SuperAdminFeeEvent {
  final String groupName;

  FetchGroupFeeHistoryEvent({required this.groupName});
}

class GetGroupNamesEvent extends SuperAdminFeeEvent {}

// Internal event used by the bloc to update per-group cached summaries
class UpdateGroupSummaryEvent extends SuperAdminFeeEvent {
  final String groupName;
  final dynamic summary; // GroupFeeHistory or null

  UpdateGroupSummaryEvent({required this.groupName, required this.summary});
}
