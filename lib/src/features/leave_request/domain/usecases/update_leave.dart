import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/repository/leave_repository.dart';

class UpdateLeave {
  final LeaveRepository leaveRepository;
  UpdateLeave(this.leaveRepository);

  Future<void> call(Leave leave) async {
    return await leaveRepository.updateLeaveStatus(leave);
  }
}
