import 'package:equatable/equatable.dart';

abstract class AdminLoginEvent extends Equatable {
  const AdminLoginEvent();

  @override
  List<Object> get props => [];
}

class AdminLoginInitialized extends AdminLoginEvent {}

class AdminLoginSubmitted extends AdminLoginEvent {
  final String adminId;
  final String password;

  const AdminLoginSubmitted({required this.adminId, required this.password});

  @override
  List<Object> get props => [adminId, password];
}

class AdminLoginReset extends AdminLoginEvent {}
