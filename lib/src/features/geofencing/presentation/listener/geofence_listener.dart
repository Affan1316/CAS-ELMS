

import 'package:flutter_cas_app_main/src/features/geofencing/domain/usecases/start_geofencing_usecase.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/domain/usecases/stop_geofencing_usecase.dart';

/// Presentation layer listener (headless)
/// - No UI, just hooks into domain use cases
class GeofenceListener {
  final StartGeofencingUseCase _startGeofencing;
  final StopGeofencingUseCase _stopGeofencing;

  bool _isListening = false;

  GeofenceListener({
    required StartGeofencingUseCase startGeofencing,
    required StopGeofencingUseCase stopGeofencing,
  })  : _startGeofencing = startGeofencing,
        _stopGeofencing = stopGeofencing;

  /// Start listening for geofence events
  Future<void> start({
    required String studentId,
    required double latitude,
    required double longitude,
  }) async {
    if (_isListening) return;
    await _startGeofencing(
      studentId: studentId,
      lat: latitude,
      lng: longitude,
    );
    _isListening = true;
  }

  /// Stop listening for geofence events
  Future<void> stop() async {
    if (!_isListening) return;
    await _stopGeofencing();
    _isListening = false;
  }

  bool get isListening => _isListening;
}
