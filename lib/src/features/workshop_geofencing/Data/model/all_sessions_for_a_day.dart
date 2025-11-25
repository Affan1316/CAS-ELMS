// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Data/model/session_model.dart';

part 'all_sessions_for_a_day.g.dart';

@HiveType(typeId: 1)
class AllSessionsForADay {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  List<Sessions> sessions;
  @HiveField(2)
  String totalDuration;

  AllSessionsForADay({
    required this.date,
    required this.sessions,
    required this.totalDuration,
  });

  AllSessionsForADay copyWith({
    DateTime? date,
    List<Sessions>? sessions,
    String? totalDuration,
  }) {
    return AllSessionsForADay(
      date: date ?? this.date,
      sessions: sessions ?? this.sessions,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'sessions': sessions.map((x) => x.toMap()).toList(),
      'totalDuration': totalDuration,
    };
  }

  factory AllSessionsForADay.fromMap(Map<String, dynamic> map) {
    return AllSessionsForADay(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      sessions: List<Sessions>.from(
        (map['sessions'] as List<int>).map<Sessions>(
          (x) => Sessions.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalDuration: map['totalDuration'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AllSessionsForADay.fromJson(String source) =>
      AllSessionsForADay.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AllSessionsForADay(date: $date, sessions: $sessions, totalDuration: $totalDuration)';

  @override
  bool operator ==(covariant AllSessionsForADay other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        listEquals(other.sessions, sessions) &&
        other.totalDuration == totalDuration;
  }

  @override
  int get hashCode =>
      date.hashCode ^ sessions.hashCode ^ totalDuration.hashCode;
}
