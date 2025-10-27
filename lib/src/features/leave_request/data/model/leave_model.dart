
import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';

class LeaveModel extends Leave{
  LeaveModel({
    required super.id,
    required super.studentName,
    required super.section,
    required super.status,
    required super.leaveType, 
    required super.fromDate, 
    required super.toDate, 
    required super.reason, 
    required super.currentDate});
}

