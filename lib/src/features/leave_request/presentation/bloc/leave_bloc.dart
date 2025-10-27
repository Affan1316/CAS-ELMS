import 'package:bloc/bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/usecases/create_leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/usecases/get_leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/usecases/update_leave.dart';
import 'package:intl/intl.dart' show DateFormat;
part 'leave_event.dart';
part 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final CreateLeave createLeave;
  final GetLeave getLeave;
  final UpdateLeave updateLeaveStatus;

  LeaveBloc(this.createLeave, this.getLeave, this.updateLeaveStatus)
      : super(LeaveInitial()) {
    on<SubmitLeaveRequest>((event, emit) async {
      emit(LeaveLoading());
      try {
        final leave = Leave(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          status: event.status,
          section: event.section,
          studentName: event.studentName,
          leaveType: event.leaveType,
          fromDate: event.fromDate,
          toDate: event.toDate,
          reason: event.reason,
          currentDate: event.currentDate,
        );
        await createLeave(leave);
        emit(LeaveSuccess());
      } catch (e) {
        emit(LeaveFailure(e.toString()));
      }
    });

   on<FetchLeaveRequest>((event, emit) async {
  emit(LeaveLoading());
  try {
    final List<Leave> requestLeave = await getLeave();
    
    // Sort leaves by currentDate in descending order (newest first)
    requestLeave.sort((a, b) {
      try {
        final dateA = DateFormat('dd MMM yyyy').parse(a.currentDate ?? '');
        final dateB = DateFormat('dd MMM yyyy').parse(b.currentDate ?? '');
        return dateB.compareTo(dateA); // Descending order (newest first)
      } catch (e) {
        final idA = int.tryParse(a.id ?? '0') ?? 0;
        final idB = int.tryParse(b.id ?? '0') ?? 0;
        return idB.compareTo(idA);
      }
    });
    
    emit(LeaveListLoaded(requestLeave));
  } catch (e) {
    emit(LeaveFailure(e.toString()));
  }
});

    on<LeaveStatusUpdateEvent>((event, emit) async {
      try {
        await updateLeaveStatus(event.leave);
        emit(LeaveStatusUpdated());
        // Automatically fetch updated list after status update
        add(FetchLeaveRequest());
      } catch (e) {
        emit(LeaveStatusUpdateFailed(e.toString()));
      }
    });
  }
}