import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';

abstract class LeaveRepository {
  Future<void> addLeave(Leave leave);
  Future<List<Leave>> getLeave();
  Future<void> updateLeaveStatus(Leave leave);
}
