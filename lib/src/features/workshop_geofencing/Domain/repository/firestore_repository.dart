import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

import '../../../../../firebase_options.dart';
import '../../../time_graph_page/data/dummy_data.dart';
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
        .set(data);
  }

  Future<void> markAttendance({
    required String studentId,
    required String date,
    required bool isPresent,
    required String day
  }) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.studentCollection)
        .doc(studentId)
        .collection(FirebaseCollections.attendanceCollection)
        .doc(date)
        .set({
          "status": isPresent,
          "date": date,
          "day": day,
        });
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
    var data =
        await FirebaseFirestore.instance
            .collection(FirebaseCollections.studentWorkshopTime)
            .doc(studentId)
            .collection(FirebaseCollections.daysCollection)
            .where('date', isGreaterThanOrEqualTo: start.millisecondsSinceEpoch)
            .where('date', isLessThanOrEqualTo: end.millisecondsSinceEpoch)
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
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(
      Duration(days: now.weekday - 1),
    ); // Monday
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6)); // Sunday

    return await getDaysWorkshopTimeInRange(
      studentId: studentId,
      start: startOfWeek,
      end: endOfWeek,
    );
  }

  Future<List<DailyStudyData>?> getDaysWorkshopTimeForLastWeek({
    required String studentId,
  }) async {
    DateTime now = DateTime.now();
    DateTime endOfLastWeek = now.subtract(
      Duration(days: now.weekday),
    ); // Last Sunday
    DateTime startOfLastWeek = endOfLastWeek.subtract(
      const Duration(days: 6),
    ); // Last Monday

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
