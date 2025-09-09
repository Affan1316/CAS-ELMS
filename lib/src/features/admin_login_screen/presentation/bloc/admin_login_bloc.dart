import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_event.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_state.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/data/service/admin_storage_service.dart';

class AdminLoginBloc extends Bloc<AdminLoginEvent, AdminLoginState> {
  AdminLoginBloc() : super(AdminLoginInitial()) {
    on<AdminLoginInitialized>(_onInitialized);
    on<AdminLoginSubmitted>(_onLoginSubmitted);
    on<AdminLoginReset>(_onReset);
  }

  Future<void> _onInitialized(
    AdminLoginInitialized event,
    Emitter<AdminLoginState> emit,
  ) async {
    try {
      await AdminStorageService.initializeDefaultAdmin();
      emit(AdminLoginInitial());
    } catch (e) {
      print('Error initializing admin: $e');
      emit(AdminLoginInitial());
    }
  }

  Future<void> _onLoginSubmitted(
    AdminLoginSubmitted event,
    Emitter<AdminLoginState> emit,
  ) async {
    print(
      'Login submitted - AdminId: ${event.adminId}, Password: ${event.password}',
    );

    // Validate input fields
    if (event.adminId.trim().isEmpty || event.password.isEmpty) {
      emit(const AdminLoginFailure(message: 'Please fill in all fields'));
      return;
    }

    emit(AdminLoginLoading());

    try {
      final bool isValid = await AdminStorageService.verifyAdminLogin(
        event.adminId.trim(),
        event.password,
      );

      if (isValid) {
        print('Login successful');
        emit(AdminLoginSuccess());
      } else {
        print('Login failed - invalid credentials');
        emit(const AdminLoginFailure(message: 'Invalid Admin ID or Password'));
      }
    } catch (e) {
      print('Login error: $e');
      emit(const AdminLoginFailure(message: 'Login failed. Please try again.'));
    }
  }

  void _onReset(AdminLoginReset event, Emitter<AdminLoginState> emit) {
    emit(AdminLoginInitial());
  }
}
