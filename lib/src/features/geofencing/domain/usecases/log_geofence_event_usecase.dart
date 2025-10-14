import 'package:flutter_cas_app_main/src/features/geofencing/domain/repositories/abstract_geofence_repository.dart';

import '../entities/geofence_log.dart';

class LogGeofenceEventUseCase {
  final GeofenceRepository repository;

  LogGeofenceEventUseCase(this.repository);

  Future<void> call({
    required String studentId,
    required GeofenceLog log,
  }) async {
    final date = log.entryTime; // logs are grouped by entry date
    return repository.saveGeofenceLog(
      studentId: studentId,
      date: date,
      log: log,
    );
  }
}
