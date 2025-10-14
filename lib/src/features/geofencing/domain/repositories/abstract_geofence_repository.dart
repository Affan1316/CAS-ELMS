import '../entities/geofence_log.dart';

abstract class GeofenceRepository {
  Future<void> startGeofencing(String studentId, double lat, double lng);
  Future<void> stopGeofencing();

  Future<void> saveGeofenceLog({
    required String studentId,
    required DateTime date,
    required GeofenceLog log,
  });

  Future<List<GeofenceLog>> getGeofenceLogs({
    required String studentId,
    required DateTime date,
  });

  Future<int> getTotalMinutes({
    required String studentId,
    required DateTime date,
  });
}
