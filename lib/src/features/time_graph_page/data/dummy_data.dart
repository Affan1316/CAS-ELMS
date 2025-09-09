import 'dart:math';

import 'package:intl/intl.dart';

List<String> aiGroups = List.generate(20, (i) => "A${i + 1}");
List<String> androidGroups = List.generate(20, (i) => "AS${i + 1}");
List<String> flutterGroups = List.generate(20, (i) => "F${i + 1}");


final DateTime now = DateTime.now();
final DateTime monthStart = DateTime(now.year, now.month, 1);
final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;


 // Sample data for different time periods
  final Map<String, List<DailyStudyData>> studyData = {
    'This Week': [
      DailyStudyData(day: 'Mon', hours: 3.5, date: DateTime.now().subtract(Duration(days: 6))),
      DailyStudyData(day: 'Tue', hours: 5.2, date: DateTime.now().subtract(Duration(days: 5))),
      DailyStudyData(day: 'Wed', hours: 4.0, date: DateTime.now().subtract(Duration(days: 4))),
      DailyStudyData(day: 'Thu', hours: 6.7, date: DateTime.now().subtract(Duration(days: 3))),
      DailyStudyData(day: 'Fri', hours: 2.8, date: DateTime.now().subtract(Duration(days: 2))),
      DailyStudyData(day: 'Sat', hours: 0, date: DateTime.now().subtract(Duration(days: 1))),
      DailyStudyData(day: 'Sun', hours: 0, date: DateTime.now()),
    ],
    'Last Week': [
      DailyStudyData(day: 'Mon', hours: 4.2, date: DateTime.now().subtract(Duration(days: 13))),
      DailyStudyData(day: 'Tue', hours: 3.8, date: DateTime.now().subtract(Duration(days: 12))),
      DailyStudyData(day: 'Wed', hours: 5.5, date: DateTime.now().subtract(Duration(days: 11))),
      DailyStudyData(day: 'Thu', hours: 7.2, date: DateTime.now().subtract(Duration(days: 10))),
      DailyStudyData(day: 'Fri', hours: 4.1, date: DateTime.now().subtract(Duration(days: 9))),
      DailyStudyData(day: 'Sat', hours: 0, date: DateTime.now().subtract(Duration(days: 8))),
      DailyStudyData(day: 'Sun', hours: 0, date: DateTime.now().subtract(Duration(days: 7))),
    ],
    'This Month':  List.generate(daysInMonth, (index) {
  final date = monthStart.add(Duration(days: index));
  // Get the abbreviated day of the week (e.g., "Mon", "Tue") from the date.
  final dayName = DateFormat('E').format(date);
  
  // Generate realistic study hours (more on weekdays, less on weekends)
  double hours;
  if (dayName == 'Sat' || dayName == 'Sun') {
    hours = (Random().nextDouble() * 4).roundToDouble(); // 0-4 hours on weekends
  } else {
    hours = (Random().nextDouble() * 8).roundToDouble(); // 0-8 hours on weekdays
  }
  
  return DailyStudyData(
    day: dayName,
    hours: hours,
    date: date,
  );
}),
    'Custom': [],
  };

  class DailyStudyData {
  final String day;
  final double hours;
  final DateTime date;

  DailyStudyData({required this.day, required this.hours, required this.date});
}