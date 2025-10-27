import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/repository/leave_repository.dart';

class CreateLeave {
  final LeaveRepository leaveRepository;

  CreateLeave(this.leaveRepository);

  Future<void> call(Leave leave) {
    return leaveRepository.addLeave(leave);
  }
}
