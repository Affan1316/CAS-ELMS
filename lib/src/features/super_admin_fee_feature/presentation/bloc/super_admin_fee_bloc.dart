import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/entity/group_fee_history.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/confirm_super_admin_fee_payment_use_case.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/fetch_group_fee_history_usecase.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/get_groups_names_super_admin_usecase.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/get_super_admin_fee_notifications_usecase.dart';
import 'super_admin_fee_event.dart';
import 'super_admin_fee_state.dart';

/// Internal event used only by this bloc to update per-group cached summaries.
/// Declared here to avoid touching other files.
class UpdateGroupSummaryEvent extends SuperAdminFeeEvent {
  final String groupName;
  final GroupFeeHistory? summary; // null means failed or not available

  UpdateGroupSummaryEvent({required this.groupName, required this.summary});
}

class SuperAdminFeeBloc extends Bloc<SuperAdminFeeEvent, SuperAdminFeeState> {
  final GetSuperAdminFeeNotificationsUsecase getNotifications;
  final ConfirmSuperAdminFeePaymentUseCase confirmPayment;
  final FetchGroupFeeHistoryUsecase fetchGroupFeeHistoryUsecase;
  final GetGroupsNamesSuperAdminUsecase getGroupsNamesSuperAdminUsecase;
  // final DeleteSuperAdminFeeNotificationUseCase deleteNotification;
  // final DeleteAllPaidNotificationsUseCase deleteAllPaid;

  /// Holds the last-fetched GroupFeeHistory for each group name (or null on error / not-yet-loaded).
  final Map<String, GroupFeeHistory?> groupSummaries = {};

  /// Keeps the last list of group names so UpdateGroupSummaryEvent handlers can re-emit GroupNamesLoaded.
  List<String> _lastGroupNames = [];

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

    // Handler for the internal update event — safe to call emit here because this is an event handler.
    on<UpdateGroupSummaryEvent>(_onUpdateGroupSummary);
  }

  /// Public getter so UI code can read the summaries map.
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

  /// Loads group names, emits GroupNamesLoaded (as before), AND
  /// asynchronously fetches & caches each group's fee-history in [groupSummaries].
  /// After each group's fetch completes we add(UpdateGroupSummaryEvent(...))
  /// which is handled by this bloc (and re-emits GroupNamesLoaded there).
  Future<void> _onGetGroupNames(GetGroupNamesEvent event, Emitter emit) async {
    emit(LoadingGroupNames());

    // fetch names (unchanged)
    final List<String> listOfGroupNames =
        await getGroupsNamesSuperAdminUsecase.getNames();

    // store last names so other handlers can re-emit consistently
    _lastGroupNames = List<String>.from(listOfGroupNames);

    // initialize the map entries to `null` (indicates not-yet-loaded)
    for (final name in listOfGroupNames) {
      groupSummaries[name] = null;
    }

    // emit immediately so existing UI that listens to GroupNamesLoaded behaves the same
    emit(GroupNamesLoaded(listOfNames: listOfGroupNames));

    // start concurrent fetches for each group's fee history.
    // Instead of calling emit(...) from the async callback (which causes the assertion),
    // we add a new event when each fetch completes. That new event runs in a fresh handler
    // where emit(...) is allowed.
    for (final name in listOfGroupNames) {
      () async {
        try {
          final result = await fetchGroupFeeHistoryUsecase.fetch(name);
          if (result is GroupFeeHistory) {
            // schedule internal event to update map + emit state
            add(UpdateGroupSummaryEvent(groupName: name, summary: result));
          } else {
            // treat non-GroupFeeHistory as error => store null
            add(UpdateGroupSummaryEvent(groupName: name, summary: null));
          }
        } catch (_) {
          // on network / unexpected error - schedule update with null
          add(UpdateGroupSummaryEvent(groupName: name, summary: null));
        }
      }();
    }
  }

  /// Handler for the internal update events. Updates cache and notifies UI by emitting
  /// GroupNamesLoaded with the last known list of group names (so UI rebuilds and reads map).
  Future<void> _onUpdateGroupSummary(
    UpdateGroupSummaryEvent event,
    Emitter emit,
  ) async {
    // update cache
    groupSummaries[event.groupName] = event.summary;

    // re-emit GroupNamesLoaded so UI can pick up updated map values.
    // Use the stored _lastGroupNames (could be empty if names weren't loaded yet).
    emit(GroupNamesLoaded(listOfNames: List<String>.from(_lastGroupNames)));
  }
}
