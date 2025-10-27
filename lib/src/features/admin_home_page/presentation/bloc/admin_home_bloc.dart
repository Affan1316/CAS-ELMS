import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_event.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_state.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/bloc/leave_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/shared/enums.dart';

class AdminHomeBloc extends Bloc<AdminHomeEvent, AdminHomeState> {
  final LeaveBloc leaveBloc;
  
  AdminHomeBloc(this.leaveBloc) : super(AdminHomeState(currentPage: 0)) {
    on<PageChangedEvent>((event, emit) {
      emit(state.copyWith(currentPage: event.newPageIndex));
    });

    on<LoadPendingLeavesEvent>((event, emit) async {
      emit(state.copyWith(isLoadingLeaves: true));
      leaveBloc.add(FetchLeaveRequest());
      await emit.forEach<LeaveState>(
        leaveBloc.stream,
        onData: (leaveState) {
          if (leaveState is LeaveListLoaded) {
            final pendingCount =
                leaveState.leaves
                    .where(
                      (leave) =>
                          LeaveStatusHelper.stringToLeaveStatus(leave.status) ==
                          LeaveStatus.pending,
                    )
                    .length;
            return state.copyWith(
              pendingLeavesCount: pendingCount,
              isLoadingLeaves: false,
            );
          } else if (leaveState is LeaveFailure) {
            return state.copyWith(
              pendingLeavesCount: 0,
              isLoadingLeaves: false,
            );
          }
          return state.copyWith(isLoadingLeaves: false);
        },
      );
    });
  }
}

