import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class AdminIdVerificationRequested extends ForgotPasswordEvent {
  final String adminId;

  const AdminIdVerificationRequested({required this.adminId});

  @override
  List<Object> get props => [adminId];
}

class PasswordChangeRequested extends ForgotPasswordEvent {
  final String adminId;
  final String newPassword;
  final String confirmPassword;

  const PasswordChangeRequested({
    required this.adminId,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [adminId, newPassword, confirmPassword];
}

class ForgotPasswordReset extends ForgotPasswordEvent {}
