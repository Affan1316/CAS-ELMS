// import 'package:flutter/material.dart';
// import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/bloc/student_enrollment_event.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/bloc/student_enrollment_state.dart';

class StudentEnrollmentBloc
    extends Bloc<StudentEnrollmentEvent, StudentEnrollmentState> {
  StudentEnrollmentBloc() : super(StudentEnrollmentInitial()) {
    on<SubmitEnrollmentFormEvent>(_handleEnrollmentSubmission);
  }

  Future<void> _handleEnrollmentSubmission(
    SubmitEnrollmentFormEvent event,
    Emitter<StudentEnrollmentState> emit,
  ) async {
    emit(StudentEnrollmentSubmitting());
    await Future.delayed(const Duration(seconds: 5));
    print(event.address);
    print(event.cnic);
    if (event.name.isEmpty) {
      emit(StudentEnrollmentFailure("Student name can't be empty"));
    } else {
      emit(StudentEnrollmentSuccess());
    }

    await Future.delayed(const Duration(seconds: 5));
    emit(StudentEnrollmentInitial());
  }
}
