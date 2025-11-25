import 'dart:developer';

import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Domain/repository/firestore_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../Data/getTimeConversions.dart';
import '../../Data/model/all_sessions_for_a_day.dart';
import '../../Data/model/session_model.dart';
import '../../Data/model/workshoptime_model.dart';
import 'shared_preference_repository.dart';

class HiveRepository {
  static final HiveRepository _instance = HiveRepository._internal();
  factory HiveRepository() {
    return _instance;
  }
  HiveRepository._internal();

  Future<void> initFlutter() async {
    await Hive.initFlutter();

    Hive.registerAdapter(SessionsAdapter());
    Hive.registerAdapter(AllSessionsForADayAdapter());
    await Hive.openBox<Sessions>(HiveBoxes.sessions);
    await Hive.openBox<AllSessionsForADay>(HiveBoxes.allSessionsForADay);
  }

  // For initilizing in service
  Future<void> initInService() async {
    // Background isolate → re-init Hive
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    // Must register adapter here too
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SessionsAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AllSessionsForADayAdapter());
    }
    await Hive.openBox<Sessions>(HiveBoxes.sessions);
    await Hive.openBox<AllSessionsForADay>(HiveBoxes.allSessionsForADay);
  }

  ////////////////////////////////////// Some DB func for Session Box //////////////////////////////////////

  Future<void> saveSession(Sessions session) async {
    final box = Hive.box<Sessions>(HiveBoxes.sessions);
    var as = await box.add(session);
    log("Session Saved $as", name: "Session Saved");
  }

  Future<List<Sessions>> getAllSessions() async {
    final box = Hive.box<Sessions>(HiveBoxes.sessions);
    return box.values.toList();
  }

  Future<Duration> getTotalDurationOfToday() async {
    final box = Hive.box<Sessions>(HiveBoxes.sessions);
    Duration totalDuration = Duration.zero;
    if (box.isEmpty) {
      return totalDuration;
    }
    for (var session in box.values) {
      totalDuration += session.checkOutTime.difference(session.checkInTime);
      log(totalDuration.toString(), name: "totalDuration in loop");
    }
    log(totalDuration.toString(), name: "totalDuration final in Func");
    return totalDuration;
  }

  Future<DateTime?> getLastCheckOut() async {
    final box = Hive.box<Sessions>(HiveBoxes.sessions);
    if (box.isEmpty) {
      return null;
    }
    // Access the last session and its checkOutTime
    return box.values.last.checkOutTime;
  }

  Future<bool> isSessionAreFromToday(DateTime today) async {
    final box = Hive.box<Sessions>(HiveBoxes.sessions);
    if (box.isEmpty) {
      return true;
    } else {
      for (var session in box.values) {
        if (session.checkInTime.year == today.year &&
            session.checkInTime.month == today.month &&
            session.checkInTime.day == today.day) {
          return true;
        }
      }
      return false;
    }
  }

  Future<void> deleteSession(Sessions session) async {
    final box = Hive.box<Sessions>(HiveBoxes.sessions);
    await box.delete(session.checkInTime);
  }

  Future<void> deleteAllSessions() async {
    final box = Hive.box<Sessions>(HiveBoxes.sessions);
    await box.clear();
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////                                      Some DB func for AllSessionForaDay Box    ////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> saveSessionsForADay({
    required AllSessionsForADay sessions,
  }) async {
    final box = Hive.box<AllSessionsForADay>(HiveBoxes.allSessionsForADay);
    var allDaySession = await box.add(sessions);
    log("Session Saved $allDaySession", name: "All Session For a Day Saved");
  }

  Future<List<AllSessionsForADay>> getAllSessionsForADay() async {
    final box = Hive.box<AllSessionsForADay>(HiveBoxes.allSessionsForADay);
    return box.values.toList();
  }

  Future<void> createRecord() async {
    Duration totalDuration = await getTotalDurationOfToday();

    log(totalDuration.toString(), name: "totalDuration");
    List<Sessions> sessions = await getAllSessions();
    log("${sessions.length}", name: "sessions");

    if (sessions.isNotEmpty) {
      var allDaySession = AllSessionsForADay(
        date: sessions.last.checkInTime,
        sessions: sessions,
        totalDuration: formatDuration(totalDuration),
      );
      log(allDaySession.toString(), name: "allDaySession");
      await saveSessionsForADay(sessions: allDaySession);
      String? rollNo = await SharePreferenceRepository().getRollNo();

      /////////////////////////////////////FireStore  ////////////////////////

      String date = formatDate(date: sessions.last.checkInTime);
      int totalMinutes = getMinutesFromStringDuration(
        formatDuration(totalDuration),
      );

      if (rollNo != null) {
        final firestore = FireStoreRepository();
        log("rollNo at creating a record $rollNo");

        await firestore.addDaysWorkshopTime(
          studentId: rollNo,
          date: date,
          data:
              WorkshoptimeModel(
                date: sessions.last.checkInTime,
                duration: formatDuration(totalDuration),
                sessions:
                    sessions.map((e) {
                      return e.toMap();
                    }).toList(),
              ).toMap(),
        );
        log("time updated successfully");
       
      }

      // dv.log("saveSessionsForAday", name: "saveSessionsForAday");

      await deleteAllSessions();
    }
  }
}

class HiveBoxes {
  static const String sessions = "Sessions";
  static const String allSessionsForADay = "AllSessionsForADay";
}
