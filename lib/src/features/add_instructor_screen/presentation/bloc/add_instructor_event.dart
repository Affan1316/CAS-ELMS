abstract class AddInstructorEvent {}

class GenderChangedEvent extends AddInstructorEvent {
  final String gender;
  GenderChangedEvent(this.gender);
}

class SubmitInstructorEvent extends AddInstructorEvent {
  final String instructorId;
  final String name;
  final String email;
  final String cnic;
  final String phone;
  final String address;
  final String gender;

  SubmitInstructorEvent({
    required this.instructorId,
    required this.name,
    required this.email,
    required this.cnic,
    required this.phone,
    required this.address,
    required this.gender,
  });
}

class ResetFormEvent extends AddInstructorEvent {}
