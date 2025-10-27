import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/repository/leave_repository.dart';

class GetLeave {
  final LeaveRepository leaveRepository;
  GetLeave(this.leaveRepository);

  Future<List<Leave>> call() {
    return leaveRepository.getLeave();
  }
}
