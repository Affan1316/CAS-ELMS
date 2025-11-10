import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/presentation/courses_injections.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/inquiry_injections.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/leave_injections.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_it/get_it.dart';

import '../../features/workshop_geofencing/Data/services/geofence_sevice.dart';
import '../../features/workshop_geofencing/Data/services/notification_service.dart';
import '../../features/workshop_geofencing/Data/services/work_manager_service.dart';
import '../../features/workshop_geofencing/Domain/repository/hive_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  await initInquiry(sl);
  await initCourses(sl);
  await initLeave(sl);
  await _initPackages();
}
Future<void> _initPackages() async {
  await MyGeofenceService().init();
  NotificationService().initNotification();
  await HiveRepository().initFlutter();
  FlutterForegroundTask.initCommunicationPort();
  WorkManagerService.initialize();
}