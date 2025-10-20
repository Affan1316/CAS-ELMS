import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/entity/group_fee_history.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/confirm_super_admin_fee_payment_use_case.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/fetch_group_fee_history_usecase.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/get_groups_names_super_admin_usecase.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/get_super_admin_fee_notifications_usecase.dart';
import 'super_admin_fee_event.dart';
import 'super_admin_fee_state.dart';

class SuperAdminFeeBloc extends Bloc<SuperAdminFeeEvent, SuperAdminFeeState> {
  final GetSuperAdminFeeNotificationsUsecase getNotifications;
  final ConfirmSuperAdminFeePaymentUseCase confirmPayment;
  final FetchGroupFeeHistoryUsecase fetchGroupFeeHistoryUsecase;
  final GetGroupsNamesSuperAdminUsecase getGroupsNamesSuperAdminUsecase;
  // final DeleteSuperAdminFeeNotificationUseCase deleteNotification;
  // final DeleteAllPaidNotificationsUseCase deleteAllPaid;

  SuperAdminFeeBloc({
    required this.getNotifications,
    required this.confirmPayment,
    required this.fetchGroupFeeHistoryUsecase,
    required this.getGroupsNamesSuperAdminUsecase,
    // required this.deleteNotification,
    // required this.deleteAllPaid,
  }) : super(SuperAdminFeeInitialState()) {
    on<LoadSuperAdminFeeNotifications>(_onLoad);
    on<ConfirmSuperAdminFeePayment>(_onConfirm);
    on<FetchGroupFeeHistoryEvent>(_onFetchGroupFeeHistory);
    on<GetGroupNamesEvent>(_onGetGroupNames);
  }

  Future<void> _onLoad(
    LoadSuperAdminFeeNotifications event,
    Emitter emit,
  ) async {
    emit(SuperAdminFeeLoadingState());
    try {
      final notifications = await getNotifications();
      emit(SuperAdminFeeLoadedState(notifications));
    } catch (e) {
      emit(SuperAdminFeeErrorState(e.toString()));
    }
  }

  Future<void> _onConfirm(
    ConfirmSuperAdminFeePayment event,
    Emitter emit,
  ) async {
    try {
      emit(ConfirmingPayment());
      await confirmPayment(event.id, event.studentId);
    } catch (e) {
      emit(SuperAdminFeeErrorState(e.toString()));
    }

    try {
      final notifications = await getNotifications();
      emit(SuperAdminFeeLoadedState(notifications));
    } catch (e) {
      emit(SuperAdminFeeErrorState(e.toString()));
    }
  }

  Future<void> _onFetchGroupFeeHistory(
    FetchGroupFeeHistoryEvent event,
    Emitter emit,
  ) async {
    emit(GroupFeeHistoryInitial());

    final groupFeeHistory = await fetchGroupFeeHistoryUsecase.fetch(
      event.groupName,
    );
    if (groupFeeHistory is GroupFeeHistory) {
      emit(
        GroupFeeHistoryLoaded(
          received: groupFeeHistory.received,
          remaining: groupFeeHistory.remaining,
          total: groupFeeHistory.total,
        ),
      );
    } else {
      // if error message came in groupFeeHistory then
      emit(SuperAdminFeeErrorState(groupFeeHistory));
    }
  }

  Future<void> _onGetGroupNames(GetGroupNamesEvent event, Emitter emit) async {
    emit(LoadingGroupNames());
    List<String> listOfGroupNames =
        await getGroupsNamesSuperAdminUsecase.getNames();
    emit(GroupNamesLoaded(listOfNames: listOfGroupNames));
  }
}
