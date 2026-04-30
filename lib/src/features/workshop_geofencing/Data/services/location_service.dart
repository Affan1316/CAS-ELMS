import 'dart:async';
import 'dart:developer' as dv;

import 'package:flutter/widgets.dart';
import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Data/getTimeConversions.dart';
import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Data/services/notification_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../Domain/repository/firestore_repository.dart';
import '../../Domain/repository/hive_repository.dart';
import '../../Domain/repository/shared_preference_repository.dart';
import 'geofence_sevice.dart';
import 'work_manager_service.dart';

///////////////////////////////////////
/// Location Service Callback
///////////////////////////////////////
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

class LocationTaskHandler extends TaskHandler {
  static const String enterTag = "EnteringCAS";
  static const String exitTag = "ExitingCAS";
  static const String dWellTag = "Dwell";

  bool isInCAS = false;
  final hiveRepo = HiveRepository();
  final WorkManagerService workManagerService = WorkManagerService();
  final NotificationService notificationService = NotificationService();
  DateTime? entryTime;
  var locationServiceManager = LocationServiceManager();
  var s = SharePreferenceRepository();
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    WidgetsFlutterBinding.ensureInitialized();
    WorkManagerService.initialize();
    notificationService.initNotification();
    await hiveRepo.initInService();
    await s.init();

    // Recover any orphaned session from a previous day (force-kill recovery)
    await MyGeofenceService.recoverOrphanedSession(hiveRepo, s);

    // Register periodic orphan cleanup watchdog (every 15 min)
    await WorkManagerService.registerOrphanCleanupTask();

    isInCAS = false;
    entryTime = null; // Reset entry time
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    dv.log(
      "onDestroy called, isTimeout=$isTimeout",
      name: "LocationTaskHandler",
    );
    TimerForAttendance.stopTimer();

    // ── WorkManager exit task ─────────────────────────────────────────
    // Register WorkManager immediately — it's the most reliable approach.
    // WorkManager registers instantly and survives process death.
    // We intentionally skip synchronous onExit() here because it can be
    // slow (Firestore sync on poor network) and the process may die
    // before it completes, wasting the limited onDestroy window.
    try {
      await workManagerService.registerOneOfTask(
        taskName: WorkManagerService.exitTask,
        uniqueName:
            "${WorkManagerService.exitTask}_${DateTime.now().millisecondsSinceEpoch}",
      );
      dv.log(
        "WorkManager exit task registered in onDestroy",
        name: "LocationTaskHandler",
      );
    } catch (e) {
      dv.log(
        "WorkManager registration failed in onDestroy: $e",
        name: "LocationTaskHandler",
      );
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    // Check location enabled before tracking
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      dv.log(
        "Location OFF at entry, skipping session. location : $serviceEnabled and isInCAS: $isInCAS",
        name: "locationCheck",
      );
      await MyGeofenceService.onExit(hiveRepo, s, notificationService);
      isInCAS = false;
      TimerForAttendance.stopTimer();
      return;
    }

    final Position pos = await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
    );
    if (pos.isMocked ||
        !isInGeofenceMeters(pointLat: pos.latitude, pointLon: pos.longitude)) {
      dv.log(
        "Location OFF at entry, skipping session. location : $serviceEnabled and isInCAS: $isInCAS",
        name: "locationCheck",
      );
      await MyGeofenceService.onExit(hiveRepo, s, notificationService);
      locationServiceManager.stopLocationService();
      isInCAS = false;
      TimerForAttendance.stopTimer(); // <-- Reset entry timestamp since user exited
      return;
    }
  }

  @override
  void onNotificationButtonPressed(String id) {
    super.onNotificationButtonPressed(id);
    if (id == "stop") {
      locationServiceManager.stopLocationService();
    }
  }

  @override
  void onReceiveData(Object data) async {
    super.onReceiveData(data);
    final FireStoreRepository fireStoreRepository = FireStoreRepository();
    WidgetsFlutterBinding.ensureInitialized();
    await hiveRepo.initInService();
    await SharePreferenceRepository().init();
    notificationService.initNotification();
    await fireStoreRepository.init();

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );
    if (!pos.isMocked) {
      if (data == enterTag) {
        dv.log("Received Enter Tag", name: "LocationTaskHandler");
        isInCAS = true;
        await MyGeofenceService.onEnter(hiveRepo, s, notificationService);
        // Pass the already-initialized fireStoreRepository, not a new instance
        await TimerForAttendance.startTimer(fireStoreRepository);

        // Handle enter event
      } else if (data == exitTag) {
        // Handle's exit event

        dv.log("Received Exit Tag", name: "LocationTaskHandler");
        if (isInCAS) {
          await MyGeofenceService.onExit(hiveRepo, s, notificationService);

          isInCAS = false;
        }
        await locationServiceManager.stopLocationService();
      } else if (data == dWellTag) {
        dv.log("Received Dwell Tag", name: "LocationTaskHandler");
        // Handle dwell event
        await MyGeofenceService.onDwell(fireStoreRepository);
      }
    } else {
      notificationService.showSpoofedLocNotification();
    }
  }

  @override
  void onNotificationPressed() {
    // Handle notification press event here
    // For example, you can bring the app to the foreground
    FlutterForegroundTask.launchApp();
  }
}

