// import 'package:flutter/material.dart';
// import 'dart:ui';

abstract class StudentFeatureEvent {}

class SubmitEnrollmentFormEvent extends StudentFeatureEvent {
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

  SubmitEnrollmentFormEvent({
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

class FetchGroupStudentsEvent extends StudentFeatureEvent {
  final String id;
  FetchGroupStudentsEvent({required this.id});
}

class FetchGroupNamesEvent extends StudentFeatureEvent {}

class CheckPermissionEvent extends StudentFeatureEvent {}

class RequestPermissionEvent extends StudentFeatureEvent {}

class CreateGeofenceEvent extends StudentFeatureEvent {}

class ReCreateGeofenceEvent extends StudentFeatureEvent {}

class GetStudentSideFeeEvent extends StudentFeatureEvent {
  final String studentId;

  GetStudentSideFeeEvent({required this.studentId});
}

class SignOutEvent extends StudentFeatureEvent {}
