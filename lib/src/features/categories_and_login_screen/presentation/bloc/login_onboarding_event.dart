import 'package:equatable/equatable.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class NextPageEvent extends OnboardingEvent {}

class PreviousPageEvent extends OnboardingEvent {}

class SelectRoleEvent extends OnboardingEvent {
  final String role;
  const SelectRoleEvent(this.role);

  @override
  List<Object> get props => [role];
}

class SelectInterestEvent extends OnboardingEvent {
  final String interest;
  const SelectInterestEvent(this.interest);

  @override
  List<Object> get props => [interest];
}

class LoginEvent extends OnboardingEvent {
  final String userId;
  // final String password;
  const LoginEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class ReadStudentNameFromFireBaseEvent extends OnboardingEvent {
  final String id;
  const ReadStudentNameFromFireBaseEvent({required this.id});
}
