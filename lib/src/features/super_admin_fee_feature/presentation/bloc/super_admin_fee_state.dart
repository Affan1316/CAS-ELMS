abstract class SuperAdminFeeState {
  const SuperAdminFeeState();
}

class SuperAdminFeeInitialState extends SuperAdminFeeState {}

class SuperAdminFeeLoadingState extends SuperAdminFeeState {}

class SuperAdminFeeLoadedState extends SuperAdminFeeState {
  final List<Map<String, dynamic>> notifications;
  final int version;
  final bool isJustCompleted; // ← add this

  SuperAdminFeeLoadedState(
    this.notifications, {
    this.version = 0,
    this.isJustCompleted = false, // ← defaults false
  });
}

class SuperAdminFeeErrorState extends SuperAdminFeeState {
  final String message;

  SuperAdminFeeErrorState(this.message);
}

// class DeletingNotification extends SuperAdminFeeState {}

// class DeletedNotification extends SuperAdminFeeState {
//   final List<Map<String, dynamic>> notifications;

//   DeletedNotification(this.notifications);
// }

class ConfirmingPayment extends SuperAdminFeeState {
  const ConfirmingPayment();
}

class GroupFeeHistoryInitial extends SuperAdminFeeState {}

class GroupFeeHistoryLoaded extends SuperAdminFeeState {
  final double total;

  final double received;

  final double remaining;

  GroupFeeHistoryLoaded({
    required this.total,
    required this.received,
    required this.remaining,
  });
}

class LoadingGroupNames extends SuperAdminFeeState {
  const LoadingGroupNames();
}

class GroupNamesLoaded extends SuperAdminFeeState {
  final List<String> listOfNames;
  const GroupNamesLoaded({required this.listOfNames});
}

class BulkPaymentInProgress extends SuperAdminFeeState {
  final List<Map<String, dynamic>> notifications; // keep showing old data
  const BulkPaymentInProgress(this.notifications);
}

class BulkPaymentCompleted extends SuperAdminFeeState {
  const BulkPaymentCompleted();
}

class BulkPaymentFailed extends SuperAdminFeeState {
  final List<Map<String, dynamic>> restoredNotifications;
  final String message;
  final int version;

  const BulkPaymentFailed({
    required this.restoredNotifications,
    required this.message,
    required this.version,
  });
}
