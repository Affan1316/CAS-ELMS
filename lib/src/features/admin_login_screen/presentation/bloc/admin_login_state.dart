// In your admin_login_state.dart file (You must make this change)

// Make sure you import the service file to get the enum
import 'package:equatable/equatable.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/data/service/admin_storage_service.dart';

abstract class AdminLoginState extends Equatable {
  const AdminLoginState();
  @override
  List<Object> get props => [];
}

class AdminLoginInitial extends AdminLoginState {}

class AdminLoginLoading extends AdminLoginState {}

// --- MODIFY THIS CLASS ---
class AdminLoginSuccess extends AdminLoginState {
  // Add this property
  final AdminRole role;

  // Add 'required' to the constructor
  const AdminLoginSuccess({required this.role});

  // Add 'role' to the props
  @override
  List<Object> get props => [role];
}
// --- END MODIFICATION ---

class AdminLoginFailure extends AdminLoginState {
  final String message;
  const AdminLoginFailure({required this.message});
  @override
  List<Object> get props => [message];
}
