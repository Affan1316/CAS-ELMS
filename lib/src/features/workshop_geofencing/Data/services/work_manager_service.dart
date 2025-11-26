import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../Domain/repository/firestore_repository.dart';
import '../../Domain/repository/hive_repository.dart';
import '../../Domain/repository/shared_preference_repository.dart';
import 'geofence_sevice.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() async {
  log("WorkManager Callback Dispatcher Registered", name: "WorkManager");

  Workmanager().executeTask((task, inputData) async {
    // All asynchronous initialization is moved INSIDE this async closure
    // where the task is guaranteed to run.
    try {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize all necessary services
      final hiveRepo = HiveRepository();
      final fireStoreRepository = FireStoreRepository();
      final notificationService = NotificationService();
      final sharePreferenceRepository = SharePreferenceRepository();

      // Ensure all async setup is awaited here
      await hiveRepo.initInService();
      await sharePreferenceRepository.init();
      await notificationService.initNotification();
      await fireStoreRepository.init();

      log("WorkManager Task Started: $task", name: "WorkManager");

      if (task == WorkManagerService.exitTask) {
        await WorkManagerService.exitTaskFunc(
          hiveRepo,
          sharePreferenceRepository,
          notificationService,
        );
      } else if (task ==
          WorkManagerService.periodicLocationUpdateAndReCreateFenceTask) {
        await WorkManagerService.checkLocationEnabledAndReCreateFence(
          notificationService,
        );
      }

      // Add logic for other tasks like periodicLocationUpdateTask here if needed.

      return Future.value(true); // Indicate success
    } catch (e, stack) {
      log("WorkManager Task Failed: $e\n$stack", name: "WorkManager_Error");
      // Returning true might be okay for one-off tasks, but if you want retry, return false
      return Future.value(false);
    }
  });
}

class WorkManagerService {
  static final WorkManagerService _instance = WorkManagerService._internal();

  factory WorkManagerService() {
    return _instance;
  }

  WorkManagerService._internal();

  Workmanager workmanager = Workmanager();

  static const String simpleTaskKey = "simpleTask";
  static const String exitTask = "exitTask";
  static const String periodicLocationUpdateAndReCreateFenceTask =
      "periodicLocationUpdateAndReCreateFenceTask";
  static const String isPeriodicTaskRegisteredKey = "isPeriodicTaskRegistered";

  // static const String simplePeriodicTaskKey = "simplePeriodicTask";

  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  Future<void> registerOneOfTask({
    required String taskName,
    required String uniqueName,
    Map<String, dynamic>? inputData,
  }) async {
    await workmanager.registerOneOffTask(
      uniqueName,
      taskName,
      inputData: inputData,
      initialDelay: Duration(seconds: 5),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  Future<void> registerPeriodicTask({
    required String taskName,
    required String uniqueName,
    Map<String, dynamic>? inputData,
  }) async {
    await workmanager.registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: Duration(days: 2),
      inputData: inputData,
      initialDelay: Duration(seconds: 5),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  Future<void> cancelTask(String taskName) async {
    await Workmanager().cancelByUniqueName(taskName);
  }

  static Future<void> checkLocationEnabledAndReCreateFence(
    NotificationService notificationService,
  ) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      notificationService.showNotification(
        111,
        "Enable Location Services",
        "Location will always be on So your can be tracked effienciently",
      );
    }
    MyGeofenceService().reCreateFence();
  }

  static Future<void> exitTaskFunc(
    HiveRepository hiveRepo,
    SharePreferenceRepository sharePreferenceRepository,
    NotificationService notificationService,
  ) async {
    notificationService.showNotification(
      4,
      "Service Stopped",
      "You are considered exited from CAS.",
    );
    await MyGeofenceService.onExit(
      hiveRepo,
      sharePreferenceRepository,
      notificationService,
    );
    log("Exit task completed successfully", name: "WorkManager");
  }

  static Future<void>
  registerPeriodicLocationCheckAndReCreateFenceOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final isRegistered = prefs.getBool(isPeriodicTaskRegisteredKey) ?? false;

    if (!isRegistered) {
      // This is the first time the app is running (or after a clear data)
      print("WorkManager: Registering periodic task for the first time.");

      // --- Register the Periodic Task ---
      Workmanager().registerPeriodicTask(
        periodicLocationUpdateAndReCreateFenceTask, // Unique name for the task
        periodicLocationUpdateAndReCreateFenceTask, // Name to identify the task in callbackDispatcher
        frequency: const Duration(
          days: 2,
        ), // Minimum frequency is 15 minutes (Android OS enforced)
        initialDelay: const Duration(seconds: 10), // Optional initial delay
        // Use Constraints for efficiency and system compliance
        constraints: Constraints(
          networkType:
              NetworkType.connected, // Run only when network is available
          requiresBatteryNotLow: true, // Avoid running in low battery
        ),
        // IMPORTANT: Replace the old task if it somehow exists
        existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      );

      // Set the flag so it doesn't register again
      await prefs.setBool(isPeriodicTaskRegisteredKey, true);
    } else {
      print("WorkManager: Periodic task already registered.");
    }
  }

  static Future<void> cancelWorkManger() async {
    await Workmanager().cancelByUniqueName(
      periodicLocationUpdateAndReCreateFenceTask,
    );
  }
}
