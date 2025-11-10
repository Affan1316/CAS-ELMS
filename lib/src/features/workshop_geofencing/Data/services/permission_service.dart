import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

// For battery optimization

// For auto start

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();

  factory PermissionService() => _instance;

  PermissionService._internal();
  //////////////////////////PERMISSION CHECKS////////////////////////////////////////////////
  Future<bool> hasNotificationPermission() async {
    return await Permission.notification.isGranted;
  }

  Future<bool> hasLocationPermission() async {
    return await Permission.location.isGranted;
  }

  Future<bool> hasLocationAlwaysPermission() async {
    return await Permission.locationAlways.isGranted;
  }


  /// Checks and requests battery optimization ignore
  /// Requests the user to ignore battery optimizations for this app on Android.
  ///
  /// This method checks if the platform is Android and whether battery optimization
  /// is already disabled for the app. If not, it opens the relevant settings screens
  /// for the user to manually disable battery optimization and enable auto-start.
  /// No action is taken on non-Android platforms.
  Future<void> requestIgnoreBatteryOptimizations() async {
    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }
    }
  }

  Future<void> handleAllPermissions() async {
    await Permission.notification.request();
    await Permission.location.request();
    await Permission.locationAlways.request();
    await requestIgnoreBatteryOptimizations();
  }
}
