abstract class SuperAdminFeeState {
  const SuperAdminFeeState();
}

class SuperAdminFeeInitialState extends SuperAdminFeeState {}

class SuperAdminFeeLoadingState extends SuperAdminFeeState {}

class SuperAdminFeeLoadedState extends SuperAdminFeeState {
  final List<Map<String, dynamic>> notifications;

  SuperAdminFeeLoadedState(this.notifications);
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
