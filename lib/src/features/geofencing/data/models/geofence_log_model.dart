import 'package:flutter_cas_app_main/src/features/geofencing/domain/entities/geofence_log.dart';

class GeofenceLogModel extends GeofenceLog {
  GeofenceLogModel({
    required super.latitude,
    required super.longitude,
    required super.entryTime,
    required super.exitTime,
    required super.durationMinutes,
  });

  /// ✅ Convert domain entity to model
  factory GeofenceLogModel.fromEntity(GeofenceLog log) {
    return GeofenceLogModel(
      latitude: log.latitude,
      longitude: log.longitude,
      entryTime: log.entryTime,
      exitTime: log.exitTime,
      durationMinutes: log.durationMinutes,
    );
  }

  /// ✅ Convert back to domain entity
  GeofenceLog toEntity() {
    return GeofenceLog(
      latitude: latitude,
      longitude: longitude,
      entryTime: entryTime,
      exitTime: exitTime,
      durationMinutes: durationMinutes,
    );
  }

  /// ✅ Serialize to Firestore
  Map<String, dynamic> toMap() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "entryTime": entryTime.toIso8601String(),
      "exitTime": exitTime.toIso8601String(),
      "durationMinutes": durationMinutes,
    };
  }

  /// ✅ Deserialize from Firestore
  factory GeofenceLogModel.fromMap(Map<String, dynamic> map) {
    return GeofenceLogModel(
      latitude: (map["latitude"] as num).toDouble(),
      longitude: (map["longitude"] as num).toDouble(),
      entryTime: DateTime.parse(map["entryTime"]),
      exitTime: DateTime.parse(map["exitTime"]),
      durationMinutes: map["durationMinutes"] ?? 0,
    );
  }
}
