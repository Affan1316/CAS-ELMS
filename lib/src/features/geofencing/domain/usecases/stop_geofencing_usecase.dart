

import 'package:flutter_cas_app_main/src/features/geofencing/domain/repositories/abstract_geofence_repository.dart';

class StopGeofencingUseCase {
  final GeofenceRepository repository;

  StopGeofencingUseCase(this.repository);

  Future<void> call() async {
    return repository.stopGeofencing();
  }
}
