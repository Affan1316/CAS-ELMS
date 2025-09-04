// import 'package:flutter/material.dart';
// import 'dart:ui';

abstract class StudentFeatureState {}

class StudentEnrollmentInitial extends StudentFeatureState {}

class StudentEnrollmentSubmitting extends StudentFeatureState {}

class StudentEnrollmentSuccess extends StudentFeatureState {}

class StudentEnrollmentFailure extends StudentFeatureState {
  final String error;
  StudentEnrollmentFailure(this.error);
}

class GroupStudentsDatafetching extends StudentFeatureState {}

class GroupStudentsDatafetched extends StudentFeatureState {
  final String id,
      name,
      email,
      cnic,
      phone,
      address,
      gender,
      fatherName,
      fatherOccupation,
      group;

  GroupStudentsDatafetched({
    required this.id,
    required this.name,
    required this.email,
    required this.cnic,
    required this.phone,
    required this.address,
    required this.gender,
    required this.fatherName,
    required this.fatherOccupation,
    required this.group,
  });
}
