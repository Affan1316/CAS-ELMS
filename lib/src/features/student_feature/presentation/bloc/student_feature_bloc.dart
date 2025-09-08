// import 'package:flutter/material.dart';
// import 'dart:ui';

import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/actual_implementation_firebase_repo.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/cached_data.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/add_student_use_case.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/read_student_use_case.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';

class StudentFeatureBloc
    extends Bloc<StudentFeatureEvent, StudentFeatureState> {
  StudentFeatureBloc() : super(StudentEnrollmentInitial()) {
    on<SubmitEnrollmentFormEvent>(_handleEnrollmentSubmission);
    on<FetchGroupStudentsEvent>(_handleGroupDataLoading);
  }
  final FirestoreRepositry _firestoreRepositry =
      ActualImplementationFirebaseRepo();

  Future<void> _handleEnrollmentSubmission(
    SubmitEnrollmentFormEvent event,
    Emitter<StudentFeatureState> emit,
  ) async {
    emit(StudentEnrollmentSubmitting());
    final AddStudentUseCase studentUsecase = AddStudentUseCase(
      _firestoreRepositry,
    );

    try {
      await studentUsecase.provideStudentData(event); // returns void (null)
    } catch (e) {
      emit(StudentEnrollmentFailure(e.toString()));
    }
    try {
      await studentUsecase.provideStudentData(event);
      emit(StudentEnrollmentSuccess());
    } catch (e) {
      print(e);
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

  Future<void> _handleGroupDataLoading(
    FetchGroupStudentsEvent event,
    Emitter<StudentFeatureState> emit,
  ) async {
    print("43343434343434343starting process4433333434334343434");
    emit(GroupStudentsDatafetching());
    StudentEntityClass studentData;
    if (CachedData.listOfAlreadyFetchedStudentsData.containsKey(event.id)) {
      studentData = CachedData.listOfAlreadyFetchedStudentsData[event.id]!;
      emit(
        GroupStudentsDatafetched(
          id: studentData.id,
          name: studentData.name,
          email: studentData.email,
          cnic: studentData.cnic,
          phone: studentData.phone,
          address: studentData.address,
          gender: studentData.gender,
          fatherName: studentData.fatherName,
          fatherOccupation: studentData.fatherOccupation,
          group: studentData.group,
        ),
      );
      return;
    }
    final ReadStudentUseCase readStudentUseCase = ReadStudentUseCase(
      firestoreRepositry: _firestoreRepositry,
    );
    studentData = await readStudentUseCase.readStudentDataUsingId(event.id);
    CachedData.listOfAlreadyFetchedStudentsData[event.id] = studentData;
    emit(
      GroupStudentsDatafetched(
        id: studentData.id,
        name: studentData.name,
        email: studentData.email,
        cnic: studentData.cnic,
        phone: studentData.phone,
        address: studentData.address,
        gender: studentData.gender,
        fatherName: studentData.fatherName,
        fatherOccupation: studentData.fatherOccupation,
        group: studentData.group,
      ),
    );
  }
}
