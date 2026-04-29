import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/entity/group_fee_history.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/services/bulk_approval_service.dart';
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
    on<ConfirmBulkSuperAdminFeePayments>(
      _onConfirmBulk,
      transformer: concurrent(),
    );
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
    final currentState = state;
    if (currentState is! SuperAdminFeeLoadedState) return;

    final originalNotifications = currentState.notifications;

    // ✅ Optimistic update — instantly mark as Paid in UI (no loading spinner)
    final optimisticNotifications =
        originalNotifications.map((n) {
          final updatedInstallments =
              ((n['installments'] as List?) ?? []).map((i) {
                final installment = i as Map<String, dynamic>;
                if (installment['id'] == event.id) {
                  return {...installment, 'status': 'Paid'};
                }
                return installment;
              }).toList();
          return {...n, 'installments': updatedInstallments};
        }).toList();

    emit(
      SuperAdminFeeLoadedState(
        optimisticNotifications,
        version: currentState.version + 1,
      ),
    );

    // ✅ Now do the actual API call in background — UI is already updated
    try {
      await confirmPayment(event.id, event.studentId);
    } on FirebaseException catch (e) {
      debugPrint('🔥 FirebaseException during single approval: ${e.code}');
      final friendlyMessage = _mapFirebaseError(e);

      if (!isClosed) {
        // ✅ Rollback optimistic update on failure
        emit(
          BulkPaymentFailed(
            restoredNotifications: originalNotifications,
            message: friendlyMessage,
            version: currentState.version + 2,
          ),
        );
      }
      return;
    } catch (e) {
      debugPrint('❌ Unexpected single approval error: $e');
      if (!isClosed) {
        emit(
          BulkPaymentFailed(
            restoredNotifications: originalNotifications,
            message: 'Approval failed: ${e.toString()}',
            version: currentState.version + 2,
          ),
        );
      }
      return;
    }

    // ✅ Fetch fresh data after success
    try {
      final fresh = await getNotifications();
      if (!isClosed) {
        emit(
          SuperAdminFeeLoadedState(
            fresh,
            version: currentState.version + 2,
            isJustCompleted: true,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          SuperAdminFeeLoadedState(
            optimisticNotifications,
            version: currentState.version + 2,
            isJustCompleted: true,
          ),
        );
      }
    }
  }

  Future<void> _onConfirmBulk(
    ConfirmBulkSuperAdminFeePayments event,
    Emitter emit,
  ) async {
    final currentState = state;
    if (currentState is! SuperAdminFeeLoadedState) return;

    final originalNotifications = currentState.notifications;
    final confirmedIds = event.payments.map((p) => p['id'] as String).toSet();
    final total = event.payments.length;
    final approvalService = BulkApprovalService();

    // Optimistic update
    final optimisticNotifications =
        originalNotifications.map((n) {
          final updatedInstallments =
              ((n['installments'] as List?) ?? []).map((i) {
                final installment = i as Map<String, dynamic>;
                if (confirmedIds.contains(installment['id'])) {
                  return {...installment, 'status': 'Paid'};
                }
                return installment;
              }).toList();
          return {...n, 'installments': updatedInstallments};
        }).toList();

    // Start foreground service to keep alive in background
    await approvalService.startBulkApproval(total);

    emit(BulkPaymentProgress(
      notifications: optimisticNotifications,
      completed: 0,
      total: total,
      currentStudent: 'Starting...',
    ));

    int completed = 0;
    List<String> errors = [];

    // Process each payment in parallel batches to improve speed
    // and provide a non-blocking experience.
    const int batchSize = 3;
    final payments = event.payments;

    for (int i = 0; i < payments.length; i += batchSize) {
      final batch = payments.skip(i).take(batchSize).toList();

      await Future.wait(
        batch.map((payment) async {
          final id = payment['id']!;
          final studentId = payment['studentId']!;

          try {
            await confirmPayment(id, studentId);
            completed++;

            // Update foreground notification
            await approvalService.updateProgress(completed, total, studentId);
          } on FirebaseException catch (e) {
            debugPrint('🔥 Firebase error approving $id: ${e.code}');
            errors.add('$studentId: ${_mapFirebaseError(e)}');
          } catch (e) {
            debugPrint('❌ Error approving $id: $e');
            errors.add('$studentId: $e');
          }
        }),
      );

      // Emit progress after each batch completes
      if (!isClosed) {
        emit(
          BulkPaymentProgress(
            notifications: optimisticNotifications,
            completed: completed,
            total: total,
            currentStudent: batch.last['studentId'] ?? '',
          ),
        );
      }
    }

    // Handle result
    if (errors.isNotEmpty && completed == 0) {
      // Total failure
      await approvalService.failBulkApproval(
        '${errors.length} approval(s) failed',
      );

      if (!isClosed) {
        emit(BulkPaymentFailed(
          restoredNotifications: originalNotifications,
          message: 'All approvals failed: ${errors.first}',
          version: currentState.version + 2,
        ));
      }
      return;
    }

    // Complete (possibly with partial failures)
    await approvalService.completeBulkApproval(completed);

    // Fetch fresh data
    try {
      final fresh = await getNotifications();
      if (!isClosed) {
        emit(SuperAdminFeeLoadedState(
          fresh,
          version: currentState.version + 2,
          isJustCompleted: true,
        ));
      }
    } catch (_) {
      if (!isClosed) {
        emit(SuperAdminFeeLoadedState(
          optimisticNotifications,
          version: currentState.version + 2,
          isJustCompleted: true,
        ));
      }
    }

    // Log partial failures
    if (errors.isNotEmpty) {
      debugPrint('⚠️ Partial bulk approval: $completed/$total succeeded');
      for (final err in errors) {
        debugPrint('  ❌ $err');
      }
    }
  }

  // ✅ Map Firebase error codes to friendly messages
  String _mapFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Permission denied. Contact your administrator.';
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again.';
      case 'deadline-exceeded':
        return 'Request timed out. Please try again.';
      case 'not-found':
        return 'Record not found. It may have already been processed.';
      default:
        return 'Firebase error: ${e.code}. ${e.message ?? ''}';
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
