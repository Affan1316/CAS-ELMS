import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Manages a foreground service to keep bulk approval alive when app is backgrounded.
///
/// Usage:
///   1. Call [startBulkApproval] with total count before starting the loop
///   2. Call [updateProgress] after each individual approval completes
///   3. Call [completeBulkApproval] or [failBulkApproval] when done
class BulkApprovalService {
  static final BulkApprovalService _instance = BulkApprovalService._internal();
  factory BulkApprovalService() => _instance;
  BulkApprovalService._internal();

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  /// Initialize the foreground task configuration (call once at app startup).
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'bulk_approval_channel',
        channelName: 'Fee Approval',
        channelDescription: 'Processing bulk fee approvals',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  /// Start the foreground service before beginning bulk approvals.
  Future<void> startBulkApproval(int totalCount) async {
    if (_isRunning) return;
    _isRunning = true;

    try {
      // Re-init with our channel settings before starting
      init();

      await FlutterForegroundTask.startService(
        notificationTitle: 'Approving Fees',
        notificationText: 'Processing 0 of $totalCount approvals...',
        serviceId: 200,
        callback: bulkApprovalCallback,
      );
      debugPrint('🔔 Foreground service started for $totalCount approvals');
    } catch (e) {
      debugPrint('⚠️ Could not start foreground service: $e');
      // Non-fatal: approvals will still work, just not background-safe
    }
  }

  /// Update the notification with current progress.
  Future<void> updateProgress(int completed, int total, String studentName) async {
    if (!_isRunning) return;

    try {
      await FlutterForegroundTask.updateService(
        notificationTitle: 'Approving Fees',
        notificationText: 'Approved $completed of $total — $studentName',
      );
    } catch (e) {
      debugPrint('⚠️ Could not update notification: $e');
    }
  }

  /// Stop the foreground service after all approvals are done.
  Future<void> completeBulkApproval(int totalApproved) async {
    if (!_isRunning) return;
    _isRunning = false;

    try {
      await FlutterForegroundTask.updateService(
        notificationTitle: 'Fee Approval Complete',
        notificationText: '$totalApproved fee(s) approved successfully ✅',
      );
      // Small delay so the user can see the completion notification
      await Future.delayed(const Duration(seconds: 2));
      await FlutterForegroundTask.stopService();
      debugPrint('🔔 Foreground service stopped — $totalApproved approved');
    } catch (e) {
      debugPrint('⚠️ Could not stop foreground service: $e');
    }
  }

  /// Stop the foreground service on failure.
  Future<void> failBulkApproval(String errorMessage) async {
    if (!_isRunning) return;
    _isRunning = false;

    try {
      await FlutterForegroundTask.updateService(
        notificationTitle: 'Fee Approval Failed',
        notificationText: errorMessage,
      );
      await Future.delayed(const Duration(seconds: 3));
      await FlutterForegroundTask.stopService();
      debugPrint('🔔 Foreground service stopped — failed: $errorMessage');
    } catch (e) {
      debugPrint('⚠️ Could not stop foreground service: $e');
    }
  }
}

// Required by flutter_foreground_task — runs in an isolate but we don't
// need it to do anything because the actual work runs on the main isolate.
// The service just keeps the process alive.
// NOTE: Must be a PUBLIC top-level function for isolate entry point resolution.
@pragma('vm:entry-point')
void bulkApprovalCallback() {
  FlutterForegroundTask.setTaskHandler(BulkApprovalTaskHandler());
}

class BulkApprovalTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('🔔 BulkApprovalTaskHandler.onStart');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // No-op: we don't use periodic events
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    debugPrint('🔔 BulkApprovalTaskHandler.onDestroy (timeout: $isTimeout)');
  }
}
