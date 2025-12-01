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
    TimerForAttendance.startTimer(FireStoreRepository());
    isInCAS = false;
    entryTime = null; // Reset entry time
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    TimerForAttendance.stopTimer();
    workManagerService.registerOneOfTask(
      taskName: WorkManagerService.exitTask,
      uniqueName:
          "${WorkManagerService.exitTask}_${DateTime.now().millisecondsSinceEpoch}",
    );
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

    final Position pos = await Geolocator.getCurrentPosition();
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
    // if (!pos.isMocked) {
    if (data == enterTag) {
      dv.log("Received Enter Tag", name: "LocationTaskHandler");
      isInCAS = true;
      await MyGeofenceService.onEnter(hiveRepo, s, notificationService);

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
    // } else {
    //   notificationService.showSpoofedLocNotification();
    // }
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
        showNotification: false,
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
    if (await FlutterForegroundTask.isRunningService) {
      // Service is already running
      return;
    }
    try {
      await FlutterForegroundTask.startService(
        notificationTitle: 'Location Service Running',
        notificationText: 'tracking location to track Time in CAS',
        callback: startCallback,
        notificationButtons: [NotificationButton(id: "stop", text: "Stop")],
      );
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

  static Future<void> startTimer(FireStoreRepository firestore) async {
    _attendanceTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      _minutesPassed++;

      // ⭐ After 40 minutes → mark attendance
      if (_minutesPassed >= 40) {
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
        TimerForAttendance.stopTimer();
      }
    });
  }

  static void stopTimer() {
    _attendanceTimer?.cancel(); // stop timer
    _attendanceTimer = null;
  }
}
