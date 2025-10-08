

import 'package:flutter_cas_app_main/src/features/geofencing/domain/repositories/abstract_geofence_repository.dart';

class StartGeofencingUseCase {
  final GeofenceRepository repository;

  StartGeofencingUseCase(this.repository);

  Future<void> call({required String studentId, required double lat, required double lng}) async {
    return repository.startGeofencing(studentId, lat, lng);
  }
}
