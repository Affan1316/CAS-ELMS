import 'package:flutter_cas_app_main/src/features/leave_request/domain/repository/leave_repository.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/shared/enums.dart';

class GetPendingLeaveStatusCount {
  final LeaveRepository leaveRepository;

  GetPendingLeaveStatusCount(this.leaveRepository);

  Future<int> call()async{
    try{
      final leaves = await leaveRepository.getLeave();
      return leaves
          .where((leave) => LeaveStatusHelper.stringToLeaveStatus(leave.status) == LeaveStatus.pending)
          .length;
    }catch (e) {
      return 0;
    }
  }
}
