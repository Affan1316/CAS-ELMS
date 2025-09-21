import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';

abstract class FeeAdminEvent {
  const FeeAdminEvent();
}

class FeeAdminFetchGroupsEvent extends FeeAdminEvent {}

class FeeAdminGroupDataFilteringEvent extends FeeAdminEvent {
  final String query;
  FeeAdminGroupDataFilteringEvent({required this.query});
}

class FeeAdminFetchGroupsStudentEvent extends FeeAdminEvent {
  final String groupTitle;
  FeeAdminFetchGroupsStudentEvent({required this.groupTitle});
}

class FeeAdminGroupStudentsFilteringEvent extends FeeAdminEvent {
  final String query;
  FeeAdminGroupStudentsFilteringEvent({required this.query});
}

abstract class InstallmentPageEvent {
  const InstallmentPageEvent();
}

class ResetFeeAdminStateEvent extends FeeAdminEvent {}

/// ✅ Calculate per-installment amount
class InstallmentPageCalculateInst extends FeeAdminEvent {
  final String installments;
  final String totalFee;

  const InstallmentPageCalculateInst({
    required this.installments,
    required this.totalFee,
  });
}

/// ✅ Create a student with installments
class CreateStudentInstallmentEvent extends FeeAdminEvent {
  final String studentId;
  final String name;
  final String groupId;
  final double totalFee;
  final int numberOfInstallments;
  final double paidAmount;

  const CreateStudentInstallmentEvent({
    required this.studentId,
    required this.name,
    required this.groupId,
    required this.totalFee,
    required this.numberOfInstallments,

    required this.paidAmount,
  });
}

/// ✅ Fetch student data
class GetStudentInstalmentEvent extends FeeAdminEvent {
  final String studentId;

  const GetStudentInstalmentEvent({required this.studentId});
}

class UpdateStudentInstalmentEvent extends FeeAdminEvent {
  final String studentId;
  final String installmentId;
  final double paidAmount;

  final DateTime paidDate;

  final String paymentMethod;

  UpdateStudentInstalmentEvent({
    required this.installmentId,
    required this.paidAmount,
    required this.studentId,
    required this.paidDate,
    required this.paymentMethod,
  });
}
