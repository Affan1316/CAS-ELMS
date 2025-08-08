enum AddInstructorStatus { initial, loading, success, failure }

class AddInstructorState {
  final AddInstructorStatus status;
  final String selectedGender;
  final String? errorMessage;
  final String? successMessage;

  const AddInstructorState({
    this.status = AddInstructorStatus.initial,
    this.selectedGender = 'Male',
    this.errorMessage,
    this.successMessage,
  });

  AddInstructorState copyWith({
    AddInstructorStatus? status,
    String? selectedGender,
    String? errorMessage,
    String? successMessage,
  }) {
    return AddInstructorState(
      status: status ?? this.status,
      selectedGender: selectedGender ?? this.selectedGender,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
