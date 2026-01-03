import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/entity/group_fee_history.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/confirm_bulk_super_admin_fee_payment_use_case.dart.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/confirm_super_admin_fee_payment_use_case.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/fetch_group_fee_history_usecase.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/get_groups_names_super_admin_usecase.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/get_super_admin_fee_notifications_usecase.dart';
import 'super_admin_fee_event.dart';
import 'super_admin_fee_state.dart';



class SuperAdminFeeBloc extends Bloc<SuperAdminFeeEvent, SuperAdminFeeState> {
  final GetSuperAdminFeeNotificationsUsecase getNotifications;
  final ConfirmSuperAdminFeePaymentUseCase confirmPayment;
  final ConfirmBulkSuperAdminFeePaymentUseCase confirmBulkPayments;
  final FetchGroupFeeHistoryUsecase fetchGroupFeeHistoryUsecase;
  final GetGroupsNamesSuperAdminUsecase getGroupsNamesSuperAdminUsecase;

  final Map<String, GroupFeeHistory?> groupSummaries = {};
  List<String> _lastGroupNames = [];

  SuperAdminFeeBloc({
    required this.getNotifications,
    required this.confirmPayment,
    required this.confirmBulkPayments,
    required this.fetchGroupFeeHistoryUsecase,
    required this.getGroupsNamesSuperAdminUsecase,
  }) : super(SuperAdminFeeInitialState()) {
    on<LoadSuperAdminFeeNotifications>(_onLoad);
    on<ConfirmSuperAdminFeePayment>(_onConfirm);
    on<ConfirmBulkSuperAdminFeePayments>(_onConfirmBulk);
    on<FetchGroupFeeHistoryEvent>(_onFetchGroupFeeHistory);
    on<GetGroupNamesEvent>(_onGetGroupNames);
    on<UpdateGroupSummaryEvent>(_onUpdateGroupSummary);
  }

  Map<String, GroupFeeHistory?> get getGroupSummaries =>
      Map.unmodifiable(groupSummaries);

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

  Future<void> _onConfirmBulk(
    ConfirmBulkSuperAdminFeePayments event,
    Emitter emit,
  ) async {
    try {
      emit(ConfirmingPayment());
      await confirmBulkPayments(event.payments);
    } catch (e) {
      emit(SuperAdminFeeErrorState(e.toString()));
      return;
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
      emit(SuperAdminFeeErrorState(groupFeeHistory));
    }
  }

  Future<void> _onGetGroupNames(GetGroupNamesEvent event, Emitter emit) async {
    emit(LoadingGroupNames());

    final List<String> listOfGroupNames =
        await getGroupsNamesSuperAdminUsecase.getNames();

    _lastGroupNames = List<String>.from(listOfGroupNames);

    for (final name in listOfGroupNames) {
      groupSummaries[name] = null;
    }

    emit(GroupNamesLoaded(listOfNames: listOfGroupNames));

    for (final name in listOfGroupNames) {
      () async {
        try {
          final result = await fetchGroupFeeHistoryUsecase.fetch(name);
          if (result is GroupFeeHistory) {
            add(UpdateGroupSummaryEvent(groupName: name, summary: result));
          } else {
            add(UpdateGroupSummaryEvent(groupName: name, summary: null));
          }
        } catch (_) {
          add(UpdateGroupSummaryEvent(groupName: name, summary: null));
        }
      }();
    }
  }

  Future<void> _onUpdateGroupSummary(
    UpdateGroupSummaryEvent event,
    Emitter emit,
  ) async {
    groupSummaries[event.groupName] = event.summary;
    emit(GroupNamesLoaded(listOfNames: List<String>.from(_lastGroupNames)));
  }
}