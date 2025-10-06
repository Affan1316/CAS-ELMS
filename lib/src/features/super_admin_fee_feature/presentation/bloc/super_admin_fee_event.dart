abstract class SuperAdminFeeEvent {
  const SuperAdminFeeEvent();
}

class LoadSuperAdminFeeNotifications extends SuperAdminFeeEvent {}

class ConfirmSuperAdminFeePayment extends SuperAdminFeeEvent {
  final String id;

  final String studentId;
  const ConfirmSuperAdminFeePayment({
    required this.id,
    required this.studentId,
  });
}
