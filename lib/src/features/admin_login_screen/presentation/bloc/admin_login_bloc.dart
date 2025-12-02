// AdminLoginBloc.dart (MODIFIED)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_event.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_state.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/data/service/admin_storage_service.dart';

class AdminLoginBloc extends Bloc<AdminLoginEvent, AdminLoginState> {
  AdminLoginBloc() : super(AdminLoginInitial()) {
    on<AdminLoginInitialized>(_onInitialized);
    on<AdminLoginSubmitted>(_onLoginSubmitted);
    on<AdminLoginReset>(_onReset);
    on<AdminLogoutRequested>(_onLogoutRequested);
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

    if (event.adminId.trim().isEmpty || event.password.isEmpty) {
      emit(const AdminLoginFailure(message: 'Please fill in all fields'));
      return;
    }

    emit(AdminLoginLoading());

    try {
      // --- MODIFIED: Get the role from the service ---
      final AdminRole role = await AdminStorageService.verifyAdminLogin(
        event.adminId.trim(),
        event.password,
      );
      // --- END MODIFIED ---

      // --- MODIFIED: Check the role ---
      if (role != AdminRole.none) {
        await AdminStorageService.saveLoginSession(
          adminId: event.adminId.trim(),
          role: role,
        );
        print('Login successful with role: $role');
        // Pass the role to the success state
        emit(AdminLoginSuccess(role: role));
      } else {
        print('Login failed - invalid credentials');
        emit(const AdminLoginFailure(message: 'Invalid Admin ID or Password'));
      }
      // --- END MODIFIED ---
    } catch (e) {
      print('Login error: $e');
      emit(const AdminLoginFailure(message: 'Login failed. Please try again.'));
    }
  }

  void _onReset(AdminLoginReset event, Emitter<AdminLoginState> emit) {
    emit(AdminLoginInitial());
  }

  Future<void> _onLogoutRequested(
    AdminLogoutRequested event,
    Emitter<AdminLoginState> emit,
  ) async {
    print('🔐 Logout requested - starting logout process');

    try {
      emit(AdminLoginLoading());
      print('⏳ Loading state emitted');

      // Call logout (keeps credentials, clears session)
      await AdminStorageService.logout();
      print('✅ Storage logout completed - session cleared');

      // Small delay for smooth UX (optional)
      await Future.delayed(Duration(milliseconds: 500));

      // Reset to initial state
      emit(AdminLoginInitial());
      print('✅ User logged out successfully - credentials preserved');
      print(
        '✅ Admin can login again with: admin001/admin123 or superadmin/super123',
      );
    } catch (e) {
      print('❌ Logout error: $e');
      emit(
        const AdminLoginFailure(message: 'Logout failed. Please try again.'),
      );
    }
  }
}
