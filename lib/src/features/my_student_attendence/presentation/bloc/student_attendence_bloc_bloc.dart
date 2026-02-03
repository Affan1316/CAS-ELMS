import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/auth/data/service/AuthService.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/data/reposetory/student_attendence_firebase.dart';
import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Data/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

import '../../../workshop_geofencing/Data/getTimeConversions.dart';
import '../../data/model/model_classes.dart';

part 'student_attendence_bloc_event.dart';
part 'student_attendence_bloc_state.dart';

class StudentAttendenceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  StudentAttendanceFirebase firebase = StudentAttendanceFirebase();
  AuthService authService = AuthService();

  StudentAttendenceBloc() : super(AttendanceLoading()) {
    on<LoadAttendance>(_onLoadAttendance);
    on<LocationCheckEvent>(_onLocationCheckEvent);
  }

  void _onLoadAttendance(
    LoadAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      late DateTime start;
      late DateTime end;

      final user = event.name ?? await authService.getSavedEmail();
      final userId = event.rollNo ?? await authService.getSavedStudentId();

      if (user != null && userId != null) {
        //TODO: add real student data
        var std = Student(name: user, rollNo: userId, imageUrl: "");
        final records = await firebase.getStudentAttendance(userId);
        // Emit the new state with the loaded data
        // Choose the date range you want to show. Here I use last 30 days.
        if (event.dateRange != null) {
          start = event.dateRange!.start;
          end = event.dateRange!.end;
        } else {
          end = DateTime.now();
          start = end.subtract(const Duration(days: 29)); // inclusive 30 days
        }

        // Build a full list filling missing dates as Absent
        final fullRecords = fillMissingWithAbsent(
          existing: records,
          start: start,
          end: end,
          skipWeekends: false, // set false if you want weekends included
        );

        emit(AttendanceLoaded(student: std, records: fullRecords));
      } else {
        emit(AttendanceError(message: 'AuthError User Not Found.'));
      }
    } catch (e) {
      // Emit an error state if something goes wrong
      emit(AttendanceError(message: 'Failed to load attendance data.'));
    }
  }

  FutureOr<void> _onLocationCheckEvent(
    LocationCheckEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    await LocationServiceManager.initLocationService();
    // MyGeofenceService().reCreateFence();
    // getting location trigger event quicker

    bool isLocEnabled = await Geolocator.isLocationServiceEnabled();
    await LocationServiceManager().startLocationService();
    print("_onLocationCheckEvent");
    if (isLocEnabled) {
      Position position = await Geolocator.getCurrentPosition();

      if (!isInGeofenceMeters(
            pointLat: position.latitude,
            pointLon: position.longitude,
            radiusMeters: 70,
          ) ||
          position.isMocked) {
        log("exit at location check event");

        await LocationServiceManager().startLocationService();
        await LocationServiceManager().sendExitEventTag();
      } else {
        log("enter at location check event");
        await LocationServiceManager().startLocationService();
        await LocationServiceManager().sendEnterEventTag();
      }
    }
  }
}

// --- Helpers --- //

DateTime? _parseCustomDate(String s) {
  // Extract all number tokens from the string
  final tokens = RegExp(r'\d+').allMatches(s).map((m) => m.group(0)!).toList();
  if (tokens.isEmpty) return null;

  try {
    // Prefer last token if it's a 4-digit year
    if (tokens.last.length == 4 && tokens.length >= 2) {
      final year = int.parse(tokens.last);
      final day = int.parse(tokens.first);
      final month = tokens.length >= 2 ? int.parse(tokens[1]) : 1;
      return DateTime(year, month, day);
    }

    // If pattern looks like dd-mm-yyyy (third token 4-digit)
    if (tokens.length >= 3 && tokens[2].length == 4) {
      final day = int.parse(tokens[0]);
      final month = int.parse(tokens[1]);
      final year = int.parse(tokens[2]);
      return DateTime(year, month, day);
    }

    // If looks like dd-mm-yy (two-digit year), assume 2000+
    if (tokens.length >= 3) {
      final day = int.parse(tokens[0]);
      final month = int.parse(tokens[1]);
      var yearToken = int.parse(tokens[2]);
      final year = yearToken < 100 ? 2000 + yearToken : yearToken;
      return DateTime(year, month, day);
    }

    // Fallback: try DateTime.parse (ISO) - might throw
    return DateTime.parse(s);
  } catch (e) {
    // If anything fails, return null to allow caller to handle it
    return null;
  }
}

String _normalizedKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String _displayDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.year.toString().padLeft(4, '0')}';

// weekday names: DateTime.weekday is 1..7 where 1 = Monday
String _weekdayName(DateTime d) {
  const names = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return names[d.weekday - 1];
}

List<AttendanceRecord> fillMissingWithAbsent({
  required List<AttendanceRecord> existing,
  required DateTime start,
  required DateTime end,
  bool skipWeekends = true,
}) {
  // build map by normalized date key (yyyy-MM-dd)
  final Map<String, AttendanceRecord> map = {};
  for (var r in existing) {
    final parsed = _parseCustomDate(r.date);
    if (parsed != null) {
      final key = _normalizedKey(parsed);
      map[key] = r;
    } else {
      // If parsing fails, try to also store it by the raw date to avoid dropping
      map[r.date] = r;
    }
  }

  final List<AttendanceRecord> result = [];
  for (
    var d = DateTime(start.year, start.month, start.day);
    !d.isAfter(DateTime(end.year, end.month, end.day));
    d = d.add(const Duration(days: 1))
  ) {
    if (skipWeekends &&
        (d.weekday == DateTime.saturday || d.weekday == DateTime.sunday)) {
      continue;
    }

    final key = _normalizedKey(d);
    if (map.containsKey(key)) {
      // Use the existing record (keep whatever fields it had)
      result.add(map[key]!);
    } else {
      // Create a synthetic Absent record. Adjust the constructor to your model.
      result.add(
        AttendanceRecord(
          date: _displayDate(d), // human-friendly display date
          day: _weekdayName(d), // correct weekday name
          status: AttendanceStatus.absent, // synthesized status
          // add other fields as needed
        ),
      );
    }
  }

  // Optional: sort descending or ascending depending on UI expectation:
  result.sort((a, b) {
    final da = _parseCustomDate(a.date) ?? DateTime(2000);
    final db = _parseCustomDate(b.date) ?? DateTime(2000);
    return db.compareTo(da); // newest first
  });

  return result;
}
