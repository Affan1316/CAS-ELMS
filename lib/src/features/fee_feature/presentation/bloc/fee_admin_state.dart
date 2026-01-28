import 'package:equatable/equatable.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulter_entity.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulters_collective.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/sort_option_enum.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/group_student_entity_class.dart';

abstract class FeeAdminState extends Equatable {
  const FeeAdminState();

  @override
  List<Object?> get props => [];
}

class FeeAdminInitialState extends FeeAdminState {
  const FeeAdminInitialState();
}

class FeeAdminGroupsLoadingState extends FeeAdminState {
  const FeeAdminGroupsLoadingState();
}

class FeeAdminGroupsLoadedState extends FeeAdminState {
  final List<GroupEntity> groups;
  const FeeAdminGroupsLoadedState({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class FeeAdminGroupDataFilteringCompleteState extends FeeAdminState {
  final List<GroupEntity> filteredDataList;
  const FeeAdminGroupDataFilteringCompleteState({
    required this.filteredDataList,
  });

  @override
  List<Object?> get props => [filteredDataList];
}

class FeeAdminErrorState extends FeeAdminState {
  final String error;
  const FeeAdminErrorState({required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => "FeeAdminErrorState: $error";
}

class FeeAdminGroupsStudentsLoadingState extends FeeAdminState {
  const FeeAdminGroupsStudentsLoadingState();
}

class FeeAdminGroupStudentsLoadedState extends FeeAdminState {
  final List<StudentFeatureGroupStudentEntityClass> dataList;
  const FeeAdminGroupStudentsLoadedState({required this.dataList});

  @override
  List<Object?> get props => [dataList];
}

class FeeAdminGroupStudentsFilteringCompleteState extends FeeAdminState {
  final List<StudentFeatureGroupStudentEntityClass> filteredDataList;
  const FeeAdminGroupStudentsFilteringCompleteState({
    required this.filteredDataList,
  });

  @override
  List<Object?> get props => [filteredDataList];
}

class InstallmentPageInstallmentCalculatedState extends FeeAdminState {
  final double installment;
  const InstallmentPageInstallmentCalculatedState({required this.installment});

  @override
  List<Object?> get props => [installment];
}

class InstallmentCreatingState extends FeeAdminState {
  const InstallmentCreatingState();
}

class InstallmentCreatedSuccessState extends FeeAdminState {
  const InstallmentCreatedSuccessState();
}

class InstallmentCreatedFailureState extends FeeAdminState {
  final String error;
  const InstallmentCreatedFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class StudentInstalmentLoadingState extends FeeAdminState {
  const StudentInstalmentLoadingState();
}

class StudentLoadedState extends FeeAdminState {
  final StudentFeeFeatureEntityClass student;
  const StudentLoadedState(this.student);

  @override
  List<Object?> get props => [student];
}

class StudentLoadFailureState extends FeeAdminState {
  final String error;
  const StudentLoadFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

class FeeHistoryLoading extends FeeAdminState {
  const FeeHistoryLoading();
}

class FeeHistoryError extends FeeAdminState {
  final String message;
  const FeeHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class FeeHistoryLoaded extends FeeAdminState {
  final List<FeeEntityClass> fees;
  final DateTime? startDate;
  final DateTime? endDate;
  final SortOptionEnum sortOption;
  final double cashPaymentTotal;
  final double JazzCashTotal;
  final double UBLTotal;
  final double easyPaisaTotal;

  const FeeHistoryLoaded({
    required this.fees,
    this.startDate,
    this.endDate,
    required this.sortOption,
    required this.cashPaymentTotal,
    required this.JazzCashTotal,
    required this.UBLTotal,
    required this.easyPaisaTotal,
  });

  FeeHistoryLoaded copyWith({
    List<FeeEntityClass>? fees,
    DateTime? startDate,
    DateTime? endDate,
    SortOptionEnum? sortOption,
    double? cashPaymentTotal,
    double? JazzCashTotal,
    double? UBLTotal,
    double? easyPaisaTotal,
  }) {
    return FeeHistoryLoaded(
      fees: fees ?? this.fees,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortOption: sortOption ?? this.sortOption,
      cashPaymentTotal: cashPaymentTotal ?? this.cashPaymentTotal,
      JazzCashTotal: JazzCashTotal ?? this.JazzCashTotal,
      UBLTotal: UBLTotal ?? this.UBLTotal,
      easyPaisaTotal: easyPaisaTotal ?? this.easyPaisaTotal,
    );
  }

  double get totalAmount => fees.fold(0, (sum, fee) => sum + fee.paidAmount);

  @override
  List<Object?> get props => [
    fees,
    startDate,
    endDate,
    sortOption,
    cashPaymentTotal,
    JazzCashTotal,
    UBLTotal,
    easyPaisaTotal,
  ];
}

class FeeDefaultersDataLoaded extends FeeAdminState {
  final List<FeeDefaulterEntity> listOFFeeDefaulterEntity;
  final FeeDefaultersCollective? feeDefaultersCollective;
  final DateTime emittedAt;

  const FeeDefaultersDataLoaded({
    required this.listOFFeeDefaulterEntity,
    required this.feeDefaultersCollective,
    required this.emittedAt,
  });

  @override
  List<Object?> get props => [
    listOFFeeDefaulterEntity,
    feeDefaultersCollective,
    emittedAt,
  ];
}

class GroupNamesReadCompleted extends FeeAdminState {
  final List<String> listOFGroupNames;
  const GroupNamesReadCompleted({required this.listOFGroupNames});

  @override
  List<Object?> get props => [listOFGroupNames];
}

class GroupDataEmpty extends FeeAdminState {
  final String groupId;
  const GroupDataEmpty({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class AddingFeeDefaulterCompleteState extends FeeAdminState {
  const AddingFeeDefaulterCompleteState();

  @override
  List<Object?> get props => [];
}

class CheckingingFeeDefaulterCompleteState extends FeeAdminState {
  final bool isDefaulter;
  const CheckingingFeeDefaulterCompleteState({required this.isDefaulter});

  @override
  List<Object?> get props => [isDefaulter];
}

class FeeHistoryPaymentMethodBasedCalculationStarted extends FeeAdminState {}

class AddedToPendingFee extends FeeAdminState {
  final StudentFeeFeatureEntityClass student;

  const AddedToPendingFee({required this.student});
}

class DayWiseFeesLoaded extends FeeAdminState {
  final Map<DateTime, double> dayWiseFees;
  final DateTime? startDate;
  final DateTime? endDate;

  DayWiseFeesLoaded({required this.dayWiseFees, this.startDate, this.endDate});

  DayWiseFeesLoaded copyWith({
    Map<DateTime, double>? dayWiseFees,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DayWiseFeesLoaded(
      dayWiseFees: dayWiseFees ?? this.dayWiseFees,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
