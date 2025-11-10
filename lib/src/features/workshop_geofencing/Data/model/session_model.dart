// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:hive/hive.dart';

part 'session_model.g.dart';

@HiveType(typeId: 0)
class Sessions {
  @HiveField(0)
  DateTime checkInTime;
  @HiveField(1)
  DateTime checkOutTime;
  @HiveField(2)
  String? timeSpend;
  Sessions({
    required this.checkInTime,
    required this.checkOutTime,
    required this.timeSpend,
  });

  Sessions copyWith({
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? timeSpend,
  }) {
    return Sessions(
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      timeSpend: timeSpend  ?? this.timeSpend,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'checkInTime': checkInTime.millisecondsSinceEpoch,
      'checkOutTime': checkOutTime.millisecondsSinceEpoch,
      'timeSpend': timeSpend,
    };
  }

  factory Sessions.fromMap(Map<String, dynamic> map) {
    return Sessions(
      checkInTime: DateTime.fromMillisecondsSinceEpoch(
        map['checkInTime'] as int,
      ),
      checkOutTime: DateTime.fromMillisecondsSinceEpoch(
        map['checkOutTime'] as int,
      ),
      timeSpend: map['timeSpend'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sessions.fromJson(String source) =>
      Sessions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Sessions(checkInTime: $checkInTime, checkOutTime: $checkOutTime, timeSpend: $timeSpend)';

  @override
  bool operator ==(covariant Sessions other) {
    if (identical(this, other)) return true;

    return other.checkInTime == checkInTime &&
        other.checkOutTime == checkOutTime &&
        other.timeSpend == timeSpend;
  }

  @override
  int get hashCode =>
      checkInTime.hashCode ^ checkOutTime.hashCode ^ timeSpend.hashCode;
}
