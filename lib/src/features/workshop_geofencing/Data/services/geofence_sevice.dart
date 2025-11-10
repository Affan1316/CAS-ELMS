import 'dart:async';
import 'dart:developer' as dv;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Domain/repository/firestore_repository.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/intl.dart';
import 'package:native_geofence/native_geofence.dart';

import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Data/services/location_service.dart';

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
  await locationService.initLocationService();
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
       await tryToPromoteToForeground();
      await locationService.startLocationService();
      await locationService.sendDwellEventTag();
        await demoteToBackground();
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

  Future<void> reCreatefence() {
    return nativeGeofence.reCreateAfterReboot();
  }

  /// Initialize geofence and listeners
  Future<void> createGeofence({
    double latitude = 29.382988,
    double longitude = 71.715538,
    double radius = 20, // meters
  }) async {
    // nativeGeofence.initialize();
    Geofence workshop = Geofence(
      id: 'CAS-Fence',
      location: Location(latitude: latitude, longitude: longitude),
      radiusMeters: radius,
      triggers: {GeofenceEvent.enter, GeofenceEvent.exit, GeofenceEvent.dwell},

      iosSettings: const IosGeofenceSettings(initialTrigger: true),
      androidSettings: AndroidGeofenceSettings(
        initialTriggers: {GeofenceEvent.enter},

        loiteringDelay: const Duration(minutes: 40),
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
    if (checkInTime == null) {
      dv.log("Entered ForeGround ");

      bool isToday = await hiveRepo.isSessionAreFromToday(DateTime.now());
      dv.log("$isToday", name: "isSessionAreFromToday");

      if (!isToday) {
        // Firebase one is also done in hive create record

        await hiveRepo.createRecord();
        dv.log("Hive input task completed");
      }

      sharePreferenceRepository.setCheckInTime(await getCurrentDate());

      notificationService.showNotification(
        3,
        "Welcome To CAS",
        "You have entered at ${DateFormat("dd/MM/yy hh:mm a").format(DateTime.now())}",
      );
    }
  }

  static Future<void> onExit(
    HiveRepository hiveRepo,
    SharePreferenceRepository sharePreferenceRepository,
    NotificationService notificationService,
  ) async {
    // HiveRepository hiveRepo = HiveRepository();
    // await tryToPromoteToForeground();
    var spCheckInTime = await sharePreferenceRepository.getCheckInTime();

    var checkOutTime = await getCurrentDate();
    dv.log("CheckInTime at exit $spCheckInTime");
    if (spCheckInTime != null) {
      String totalTime = formatDuration(checkOutTime.difference(spCheckInTime));

      Sessions session = Sessions(
        checkInTime: spCheckInTime,
        checkOutTime: checkOutTime,
        timeSpend: totalTime,
      );
      dv.log(session.toString(), name: "session at on exit");
      await hiveRepo.saveSession(session);

      await notificationService.showNotification(
        1,
        "Have a nice day",
        "You have left the CAS at ${DateFormat("dd/MM/yy hh:mm a").format(DateTime.now())} with total time: $totalTime and remember to complete assignments!",
      );

      await NotificationService().showNotification(
        2,
        "record related ",
        "record saved a Session $session",
      );

      dv.log(
        "${spCheckInTime.day == checkOutTime.day}",
        name: "isExitedSameDay",
      );

      if (spCheckInTime.day != checkOutTime.day) {
        await hiveRepo.createRecord();
      }
    }

    sharePreferenceRepository.setCheckInTime(null);
  }

  static Future<void> onDwell(
    FireStoreRepository firestore,
    
  ) async {
    String? rollNo = await SharePreferenceRepository().getRollNo();
    try {
      DateTime date = await getCurrentDate();

      if (rollNo != null) {
        await firestore.markAttendance(
          studentId: rollNo,
          date: formatDate(date: date),
          isPresent: true,
          day: DateFormat("E").format(date),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void dispose() {}
}
