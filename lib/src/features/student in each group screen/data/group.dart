// import 'package:flutter/material.dart';
// import 'dart:ui';

class Group {
  final String title;
  final String course;
  final String instructor;
  final double fee;
  final String startTime;
  final String endTime;

  const Group({
    required this.title,
    required this.course,
    required this.instructor,
    required this.fee,
    required this.startTime,
    required this.endTime,
  });

  Group copyWith({
    String? title,
    String? course,
    String? instructor,
    double? fee,
    String? startTime,
    String? endTime,
  }) {
    return Group(
      title: title ?? this.title,
      course: course ?? this.course,
      instructor: instructor ?? this.instructor,
      fee: fee ?? this.fee,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
