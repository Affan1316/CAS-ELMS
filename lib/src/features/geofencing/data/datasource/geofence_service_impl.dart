import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/firebase_options.dart';
import 'package:geofence_foreground_service/geofence_foreground_service.dart';
import 'package:geofence_foreground_service/constants/geofence_event_type.dart';
import 'package:geofence_foreground_service/models/notification_icon_data.dart';
import 'package:geofence_foreground_service/models/zone.dart';
import 'package:geolocator/geolocator.dart' hide ServiceStatus;
import 'package:latlng/latlng.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/domain/entities/geofence_log.dart';

/// ✅ Background entry point
@pragma('vm:entry-point')
void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  GeofenceForegroundService().handleTrigger(
    backgroundTriggerHandler: (zoneID, triggerType) async {
      final now = DateTime.now();
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
      );
      final firestore = FirebaseFirestore.instance;

      const String studentId = "F17-02"; // 🔹 You can pass dynamically if needed

      final todayStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final docRef = firestore
          .collection("students")
          .doc(studentId)
          .collection("attendance")
          .doc(todayStr);

      // Read from local cache or server
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        // First event of the day → create doc
        await docRef.set({
          "locationLogs": [
            {
              "zoneId": zoneID,
              "event": triggerType.toString(),
              "timestamp": now.toIso8601String(),
            }
          ],
          "lastEnterTime": triggerType == GeofenceEventType.enter
              ? now.toIso8601String()
              : null,
          "status": "absent", // default until >= 40 minutes
        });
      } else {
        final data = snapshot.data()!;
        final List logs = List.from(data["locationLogs"] ?? []);
        logs.add({
          "zoneId": zoneID,
          "event": triggerType.toString(),
          "timestamp": now.toIso8601String(),
        });

        String? lastEnterTimeStr = data["lastEnterTime"];
        DateTime? lastEnterTime =
            lastEnterTimeStr != null ? DateTime.parse(lastEnterTimeStr) : null;

        String status = data["status"] ?? "absent";

        if (triggerType == GeofenceEventType.enter) {
          // Save entry time
          await docRef.update({
            "lastEnterTime": now.toIso8601String(),
            "locationLogs": logs,
          });
        } else if (triggerType == GeofenceEventType.exit && lastEnterTime != null) {
          // Calculate stay duration
          final duration = now.difference(lastEnterTime).inMinutes;

          // Mark present if >= 40 minutes total for today
          // Once "present", never downgrade to "absent"
          if (duration >= 40 || status == "present") {
            status = "present";
          } else {
            status = "absent";
          }

          await docRef.update({
            "lastEnterTime": null,
            "status": status,
            "locationLogs": logs,
          });
        } else {
          // Just log the event (dwell/unexpected cases)
          await docRef.update({"locationLogs": logs});
        }
      }

      return Future.value(true);
    },
  );
}




class GeofenceServiceImpl {
  bool _hasServiceStarted = false;
  Timer? _locationMonitorTimer;
  bool _wasLocationOn = true;

  Future<bool> requestPermission() async {
    final locationStatus = await Permission.location.request();
    final backgroundStatus = await Permission.locationAlways.request();
    return locationStatus.isGranted && backgroundStatus.isGranted;
  }

  /// ✅ Start foreground geofencing service
  Future<void> startAndAddGeofence({
    required String id,
    required double latitude,
    required double longitude,
    double radius = 100,
  }) async {
    await requestPermission();

    if (!_hasServiceStarted) {
      _hasServiceStarted = await GeofenceForegroundService()
          .startGeofencingService(
        contentTitle: 'Geofencing Active',
        contentText: 'Tracking your geofence activity',
        notificationChannelId: 'com.app.geofencing_notifications_channel',
        serviceId: 525600,
        isInDebugMode: true,
        callbackDispatcher: callbackDispatcher,
      );

      log("Geofence Service Started: $_hasServiceStarted",
          name: "GeofenceServiceImpl");
    }

    if (_hasServiceStarted) {
      await GeofenceForegroundService().addGeofenceZone(
        zone: Zone(
          id: id,
          radius: radius,
          coordinates: [LatLng.degree(latitude, longitude)],
          triggers: [GeofenceEventType.enter, GeofenceEventType.exit],
          expirationDuration: const Duration(days: 1),
        ),
      );

      // ✅ Start monitoring if user turns off location
      _startLocationMonitor();

      log("Geofence Added: $id", name: "GeofenceServiceImpl");
    } else {
      log("❌ Failed to start service", name: "GeofenceServiceImpl");
    }
  }

