import 'package:flutter_cas_app_main/src/features/geofencing/data/datasource/geofence_firebase_datasource.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/data/datasource/geofence_service_impl.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/data/models/geofence_log_model.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/domain/entities/geofence_log.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/domain/repositories/abstract_geofence_repository.dart';

class GeofenceRepositoryImpl implements GeofenceRepository {
  final GeofenceFirebaseDataSource firebaseDataSource;
  final GeofenceServiceImpl geofenceService;

  GeofenceRepositoryImpl({
    required this.firebaseDataSource,
    required this.geofenceService,
  });

  @override
  Future<void> saveGeofenceLog({
    required String studentId,
    required DateTime date,
    required GeofenceLog log,
  }) async {
    final logModel = GeofenceLogModel.fromEntity(log);
    await firebaseDataSource.saveLog(
      studentId: studentId,
      log: logModel,
    );
  }

  @override
  Future<List<GeofenceLog>> getGeofenceLogs({
    required String studentId,
    required DateTime date,
  }) async {
    final models = await firebaseDataSource.getLogs(
      studentId: studentId,
      date: date,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<int> getTotalMinutes({
    required String studentId,
    required DateTime date,
  }) async {
    return await firebaseDataSource.getTotalMinutes(
      studentId: studentId,
      date: date,
    );
  }

  @override
  Future<void> startGeofencing(String studentId, double lat, double lng) async {
    geofenceService.startAndAddGeofence(
      latitude: lat,
      longitude: lng,
      id: studentId,
    );
  }

  @override
  Future<void> stopGeofencing() async {
    geofenceService.stopService();
  }
}
