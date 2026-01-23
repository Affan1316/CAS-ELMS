import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/sort_option_enum.dart';

abstract class FeeAdminEvent extends Equatable {
  const FeeAdminEvent();

  @override
  List<Object?> get props => [];
}

abstract class InstallmentPageEvent extends Equatable {
  const InstallmentPageEvent();

  @override
  List<Object?> get props => [];
}

class FeeAdminFetchGroupsEvent extends FeeAdminEvent {
  const FeeAdminFetchGroupsEvent();
}

class FeeAdminGroupDataFilteringEvent extends FeeAdminEvent {
  final String query;
  const FeeAdminGroupDataFilteringEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class FeeAdminFetchGroupsStudentEvent extends FeeAdminEvent {
  final String groupTitle;
  const FeeAdminFetchGroupsStudentEvent({required this.groupTitle});

  @override
  List<Object?> get props => [groupTitle];
}

class FeeAdminGroupStudentsFilteringEvent extends FeeAdminEvent {
  final String query;
  const FeeAdminGroupStudentsFilteringEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class ResetFeeAdminStateEvent extends FeeAdminEvent {
  const ResetFeeAdminStateEvent();
}

class InstallmentPageCalculateInst extends FeeAdminEvent {
  final String installments;
  final String totalFee;

  const InstallmentPageCalculateInst({
    required this.installments,
    required this.totalFee,
  });

  @override
  List<Object?> get props => [installments, totalFee];
}

class CreateStudentInstallmentEvent extends FeeAdminEvent {
  final String studentId;
  final String name;
  final String groupId;
  final double totalFee;
  final int numberOfInstallments;
  final double paidAmount;
  final double amountPerMonth;

  const CreateStudentInstallmentEvent({
    required this.studentId,
    required this.name,
    required this.groupId,
    required this.totalFee,
    required this.numberOfInstallments,
    required this.paidAmount,
    required this.amountPerMonth,
  });

  @override
  List<Object?> get props => [
    studentId,
    name,
    groupId,
    totalFee,
    numberOfInstallments,
    paidAmount,
    amountPerMonth,
  ];
}

class GetStudentInstalmentEvent extends FeeAdminEvent {
  final String studentId;
  final String groupId;
  const GetStudentInstalmentEvent({
    required this.studentId,
    required this.groupId,
  });

  @override
  List<Object?> get props => [studentId, groupId];
}

class FetchFeesByDateRange extends FeeAdminEvent {
  final DateTime startDate;
  final DateTime endDate;
  const FetchFeesByDateRange(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

class FetchTodayFees extends FeeAdminEvent {
  const FetchTodayFees();
}

class UpdateSelectedDate extends FeeAdminEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  const UpdateSelectedDate({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class SortFees extends FeeAdminEvent {
  final SortOptionEnum option;
  const SortFees(this.option);

  @override
  List<Object?> get props => [option];
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

class AddFeeDefaulterEvent extends FeeAdminEvent {
  final String studentId;
  final String name;
  final String rollnum;
  final double remaingFee;
  final String group;

  const AddFeeDefaulterEvent({
    required this.studentId,
    required this.name,
    required this.rollnum,
    required this.remaingFee,
    required this.group,
  });

  @override
  List<Object?> get props => [studentId, name, rollnum, remaingFee, group];
}

class ReadFeeDefaulterEvent extends FeeAdminEvent {
  final String groupId;
  const ReadFeeDefaulterEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class ReadFeeDefaulterGroupsEvent extends FeeAdminEvent {
  const ReadFeeDefaulterGroupsEvent();
}

class RemoveStudentFromDefaultersEvent extends FeeAdminEvent {
  final String groupId;
  final String studentId;
  final double paidAmount;
  final double totalReaminingFeeForThisStudent;

  const RemoveStudentFromDefaultersEvent({
    required this.groupId,
    required this.studentId,
    required this.paidAmount,
    required this.totalReaminingFeeForThisStudent,
  });

  @override
  List<Object?> get props => [
    groupId,
    studentId,
    paidAmount,
    totalReaminingFeeForThisStudent,
  ];
}

class CheckFeeDefaulterEvent extends FeeAdminEvent {
  final String groupId;
  final String studentId;

  const CheckFeeDefaulterEvent({
    required this.groupId,
    required this.studentId,
  });

  @override
  List<Object?> get props => [groupId, studentId];
}

class AddToSuperAdminApprovalListEvent extends FeeAdminEvent {
  final StudentFeeFeatureEntityClass student;

  final int index;

  const AddToSuperAdminApprovalListEvent({
    required this.student,
    required this.index,
  });
}

class AddToPendingFee2Event extends FeeAdminEvent {
  final StudentFeeFeatureEntityClass student;
  final FeeInstallmentEntityClass instalment;
  final double paidAmount;
  final String paymentMethod;
  const AddToPendingFee2Event({
    required this.student,
    required this.instalment,
    required this.paidAmount,
    required this.paymentMethod,
  });
}
