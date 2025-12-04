// import 'package:flutter/material.dart';
// import 'dart:ui';

import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';

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

class GroupNamesfetching extends StudentFeatureState {}

class GroupNamesfetchingCompleted extends StudentFeatureState {
  final List<String> listOfGroupNames;
  GroupNamesfetchingCompleted({required this.listOfGroupNames});
}

class StudentSideFeeLoadingState extends StudentFeatureState {}

class StudentFeeLoadFailureState extends StudentFeatureState {
  final String error;

  StudentFeeLoadFailureState({required this.error});
}

class StudentFeeLoadedState extends StudentFeatureState {
  final StudentFeeFeatureEntityClass student;

  StudentFeeLoadedState({required this.student});
}

class StudentSigInOutState extends StudentFeatureState {}
