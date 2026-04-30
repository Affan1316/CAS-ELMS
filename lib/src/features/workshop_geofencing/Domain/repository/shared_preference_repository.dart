import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharePreferenceRepository {
  //////////////////Singleton////////////////////////////////////////////////////////////////
  static final SharePreferenceRepository _instance =
      SharePreferenceRepository._internal();

  factory SharePreferenceRepository() {
    return _instance;
  }
  SharePreferenceRepository._internal();
  ///////////////////////////////////////////////////////////////////////////////////////

  Future<void> init() async {
    await SharedPreferences.getInstance();
  }

  Future<bool> setCheckInTime(DateTime? dateTime) async {
    var prefs = await SharedPreferences.getInstance();

    if (dateTime == null) {
      // proper way to set null: remove the key
      return prefs.remove(SharedPreferenceKeys.checkInTime);
    }

    bool boolean = await prefs.setString(
      SharedPreferenceKeys.checkInTime,
      dateTime.toIso8601String(),
    );

    log(
      "$boolean time is ${dateTime.toIso8601String()}",
      name: "setting CheckIn Time",
    );

    return boolean;
  }

  Future<DateTime?> getCheckInTime() async {
    var prefs = await SharedPreferences.getInstance();

    String? dateTimeString = prefs.getString(SharedPreferenceKeys.checkInTime);
    log(dateTimeString.toString(), name: "getting CheckIn Time");
    if (dateTimeString != null && dateTimeString.isNotEmpty) {
      return DateTime.tryParse(dateTimeString);
    } else {
      return null;
    }
  }

  Future<bool> setRollNo(String? rollNo) async {
    var prefs = await SharedPreferences.getInstance();

    if (rollNo == null || rollNo.isEmpty) {
      // Remove the key entirely so getRollNo() returns null
      return prefs.remove(SharedPreferenceKeys.rollNo);
    }

    bool boolean = await prefs.setString(SharedPreferenceKeys.rollNo, rollNo);
    log(boolean.toString(), name: "setting RollNo");
    return boolean;
  }

  Future<String?> getRollNo() async {
    var prefs = await SharedPreferences.getInstance();

    String? rollNo = prefs.getString(SharedPreferenceKeys.rollNo);
    log(rollNo.toString(), name: "getting RollNo");

    // Defensive: treat empty string as null
    if (rollNo == null || rollNo.isEmpty) {
      return null;
    }
    return rollNo;
  }

  Future<bool> setIsCreated(bool isCreated) async {
    var prefs = await SharedPreferences.getInstance();
    bool? boolean = await prefs.setBool(
      SharedPreferenceKeys.isCreated,
      isCreated,
    );
    log(boolean.toString(), name: "setting isCreated fence");
    return boolean;
  }

  Future<bool> getIsCreated() async {
    var prefs = await SharedPreferences.getInstance();

    bool? boolean = prefs.getBool(SharedPreferenceKeys.isCreated);
    return boolean ?? false;
  }

  // ─── Attendance Timer Persistence ───────────────────────────────────

  /// Persist the attendance-marked flag with the date it was marked.
  /// This survives process death so the timer doesn't re-mark attendance
  /// after a service restart on the same day.
  Future<bool> setAttendanceMarked(String dateKey) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString(SharedPreferenceKeys.attendanceMarkedDate, dateKey);
  }

  /// Returns true if attendance was already marked for [dateKey] (e.g. "29-04-2026").
  Future<bool> isAttendanceMarkedForDate(String dateKey) async {
    var prefs = await SharedPreferences.getInstance();
    String? markedDate = prefs.getString(
      SharedPreferenceKeys.attendanceMarkedDate,
    );
    return markedDate == dateKey;
  }

  /// Persist minutes passed in the attendance timer so it can resume
  /// after process death instead of restarting from 0.
  Future<bool> setAttendanceMinutesPassed(int minutes) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setInt(SharedPreferenceKeys.attendanceMinutesPassed, minutes);
  }

  Future<int> getAttendanceMinutesPassed() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedPreferenceKeys.attendanceMinutesPassed) ?? 0;
  }

  /// Reset all attendance timer state. Called when a session is fully closed.
  Future<void> resetAttendanceTimerState() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceKeys.attendanceMarkedDate);
    await prefs.remove(SharedPreferenceKeys.attendanceMinutesPassed);
  }
}

class SharedPreferenceKeys {
  static const String isCreated = "isCreated";
  static const String checkInTime = "checkInTime";
  static const String rollNo = "rollNo";
  static const String attendanceMarkedDate = "attendanceMarkedDate";
  static const String attendanceMinutesPassed = "attendanceMinutesPassed";
}
