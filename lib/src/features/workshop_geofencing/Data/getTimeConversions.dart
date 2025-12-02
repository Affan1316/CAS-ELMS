import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:time_config_checker/time_config_checker.dart';

String formatDuration(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
  return "${twoDigits(d.inHours)}:$twoDigitMinutes";
}

int getMinutesFromStringDuration(String duration) {
  // Split the string using ':' as the separator
  final parts = duration.split(':');

  // Validate format
  if (parts.length != 2) {
    throw FormatException('Invalid duration format. Expected HH:MM');
  }

  // Parse hours and minutes
  final hours = int.tryParse(parts[0]) ?? 0;
  final minutes = int.tryParse(parts[1]) ?? 0;

  // Return total minutes
  return hours * 60 + minutes;
}

String formatDate({required DateTime date}) {
  return DateFormat('dd-MM-yyyy').format(date);
}

String formatTimeFromDate({required DateTime date}) {
  return DateFormat('hh:mm a').format(date);
}

double convertHourStringToDouble(String hourString) {
  final parts = hourString.split(":");
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final totalHours = hours + (minutes / 60.0);
  final formattedHours = double.parse(totalHours.toStringAsFixed(2));
  return formattedHours;
}

Future<DateTime> getCurrentDate() async {
  // If there is a network issue, check local time configuration
  TimeConfig timeConfig = await TimeConfigChecker().getTimeConfig();
  if (timeConfig.isAutomaticTime && timeConfig.isAutomaticTimeZone) {
    // Use local device time if automatic time and timezone are enabled
    return DateTime.now();
  } else {
    // Throw an error if automatic time/timezone is not enabled
    throw Exception(
      'Unable to fetch network time and automatic time is disabled.',
    );
  }
}

bool isInGeofenceMeters({
  required double pointLat,
  required double pointLon,
  double centerLat = 29.3829577,
  double centerLon = 71.7154831,
  double radiusMeters = 50,
}) {
  double distanceMeters = Geolocator.distanceBetween(
    centerLat,
    centerLon,
    pointLat,
    pointLon,
  );

  // --- 4. Check against the geofence radius ---
  return distanceMeters <= radiusMeters;
}
