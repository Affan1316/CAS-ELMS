import 'package:flutter_cas_app_main/src/features/leave_request/data/datasources/leave_remote_data_source.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/data/model/leave_model.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/repository/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource leaveRemoteDataSource;

  LeaveRepositoryImpl(this.leaveRemoteDataSource);

  @override
  Future<void> addLeave(Leave leave) {
    final model = LeaveModel(
      id: leave.id,
      section: leave.section,
      studentName: leave.studentName,
      status: leave.status,
      leaveType: leave.leaveType,
      fromDate: leave.fromDate,
      toDate: leave.toDate,
      reason: leave.reason,
      currentDate: leave.currentDate,
    );
    return leaveRemoteDataSource.addleave(model);
  }

  @override
  Future<List<Leave>> getLeave() async {
    final models = await leaveRemoteDataSource.getLeave();
    return models;
  }

  @override
  Future<void> updateLeaveStatus(Leave leave) {
    return leaveRemoteDataSource.updateStatus(leave);
  }
}
