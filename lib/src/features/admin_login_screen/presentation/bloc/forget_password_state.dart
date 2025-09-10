import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class AdminIdVerified extends ForgotPasswordState {
  final String adminId;

  const AdminIdVerified({required this.adminId});

  @override
  List<Object> get props => [adminId];
}

class AdminIdVerificationFailed extends ForgotPasswordState {
  final String message;

  const AdminIdVerificationFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class PasswordChangeSuccess extends ForgotPasswordState {}

class PasswordChangeFailure extends ForgotPasswordState {
  final String message;

  const PasswordChangeFailure({required this.message});

  @override
  List<Object> get props => [message];
}
