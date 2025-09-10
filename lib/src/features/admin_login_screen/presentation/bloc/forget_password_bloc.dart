import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/forget_password_event.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/forget_password_state.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/data/service/admin_storage_service.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/page/admin_login_page.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<AdminIdVerificationRequested>(_onAdminIdVerificationRequested);
    on<PasswordChangeRequested>(_onPasswordChangeRequested);
    on<ForgotPasswordReset>(_onReset);
  }

  Future<void> _onAdminIdVerificationRequested(
    AdminIdVerificationRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (event.adminId.trim().isEmpty) {
      emit(const AdminIdVerificationFailed(message: 'Please enter Admin ID'));
      return;
    }

    emit(ForgotPasswordLoading());

    try {
      final bool isValid = await AdminStorageService.verifyAdminId(
        event.adminId.trim(),
      );

      if (isValid) {
        emit(AdminIdVerified(adminId: event.adminId.trim()));
      } else {
        emit(const AdminIdVerificationFailed(message: 'Invalid Admin ID'));
      }
    } catch (e) {
      emit(
        const AdminIdVerificationFailed(
          message: 'Verification failed. Please try again.',
        ),
      );
    }
  }

  Future<void> _onPasswordChangeRequested(
    PasswordChangeRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (event.newPassword.isEmpty || event.confirmPassword.isEmpty) {
      emit(const PasswordChangeFailure(message: 'Please fill in all fields'));
      return;
    }

    if (event.newPassword != event.confirmPassword) {
      emit(const PasswordChangeFailure(message: 'Passwords do not match'));
      return;
    }

    if (event.newPassword.length < 6) {
      emit(
        const PasswordChangeFailure(
          message: 'Password must be at least 6 characters',
        ),
      );
      return;
    }

    emit(ForgotPasswordLoading());

    try {
      final bool success = await AdminStorageService.changeAdminPassword(
        event.adminId,
        event.newPassword,
      );

      if (success) {
        emit(PasswordChangeSuccess());
      } else {
        emit(const PasswordChangeFailure(message: 'Failed to change password'));
      }
    } catch (e) {
      emit(
        const PasswordChangeFailure(
          message: 'Password change failed. Please try again.',
        ),
      );
    }
  }

  void _onReset(ForgotPasswordReset event, Emitter<ForgotPasswordState> emit) {
    emit(ForgotPasswordInitial());
  }
}
