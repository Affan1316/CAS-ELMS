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
