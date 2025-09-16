part of 'installment_page_bloc.dart';

abstract class InstallmentPageState extends Equatable {
  const InstallmentPageState();

  @override
  List<Object> get props => [];
}

class InstallmentPageInitial extends InstallmentPageState {}

class InstallmentPageintallmentCalculatedState extends InstallmentPageState {
  final double installment;

  const InstallmentPageintallmentCalculatedState({required this.installment});

  @override
  List<Object> get props => [installment];
}

class InstallmentCreatingState extends InstallmentPageState {}

class InstallmentCreatedSuccessState extends InstallmentPageState {}

class InstallmentCreatedFailureState extends InstallmentPageState {
  final String error;

  const InstallmentCreatedFailureState({required this.error});

  @override
  List<Object> get props => [error];
}
