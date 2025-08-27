// import 'package:flutter/material.dart';
// import 'dart:ui';

import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/data/actual_implementation_firebase_repo.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/domain/firestore_repositry.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/domain/student_usecase.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/bloc/student_enrollment_event.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/bloc/student_enrollment_state.dart';

class StudentEnrollmentBloc
    extends Bloc<StudentEnrollmentEvent, StudentEnrollmentState> {
  StudentEnrollmentBloc() : super(StudentEnrollmentInitial()) {
    on<SubmitEnrollmentFormEvent>(_handleEnrollmentSubmission);
  }
  final FirestoreRepositry firestoreRepositry =
      ActualImplementationFirebaseRepo();

  Future<void> _handleEnrollmentSubmission(
    SubmitEnrollmentFormEvent event,
    Emitter<StudentEnrollmentState> emit,
  ) async {
    emit(StudentEnrollmentSubmitting());

    try {
      final StudentUsecase studentUsecase = StudentUsecase(firestoreRepositry);
      await studentUsecase.provideStudentData(event); // returns void (null)

      emit(StudentEnrollmentSuccess());
    } catch (e) {
      emit(StudentEnrollmentFailure(e.toString()));
    }
    // final StudentUsecase studentUsecase = StudentUsecase(firestoreRepositry);
    // var result = await studentUsecase.provideStudentData(event);
    // if (result is Void) {
    //   print("successfully entred");
    //   StudentEnrollmentSuccess();
    // } else {
    //   StudentEnrollmentFailure(result as String);
    // }
    // await Future.delayed(const Duration(seconds: 5));
    // print(event.address);
    // print(event.cnic);
    // if (event.name.isEmpty) {
    //   emit(StudentEnrollmentFailure("Student name can't be empty"));
    // } else {
    //   emit(StudentEnrollmentSuccess());
    // }

    // await Future.delayed(const Duration(seconds: 5));
    emit(StudentEnrollmentInitial());
  }
}