///////////////////////////////////////
///Location Service Manager
///////////////////////////////////////

class LocationServiceManager {
  static final LocationServiceManager _instance =
      LocationServiceManager._internal();

  factory LocationServiceManager() {
    return _instance;
  }

  LocationServiceManager._internal();

  Future<void> sendEnterEventTag() async {
    FlutterForegroundTask.sendDataToTask(LocationTaskHandler.enterTag);
  }

  Future<void> sendExitEventTag() async {
    FlutterForegroundTask.sendDataToTask(LocationTaskHandler.exitTag);
  }

  Future<void> sendDwellEventTag() async {
    FlutterForegroundTask.sendDataToTask(LocationTaskHandler.dWellTag);
  }

  static Future<void> initLocationService() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_service_channel',
        channelName: 'Location Service',
        channelDescription:
            'This notification appears when the foreground service is running.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(30000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  FutureOr<void> startLocationService() async {
    try {
      await FlutterForegroundTask.startService(
        notificationTitle: 'Location Service Running',
        notificationText: 'tracking location to track Time in CAS',
        callback: startCallback,
        notificationButtons: [NotificationButton(id: "stop", text: "Stop")],
      );
    } on ServiceAlreadyStartedException {
      dv.log("Service is already running", name: "LocationService");
    } catch (e) {
      dv.log("Error starting location service: $e", name: "LocationService");
    }
  }

  Future<void> stopLocationService() async {
    await FlutterForegroundTask.stopService();
  }
}

class TimerForAttendance {
  static Timer? _attendanceTimer;
  static int _minutesPassed = 0;
  static bool isMarked = false;

  /// Starts the attendance timer with state persistence.
  /// Guards against duplicate timers and restores state from SharedPreferences
  /// so the timer survives process death and service restarts.
  static Future<void> startTimer(FireStoreRepository firestore) async {
    // Guard: prevent duplicate timers
    if (_attendanceTimer != null) {
      dv.log(
        "Timer already running, skipping duplicate startTimer",
        name: "TimerForAttendance",
      );
      return;
    }

    // Restore persisted state (survives process death)
    final prefs = SharePreferenceRepository();
    _minutesPassed = await prefs.getAttendanceMinutesPassed();
    final today = formatDate(date: DateTime.now());
    isMarked = await prefs.isAttendanceMarkedForDate(today);

    dv.log(
      "Timer starting: restored _minutesPassed=$_minutesPassed, isMarked=$isMarked",
      name: "TimerForAttendance",
    );

    // If already marked for today, no need to start the timer
    if (isMarked) {
      dv.log(
        "Attendance already marked for today, timer not needed",
        name: "TimerForAttendance",
      );
      return;
    }

    _attendanceTimer = Timer.periodic(const Duration(minutes: 1), (
      timer,
    ) async {
      ++_minutesPassed;
      dv.log("minutes passed $_minutesPassed", name: "TimerForAttendance");

      // Persist minutes so they survive process death
      await prefs.setAttendanceMinutesPassed(_minutesPassed);

      // ⭐ After 5 minutes → mark attendance
      if (_minutesPassed >= 5 && !isMarked) {
        try {
          // Ensure Firebase is initialized (may be a restarted isolate)
          await firestore.init();

          String? rollNo = await SharePreferenceRepository().getRollNo();

          // Validate rollNo explicitly
          if (rollNo == null || rollNo.isEmpty) {
            dv.log(
              "❌ Cannot mark attendance: rollNo is null or empty",
              name: "TimerForAttendance",
            );
            // Don't stop timer — retry next minute in case rollNo becomes available
            return;
          }

          DateTime date = await getCurrentDate();
          final dateKey = formatDate(date: date);

          await firestore.markAttendance(
            studentId: rollNo,
            date: dateKey,
            isPresent: true,
            day: DateFormat("EEEE").format(date),
          );

          isMarked = true;
          await prefs.setAttendanceMarked(dateKey);
          dv.log(
            "✅ Attendance marked for $rollNo on $dateKey",
            name: "TimerForAttendance",
          );
        } catch (e) {
          dv.log("❌ Failed to mark attendance: $e", name: "TimerForAttendance");
          // Don't stop timer on failure — will retry next minute
          return;
        }
        TimerForAttendance.stopTimer();
      }
    });
  }

  static void stopTimer() {
    _attendanceTimer?.cancel(); // stop timer
    _attendanceTimer = null;
    // Note: We do NOT reset _minutesPassed or isMarked here.
    // They are persisted in SharedPreferences and should only be reset
    // when the session is fully closed (via resetAttendanceTimerState).
  }
}
