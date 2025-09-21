import 'package:equatable/equatable.dart';
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

/// ✅ Calculation result
class InstallmentPageInstallmentCalculatedState extends FeeAdminState {
  final double installment;

  const InstallmentPageInstallmentCalculatedState({required this.installment});

  @override
  List<Object?> get props => [installment];
}

/// ✅ Student creation process
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

/// ✅ Student fetch process
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

class UpdateStudentInstalmentLoadingState extends FeeAdminState {
  const UpdateStudentInstalmentLoadingState();
}

class UpdatedStudentInstalmentState extends FeeAdminState {
  const UpdatedStudentInstalmentState();
}

class FeeHistoryLoading extends FeeAdminState {}

class FeeHistoryError extends FeeAdminState {
  final String message;
  const FeeHistoryError(this.message);
}

class FeeHistoryLoaded extends FeeAdminState {
  final List<FeeEntityClass> fees;
  final DateTime? startDate;
  final DateTime? endDate;
  final SortOptionEnum sortOption;

  FeeHistoryLoaded({
    required this.fees,
    this.startDate,
    this.endDate,
    required this.sortOption,
  });

  FeeHistoryLoaded copyWith({
    List<FeeEntityClass>? fees,
    DateTime? startDate,
    DateTime? endDate,
    SortOptionEnum? sortOption,
  }) {
    return FeeHistoryLoaded(
      fees: fees ?? this.fees,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  double get totalAmount => fees.fold(0, (sum, fee) => sum + fee.paidAmount);
}
