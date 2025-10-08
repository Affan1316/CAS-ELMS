import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/data/models/geofence_log_model.dart';

class GeofenceFirebaseDataSource {
  final FirebaseFirestore firestore;

  GeofenceFirebaseDataSource(this.firestore);

  /// Save a geofence log into Firestore
  Future<void> saveLog({
    required String studentId,
    required GeofenceLogModel log,
  }) async {
    final today = log.entryTime;
    final todayStr =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final docRef = firestore
        .collection('students')
        .doc(studentId)
        .collection('attendance')
        .doc(todayStr);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        transaction.set(docRef, {
          "locationLogs": [log.toMap()],
          "totalMinutes": log.durationMinutes,
        });
      } else {
        final data = snapshot.data()!;
        final List logs = data["locationLogs"] ?? [];
        logs.add(log.toMap());

        transaction.update(docRef, {
          "locationLogs": logs,
          "totalMinutes": (data["totalMinutes"] ?? 0) + log.durationMinutes,
        });
      }
    });
  }

  /// Get all logs for a student on a specific day
  Future<List<GeofenceLogModel>> getLogs({
    required String studentId,
    required DateTime date,
  }) async {
    final dateStr =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    final doc = await firestore
        .collection('students')
        .doc(studentId)
        .collection('attendance')
        .doc(dateStr)
        .get();

    if (!doc.exists) return [];

    final data = doc.data()!;
    final List logs = data["locationLogs"] ?? [];
    return logs.map((e) => GeofenceLogModel.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  /// Get total minutes for a student on a specific day
  Future<int> getTotalMinutes({
    required String studentId,
    required DateTime date,
  }) async {
    final dateStr =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    final doc = await firestore
        .collection('students')
        .doc(studentId)
        .collection('attendance')
        .doc(dateStr)
        .get();

    if (!doc.exists) return 0;

    return doc.data()?["totalMinutes"] ?? 0;
  }
}
