// import 'package:flutter/material.dart';
// import 'dart:ui';

abstract class StudentEnrollmentEvent {}

class SubmitEnrollmentFormEvent extends StudentEnrollmentEvent {
  final String id, name, email, cnic, phone, address, gender;

  SubmitEnrollmentFormEvent({
    required this.id,
    required this.name,
    required this.email,
    required this.cnic,
    required this.phone,
    required this.address,
    required this.gender,
  });
}
