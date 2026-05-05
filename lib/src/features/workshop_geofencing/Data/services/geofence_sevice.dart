import 'dart:async';
import 'dart:developer' as dv;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Data/services/location_service.dart';
import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Domain/repository/firestore_repository.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/intl.dart';
import 'package:native_geofence/native_geofence.dart';

import '../../Domain/repository/hive_repository.dart';
import '../../Domain/repository/shared_preference_repository.dart';
import '../getTimeConversions.dart';
import '../model/session_model.dart';
import 'notification_service.dart';

/// Handle enter/exit/dwell events
@pragma('vm:entry-point')
Future<void> handleGeofenceEvent(GeofenceCallbackParams params) async {
  debugPrint("📍 Geofence event: ${params.toString()}");
  // final hiveRepo = HiveRepository();
  final locationService = LocationServiceManager();
  WidgetsFlutterBinding.ensureInitialized();
  await LocationServiceManager.initLocationService();
  FlutterForegroundTask.initCommunicationPort();

  switch (params.event) {
    case GeofenceEvent.enter:
      {
        // await tryToPromoteToForeground();
        await locationService.startLocationService();
        await locationService.sendEnterEventTag();
        // await GeofenceService().onEnter(hiveRepo);
        // demoteToBackground();
      }
      break;

    case GeofenceEvent.exit:
      {
        // await tryToPromoteToForeground();
        await locationService.startLocationService();
        await locationService.sendExitEventTag();
        // await GeofenceService().onExit(hiveRepo);
        // await demoteToBackground();
      }
      break;

    case GeofenceEvent.dwell:
      debugPrint("⌛ Dwell detected inside geofence   and at ${DateTime.now()}");
      // await tryToPromoteToForeground();
      // await locationService.startLocationService();
      // await locationService.sendDwellEventTag();
      // await demoteToBackground();
      break;
  }
}

Future<void> tryToPromoteToForeground() async {
  if (Platform.isAndroid) {
    try {
      await NativeGeofenceBackgroundManager.instance.promoteToForeground();
      dv.log("Promoted to foreground");
    } catch (e) {
      debugPrint("❌ Failed to promote to foreground: $e");
      await NativeGeofenceBackgroundManager.instance.demoteToBackground();
    }
  }
}

Future<void> demoteToBackground() async {
  if (Platform.isAndroid) {
    try {
      await NativeGeofenceBackgroundManager.instance.demoteToBackground();
      dv.log("Demoted to background");
    } catch (e) {
      debugPrint("❌ Failed to demote to background: $e");
    }
  }
}

/// A service to track attendance & time spent inside a geofence.
class MyGeofenceService {
  /// Singleton instance
  static final MyGeofenceService _instance = MyGeofenceService._internal();
  factory MyGeofenceService() => _instance;
  MyGeofenceService._internal();

  ///  Geofence object
  NativeGeofenceManager nativeGeofence = NativeGeofenceManager.instance;
  SharePreferenceRepository sharePreferenceRepository =
      SharePreferenceRepository();
  var notificationService = NotificationService();

  /// init the  geofence package
  Future<void> init() async {
    await nativeGeofence.initialize();
  }

  Future<void> reCreateFence() {
    return nativeGeofence.reCreateAfterReboot();
  }

