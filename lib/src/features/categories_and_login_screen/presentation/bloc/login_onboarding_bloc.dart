import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInitial()) {
    on<NextPageEvent>((event, emit) {
      final currentState = state as OnboardingInitial;
      if (currentState.currentPage < 2) {
        emit(
          OnboardingInitial(
            currentPage: currentState.currentPage + 1,
            selectedRole: currentState.selectedRole,
            selectedInterests: currentState.selectedInterests,
            shouldShake: false,
          ),
        );
      }
    });

    on<PreviousPageEvent>((event, emit) {
      final currentState = state as OnboardingInitial;
      if (currentState.currentPage > 0) {
        emit(
          OnboardingInitial(
            currentPage: currentState.currentPage - 1,
            selectedRole: currentState.selectedRole,
            selectedInterests: currentState.selectedInterests,
            shouldShake: false,
          ),
        );
      }
    });

    on<SelectRoleEvent>((event, emit) {
      final currentState = state as OnboardingInitial;
      emit(
        OnboardingInitial(
          currentPage: currentState.currentPage,
          selectedRole: event.role,
          selectedInterests: currentState.selectedInterests,
          shouldShake: false,
        ),
      );
    });

    on<SelectInterestEvent>((event, emit) {
      final currentState = state as OnboardingInitial;
      List<String> newInterests = List.from(currentState.selectedInterests);

      if (newInterests.contains(event.interest)) {
        newInterests.remove(event.interest);
      } else {
        newInterests.add(event.interest);
      }

      emit(
        OnboardingInitial(
          currentPage: currentState.currentPage,
          selectedRole: currentState.selectedRole,
          selectedInterests: newInterests,
          shouldShake: false,
        ),
      );
    });

    on<LoginEvent>((event, emit) async {
      final currentState = state as OnboardingInitial;
      if (event.userId.trim().isEmpty) {
        // Trigger shake animation
        emit(
          OnboardingInitial(
            currentPage: currentState.currentPage,
            selectedRole: currentState.selectedRole,
            selectedInterests: currentState.selectedInterests,
            shouldShake: true,
          ),
        );

        // Wait for animation to complete
        await Future.delayed(const Duration(milliseconds: 500));

        // Reset shake after animation - only if emitter is still active
        if (!emit.isDone) {
          emit(
            OnboardingInitial(
              currentPage: currentState.currentPage,
              selectedRole: currentState.selectedRole,
              selectedInterests: currentState.selectedInterests,
              shouldShake: false,
            ),
          );
        }
      } else {
        // Navigate to main app
        print('Login successful with ID: ${event.userId}');
        // Add your navigation logic here
      }
    });
  }
}
