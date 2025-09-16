// part of 'installment_page_bloc.dart';

// abstract class InstallmentPageState extends Equatable {
//   const InstallmentPageState();

//   @override
//   List<Object> get props => [];
// }

// class InstallmentPageInitial extends InstallmentPageState {}

// class InstallmentPageintallmentCalculatedState extends InstallmentPageState {
//   final double installment;

//   const InstallmentPageintallmentCalculatedState({required this.installment});

//   @override
//   List<Object> get props => [installment];
// }

// class InstallmentCreatingState extends InstallmentPageState {}

// class InstallmentCreatedSuccessState extends InstallmentPageState {}

// class InstallmentCreatedFailureState extends InstallmentPageState {
//   final String error;

//   const InstallmentCreatedFailureState({required this.error});

//   @override
//   List<Object> get props => [error];
// }

import 'package:equatable/equatable.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/fee_installment.dart';

abstract class InstallmentPageState extends Equatable {
  const InstallmentPageState();

  @override
  List<Object?> get props => [];
}

class InstallmentPageInitial extends InstallmentPageState {}

/// ✅ Calculation result
class InstallmentPageInstallmentCalculatedState extends InstallmentPageState {
  final double installment;

  const InstallmentPageInstallmentCalculatedState({required this.installment});

  @override
  List<Object?> get props => [installment];
}

/// ✅ Student creation process
class InstallmentCreatingState extends InstallmentPageState {}

class InstallmentCreatedSuccessState extends InstallmentPageState {}

class InstallmentCreatedFailureState extends InstallmentPageState {
  final String error;

  const InstallmentCreatedFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

/// ✅ Student fetch process
class StudentLoadingState extends InstallmentPageState {}

class StudentLoadedState extends InstallmentPageState {
  final StudentFeeFeature student;

  const StudentLoadedState(this.student);

  @override
  List<Object?> get props => [student];
}

class StudentLoadFailureState extends InstallmentPageState {
  final String error;

  const StudentLoadFailureState(this.error);

  @override
  List<Object?> get props => [error];
}
