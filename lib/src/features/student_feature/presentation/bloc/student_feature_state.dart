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


class StudentGroupUpdating extends StudentFeatureState {}

class StudentGroupUpdateSuccess extends StudentFeatureState {
  final String studentId;
  final String newGroupName;

  StudentGroupUpdateSuccess({
    required this.studentId,
    required this.newGroupName,
  });
}

class StudentGroupUpdateFailure extends StudentFeatureState {
  final String error;
  StudentGroupUpdateFailure(this.error);
}


// / ← NEW STATES ADDED for full student update
class StudentDataUpdating extends StudentFeatureState {}

class StudentDataUpdateSuccess extends StudentFeatureState {}

class StudentDataUpdateFailure extends StudentFeatureState {
  final String error;
  StudentDataUpdateFailure(this.error);
}


// ← NEW STATES ADDED for deleting student
class StudentDeleting extends StudentFeatureState {}

class StudentDeleteSuccess extends StudentFeatureState {
  final String studentId;
  
  StudentDeleteSuccess({required this.studentId});
}

class StudentDeleteFailure extends StudentFeatureState {
  final String error;
  StudentDeleteFailure(this.error);
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