  /// 🔍 Monitor if location is turned off manually
  void _startLocationMonitor() {
    _locationMonitorTimer?.cancel();
    _locationMonitorTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final status = await Permission.location.serviceStatus;
      final isLocationOn = status == ServiceStatus.enabled;

      if (!isLocationOn && _wasLocationOn) {
        // ✅ User just turned location OFF — simulate EXIT event
        _wasLocationOn = false;
        log("⚠️ Location turned off — treating as geofence EXIT");

        await _handleLocationOffAsExit();
      } else if (isLocationOn && !_wasLocationOn) {
        // ✅ User turned location back ON
        _wasLocationOn = true;
        await _handleLocationOnAsEnter();
      }
    });
  }

  /// ✅ When location is turned off, save "exit" event in Firestore
  Future<void> _handleLocationOffAsExit() async {
    final firestore = FirebaseFirestore.instance;
    const studentId = "F17-02"; // Replace dynamically if needed
    final now = DateTime.now();
    final todayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final docRef = firestore
        .collection("students")
        .doc(studentId)
        .collection("attendance")
        .doc(todayStr);

    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data()!;
    final List logs = List.from(data["locationLogs"] ?? []);
    logs.add({
      "zoneId": "manual_exit",
      "event": "location_off_exit",
      "timestamp": now.toIso8601String(),
    });

    String? lastEnterTimeStr = data["lastEnterTime"];
    DateTime? lastEnterTime =
        lastEnterTimeStr != null ? DateTime.parse(lastEnterTimeStr) : null;

    String status = data["status"] ?? "absent";

    if (lastEnterTime != null) {
      final duration = now.difference(lastEnterTime).inMinutes;
      if (duration >= 40 || status == "present") {
        status = "present";
      } else {
        status = "absent";
      }
    }

    await docRef.update({
      "lastEnterTime": null,
      "status": status,
      "locationLogs": logs,
    });

    log("📤 Stored manual exit due to location off", name: "GeofenceServiceImpl");
  }


  Future<void> _handleLocationOnAsEnter() async {
  try {
    // ✅ Step 1: Define your zone center and radius (e.g., school location)
    const double zoneLatitude = 29.394702; // example: Lahore coordinates
    const double zoneLongitude = 71.652824;
    const double zoneRadiusMeters = 50.0; // 50m radius around school

    // ✅ Step 2: Check if location permission is granted
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        log("🚫 Location permission denied. Cannot check zone.", name: "GeofenceServiceImpl");
        return;
      }
    }

    // ✅ Step 3: Get current GPS position
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final double userLat = position.latitude;
    final double userLng = position.longitude;

    // ✅ Step 4: Calculate distance from user to zone center
    final double distance = Geolocator.distanceBetween(
      userLat,
      userLng,
      zoneLatitude,
      zoneLongitude,
    );

    log("📍 User distance from zone: ${distance.toStringAsFixed(2)} meters", name: "GeofenceServiceImpl");

    // ✅ Step 5: Only store enter log if user is inside the zone radius
    if (distance <= zoneRadiusMeters) {
      final firestore = FirebaseFirestore.instance;
      const studentId = "F17-02";
      final now = DateTime.now();
      final todayStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final docRef = firestore
          .collection("students")
          .doc(studentId)
          .collection("attendance")
          .doc(todayStr);

      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        await docRef.set({
          "locationLogs": [
            {
              "zoneId": "manual_enter",
              "event": "location_on_enter",
              "timestamp": now.toIso8601String(),
              "distance": distance,
            }
          ],
          "lastEnterTime": now.toIso8601String(),
          "status": "absent",
        });
      } else {
        final data = snapshot.data()!;
        final List logs = List.from(data["locationLogs"] ?? []);
        logs.add({
          "zoneId": "manual_enter",
          "event": "location_on_enter",
          "timestamp": now.toIso8601String(),
          "distance": distance,
        });

        await docRef.update({
          "lastEnterTime": now.toIso8601String(),
          "locationLogs": logs,
        });
      }

      log("✅ User is inside the zone. Manual enter stored.", name: "GeofenceServiceImpl");
    } else {
      log("⚠️ User is NOT inside the zone. Manual enter skipped.", name: "GeofenceServiceImpl");
    }
  } catch (e) {
    log("❌ Error checking location on enter: $e", name: "GeofenceServiceImpl");
  }
}

  /// ✅ Stop service and timer
  Future<void> stopService() async {
    await GeofenceForegroundService().stopGeofencingService();
    _hasServiceStarted = false;
    _locationMonitorTimer?.cancel();
  }
}
