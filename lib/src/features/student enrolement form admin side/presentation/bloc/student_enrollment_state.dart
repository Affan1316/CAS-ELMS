// import 'package:flutter/material.dart';
// import 'dart:ui';

abstract class StudentEnrollmentState {}

class StudentEnrollmentInitial extends StudentEnrollmentState {}

class StudentEnrollmentSubmitting extends StudentEnrollmentState {}

class StudentEnrollmentSuccess extends StudentEnrollmentState {}

class StudentEnrollmentFailure extends StudentEnrollmentState {
  final String error;
  StudentEnrollmentFailure(this.error);
}
