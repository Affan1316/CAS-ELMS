import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

import '../../../../../firebase_options.dart';
import '../../../student_workshop_time_tracker/data/dummy_data.dart';
import '../../Data/getTimeConversions.dart';
import '../../Data/model/workshoptime_model.dart';

class FireStoreRepository {
  static final FireStoreRepository _instance = FireStoreRepository._internal();

  factory FireStoreRepository() {
    return _instance;
  }
  FireStoreRepository._internal();

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  }

  Future<void> addDaysWorkshopTime({
    required String studentId,
    required String date,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.studentWorkshopTime)
        .doc(studentId)
        .collection(FirebaseCollections.daysCollection)
        .doc(date)
        .set(data, SetOptions(merge: true));
  }

  Future<void> markAttendance({
    required String studentId,
    required String date,
    required bool isPresent,
    required String day,
  }) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.studentCollection)
        .doc(studentId)
        .collection(FirebaseCollections.attendanceCollection)
        .doc(date)
        .set({"status": isPresent, "date": date, "day": day});
  }

  Future<WorkshoptimeModel?> getDaysWorkshopTimeOfSpecificDate({
    required String studentId,
    required String date,
  }) async {
    var data =
        await FirebaseFirestore.instance
            .collection(FirebaseCollections.studentWorkshopTime)
            .doc(studentId)
            .collection(FirebaseCollections.daysCollection)
            .doc(date)
            .get();
    if (data.exists) {
      return WorkshoptimeModel.fromMap(data.data()!);
    } else {
      return null;
    }
  }

  Future<List<DailyStudyData>?> getAllDaysWorkshopTime({
    required String studentId,
  }) async {
    var data =
        await FirebaseFirestore.instance
            .collection(FirebaseCollections.studentWorkshopTime)
            .doc(studentId)
            .collection(FirebaseCollections.daysCollection)
            .get();
    if (data.docs.isNotEmpty) {
      var list =
          data.docs.map((e) => WorkshoptimeModel.fromMap(e.data())).toList();
      List<DailyStudyData> dailyStudyDataList =
          list.map((e) {
            double hours = convertHourStringToDouble(e.duration);
            return DailyStudyData(
              date: e.date,
              hours: hours,
              day: DateFormat('E').format(e.date),
            );
          }).toList();
      return dailyStudyDataList;
    } else {
      return null;
    }
  }

  Future<List<DailyStudyData>?> getDaysWorkshopTimeInRange({
    required String studentId,
    required DateTime start,
    required DateTime end,
  }) async {
    // Normalize to start-of-day / end-of-day to avoid time-component exclusions
    final startOfDay = DateTime(start.year, start.month, start.day);
    final endOfDay = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

    var data =
        await FirebaseFirestore.instance
            .collection(FirebaseCollections.studentWorkshopTime)
            .doc(studentId)
            .collection(FirebaseCollections.daysCollection)
            .where('date', isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
            .where('date', isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch)
            .get();
    if (data.docs.isNotEmpty) {
      var list =
          data.docs.map((e) => WorkshoptimeModel.fromMap(e.data())).toList();
      List<DailyStudyData> dailyStudyDataList =
          list.map((e) {
            double hours = convertHourStringToDouble(e.duration);
            return DailyStudyData(
              date: e.date,
              hours: hours,
              day: DateFormat('E').format(e.date),
            );
          }).toList();
      return dailyStudyDataList;
    } else {
      return null;
    }
  }

  Future<List<DailyStudyData>?> getDaysWorkshopTimeForThisWeek({
    required String studentId,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // strip time
    final startOfWeek = today.subtract(
      Duration(days: now.weekday - 1),
    ); // Monday 00:00
    final endOfWeek = startOfWeek.add(const Duration(days: 6)); // Sunday 00:00 (normalized to 23:59:59 in range query)

    return await getDaysWorkshopTimeInRange(
      studentId: studentId,
      start: startOfWeek,
      end: endOfWeek,
    );
  }

  Future<List<DailyStudyData>?> getDaysWorkshopTimeForLastWeek({
    required String studentId,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // strip time
    final endOfLastWeek = today.subtract(
      Duration(days: now.weekday),
    ); // Last Sunday 00:00
    final startOfLastWeek = endOfLastWeek.subtract(
      const Duration(days: 6),
    ); // Last Monday 00:00

    return await getDaysWorkshopTimeInRange(
      studentId: studentId,
      start: startOfLastWeek,
      end: endOfLastWeek,
    );
  }
}

class FirebaseCollections {
  //for student doc is something like   f17-01
  // days collection doc is named as 22-09-2025

  // collection (students)  its doc name on  (roll_no) then  collection (attendence)   it doc named as (date)  and its status is tri

  static const String studentWorkshopTime = "student_workshoptime";
  static const String daysCollection = "days_collection";

  static const String studentCollection = "students";
  static const String attendanceCollection = "attendance";
}