  /// Initialize geofence and listeners
  Future<void> createGeofence({
    double latitude = 29.382988,
    double longitude = 71.715538,
    double radius = 50, // meters
  }) async {
    // nativeGeofence.initialize();
    Geofence workshop = Geofence(
      id: 'CAS-Fence',
      location: Location(latitude: latitude, longitude: longitude),
      radiusMeters: radius,
      triggers: {GeofenceEvent.enter, GeofenceEvent.exit, GeofenceEvent.dwell},

      iosSettings: const IosGeofenceSettings(initialTrigger: true),
      androidSettings: const AndroidGeofenceSettings(
        initialTriggers: {GeofenceEvent.enter},
        notificationResponsiveness: Duration(minutes: 5),
        loiteringDelay: Duration(minutes: 40),
        expiration: null,
      ),
    );

    // await nativeGeofence.createGeofence(workshop, _handleGeofenceEvent);
    try {
      await NativeGeofenceManager.instance.createGeofence(
        workshop,
        handleGeofenceEvent,
      );
      debugPrint(
        "✅ Geofence registered: ${workshop.id}  and at ${DateTime.now()}",
      );
    } on NativeGeofenceException catch (e) {
      debugPrint("❌ Geofence error: ${e.code} ${e.message}");
      debugPrint(
        'NativeGeofenceException: ${e.code} ${e.message} ${e.details}',
      );

      if (e.code == NativeGeofenceErrorCode.missingLocationPermission) {
        print('Did the user grant us the location permission yet?');
      }
      if (e.code == NativeGeofenceErrorCode.pluginInternal) {
        print(
          'Some internal error occured: message=${e.message}, detail=${e.details}, stackTrace=${e.stacktrace}',
        );
      }
      // Handle other cases.
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> onEnter(
    HiveRepository hiveRepo,
    SharePreferenceRepository sharePreferenceRepository,
    NotificationService notificationService,
  ) async {
    var checkInTime = await sharePreferenceRepository.getCheckInTime();

    // ── Stale session detection ──────────────────────────────────────
    // If checkInTime exists but is from a previous day, the last session
    // was never closed (force-kill / crash). Close it before new entry.
    if (checkInTime != null) {
      final now = DateTime.now();
      final isSameDay =
          checkInTime.year == now.year &&
          checkInTime.month == now.month &&
          checkInTime.day == now.day;

      if (!isSameDay) {
        dv.log(
          "⚠️ Stale checkInTime detected from ${checkInTime.toIso8601String()}, force-closing old session",
          name: "onEnter_recovery",
        );
        // Close the orphaned session with end-of-that-day as checkout
        await _closeOrphanedSession(
          hiveRepo,
          sharePreferenceRepository,
          checkInTime,
        );
        checkInTime = null; // Allow new entry below
      }
    }
    // ─────────────────────────────────────────────────────────────────

    if (checkInTime == null) {
      var time = await getCurrentDate();

      dv.log("Entered ForeGround ");

      bool isToday = await hiveRepo.isSessionAreFromToday(DateTime.now());
      dv.log("$isToday", name: "isSessionAreFromToday");

      if (!isToday) {
        // Firebase one is also done in hive create record

        await hiveRepo.createRecord();
        dv.log("Hive input task completed");
      }

      await sharePreferenceRepository.setCheckInTime(time);

      notificationService.showEnteredNotification(time);
    }
  }

  static Future<void> onExit(
    HiveRepository hiveRepo,
    SharePreferenceRepository sharePreferenceRepository,
    NotificationService notificationService,
  ) async {
    var spCheckInTime = await sharePreferenceRepository.getCheckInTime();
    dv.log("CheckInTime at exit $spCheckInTime");

    // No active session — clean up defensively and return early
    if (spCheckInTime == null) {
      await sharePreferenceRepository.setCheckInTime(null);
      await sharePreferenceRepository.resetAttendanceTimerState();
      return;
    }

    // Get current time with fallback — must not throw during onDestroy
    DateTime checkOutTime;
    try {
      checkOutTime = await getCurrentDate();
    } catch (e) {
      // Fallback to DateTime.now() if auto-time check fails.
      // Better to save with device time than lose the session entirely.
      checkOutTime = DateTime.now();
      dv.log(
        "⚠️ getCurrentDate failed in onExit, using DateTime.now(): $e",
        name: "onExit_fallback",
      );
    }

    String totalTime = formatDuration(checkOutTime.difference(spCheckInTime));

    Sessions session = Sessions(
      checkInTime: spCheckInTime,
      checkOutTime: checkOutTime,
      timeSpend: totalTime,
    );
    dv.log(session.toString(), name: "session at on exit");
    await hiveRepo.saveSession(session);

    await notificationService.showExitNotification(checkOutTime, totalTime);

    dv.log("${spCheckInTime.day == checkOutTime.day}", name: "isExitedSameDay");

    if (spCheckInTime.day != checkOutTime.day) {
      await hiveRepo.createRecord();
    }

    await sharePreferenceRepository.setCheckInTime(null);
    await sharePreferenceRepository.resetAttendanceTimerState();
  }

  static Future<void> onDwell(FireStoreRepository firestore) async {
    String? rollNo = await SharePreferenceRepository().getRollNo();
    try {
      DateTime date = await getCurrentDate();

      if (rollNo != null) {
        await firestore.markAttendance(
          studentId: rollNo,
          date: formatDate(date: date),
          isPresent: true,
          day: DateFormat("EEEE").format(date),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Closes an orphaned session from a previous day that was never properly
  /// exited (e.g. due to force-kill, crash, or battery optimization kill).
  /// Sets checkOutTime to end-of-day (23:59:59) to cap the duration.
  static Future<void> _closeOrphanedSession(
    HiveRepository hiveRepo,
    SharePreferenceRepository sharePreferenceRepository,
    DateTime orphanedCheckIn,
  ) async {
    // Use end-of-day as the checkout time to cap duration
    final endOfDay = DateTime(
      orphanedCheckIn.year,
      orphanedCheckIn.month,
      orphanedCheckIn.day,
      23,
      59,
      59,
    );

    final duration = endOfDay.difference(orphanedCheckIn);
    final session = Sessions(
      checkInTime: orphanedCheckIn,
      checkOutTime: endOfDay,
      timeSpend: formatDuration(duration),
    );

    dv.log(session.toString(), name: "orphaned_session_closed");
    await hiveRepo.saveSession(session);

    // Finalize the day's record
    await hiveRepo.createRecord();

    // Clear stale state
    await sharePreferenceRepository.setCheckInTime(null);
    await sharePreferenceRepository.resetAttendanceTimerState();
  }

  /// Recovery method callable from app startup or service onStart.
  /// Detects and closes any orphaned session from a previous day.
  static Future<void> recoverOrphanedSession(
    HiveRepository hiveRepo,
    SharePreferenceRepository sharePreferenceRepository,
  ) async {
    final checkInTime = await sharePreferenceRepository.getCheckInTime();
    if (checkInTime == null) return;

    final now = DateTime.now();
    final isSameDay =
        checkInTime.year == now.year &&
        checkInTime.month == now.month &&
        checkInTime.day == now.day;

    if (!isSameDay) {
      dv.log(
        "🔄 Recovering orphaned session from ${checkInTime.toIso8601String()}",
        name: "startup_recovery",
      );
      await _closeOrphanedSession(
        hiveRepo,
        sharePreferenceRepository,
        checkInTime,
      );
    }
  }

  static Future<void> dispose() async {
    SharePreferenceRepository sharePreferenceRepository =
        SharePreferenceRepository();
    await sharePreferenceRepository.setCheckInTime(null);
    await sharePreferenceRepository.setRollNo(null);
    await sharePreferenceRepository.setIsCreated(false);
    await sharePreferenceRepository.resetAttendanceTimerState();
    await NativeGeofenceManager.instance.removeAllGeofences();
  }
}
