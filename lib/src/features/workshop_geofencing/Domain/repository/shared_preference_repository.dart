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
    bool? boolean = await prefs.setString(
      SharedPreferenceKeys.checkInTime,
      dateTime?.toIso8601String() ?? "",
    );
    log(boolean.toString(), name: "setting CheckIn Time");
    return boolean;
  }

  Future<DateTime?> getCheckInTime() async {
    var prefs = await SharedPreferences.getInstance();

    String? dateTimeString = prefs.getString(SharedPreferenceKeys.checkInTime);
    log(dateTimeString.toString(), name: "getting CheckIn Time");
    if (dateTimeString != null && dateTimeString.isNotEmpty) {
      return DateTime.tryParse(dateTimeString);
    } else  {
      return null;
    }
  }

  Future<bool> setRollNo(String rollNo) async {
    var prefs = await SharedPreferences.getInstance();
    bool boolean = await prefs.setString(SharedPreferenceKeys.rollNo, rollNo);
    log(boolean.toString(), name: "setting RollNo");
    return boolean;
  }

  Future<String?> getRollNo() async {
    var prefs = await SharedPreferences.getInstance();

    String? rollNo = prefs.getString(SharedPreferenceKeys.rollNo);
    log(rollNo.toString(), name: "getting RollNo");
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
}

class SharedPreferenceKeys {
  static const String isCreated = "isCreated";
  static const String checkInTime = "checkInTime";
  static const String rollNo = "rollNo";
}
