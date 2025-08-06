import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_event.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_state.dart';

class AddInstructorBloc extends Bloc<AddInstructorEvent, AddInstructorState> {
  AddInstructorBloc() : super(const AddInstructorState()) {
    on<GenderChangedEvent>(_onGenderChanged);
    on<SubmitInstructorEvent>(_onSubmitInstructor);
    on<ResetFormEvent>(_onResetForm);
  }

  void _onGenderChanged(
    GenderChangedEvent event,
    Emitter<AddInstructorState> emit,
  ) {
    emit(state.copyWith(selectedGender: event.gender));
  }

  void _onSubmitInstructor(
    SubmitInstructorEvent event,
    Emitter<AddInstructorState> emit,
  ) async {
    emit(state.copyWith(status: AddInstructorStatus.loading));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically call your repository/service
      // await _instructorRepository.addInstructor(event);

      emit(
        state.copyWith(
          status: AddInstructorStatus.success,
          successMessage: 'Instructor added successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddInstructorStatus.failure,
          errorMessage: 'Failed to add instructor: ${e.toString()}',
        ),
      );
    }
  }

  void _onResetForm(ResetFormEvent event, Emitter<AddInstructorState> emit) {
    emit(const AddInstructorState());
  }
}
