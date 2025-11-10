// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class WorkshoptimeModel {
  DateTime date;
  String duration;
  List<Map<String, dynamic>> sessions;
  
  WorkshoptimeModel({
    required this.date,
    required this.duration,
    required this.sessions,
  });
  

 

  WorkshoptimeModel copyWith({
    DateTime? date,
    String? duration,
    List<Map<String, dynamic>>? sessions,
  }) {
    return WorkshoptimeModel(
      date: date ?? this.date,
      duration: duration ?? this.duration,
      sessions: sessions ?? this.sessions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'duration': duration,
      'sessions': sessions,
    };
  }

  factory WorkshoptimeModel.fromMap(Map<String, dynamic> map) {
    return WorkshoptimeModel(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      duration: map['duration'] as String,
      sessions: (map['sessions'] as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkshoptimeModel.fromJson(String source) => WorkshoptimeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WorkshoptimeModel(date: $date, duration: $duration, sessions: $sessions)';

  @override
  bool operator ==(covariant WorkshoptimeModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.date == date &&
      other.duration == duration &&
      listEquals(other.sessions, sessions);
  }

  @override
  int get hashCode => date.hashCode ^ duration.hashCode ^ sessions.hashCode;
}




