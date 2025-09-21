import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/sort_option_enum.dart';
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

class FetchFeesByDateRange extends FeeAdminEvent {
  final DateTime startDate;
  final DateTime endDate;
  FetchFeesByDateRange(this.startDate, this.endDate);
}

class FetchTodayFees extends FeeAdminEvent {}

class UpdateSelectedDate extends FeeAdminEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  UpdateSelectedDate({this.startDate, this.endDate});
}

class SortFees extends FeeAdminEvent {
  final SortOptionEnum option;
  SortFees(this.option);
}

extension SortOptionExt on SortOptionEnum {
  String get title {
    switch (this) {
      case SortOptionEnum.dateDesc:
        return 'Date: New → Old';
      case SortOptionEnum.dateAsc:
        return 'Date: Old → New';
      case SortOptionEnum.amountDesc:
        return 'Amount: High → Low';
      case SortOptionEnum.amountAsc:
        return 'Amount: Low → High';
    }
  }

  IconData get icon {
    switch (this) {
      case SortOptionEnum.dateDesc:
        return Icons.arrow_downward;
      case SortOptionEnum.dateAsc:
        return Icons.arrow_upward;
      case SortOptionEnum.amountDesc:
        return Icons.trending_down;
      case SortOptionEnum.amountAsc:
        return Icons.trending_up;
    }
  }
}
