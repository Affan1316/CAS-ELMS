class GeofenceLog {
  final double latitude;
  final double longitude;
  final DateTime entryTime;
  final DateTime exitTime;
  final int durationMinutes;
  

  GeofenceLog({required this.longitude, required this.latitude, required this.durationMinutes, required this.entryTime, required this.exitTime});
}