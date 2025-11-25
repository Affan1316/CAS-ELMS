// import 'package:flutter/material.dart';
// import 'dart:ui';

import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/FeeAdminReadInstalmentUsecase.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/actual_implementation_firebase_repo.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/cached_data.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/add_student_use_case.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/read_student_use_case.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';
import 'package:geolocator/geolocator.dart';

import '../../../workshop_geofencing/Data/services/geofence_sevice.dart';
import '../../../workshop_geofencing/Data/services/permission_service.dart';
import '../../../workshop_geofencing/Data/services/work_manager_service.dart';
import '../../../workshop_geofencing/Domain/repository/shared_preference_repository.dart';

class StudentFeatureBloc
    extends Bloc<StudentFeatureEvent, StudentFeatureState> {
  MyGeofenceService geofenceService = MyGeofenceService();
  PermissionService permissionService = PermissionService();
  SharePreferenceRepository sharePreferenceRepository =
      SharePreferenceRepository();

  bool isLocationPermissionGranted = false;
  bool isNotificationPermissionGranted = false;
  bool isLocationAlwaysPermissionGranted = false;

  StudentFeatureBloc() : super(StudentEnrollmentInitial()) {
    on<SubmitEnrollmentFormEvent>(_handleEnrollmentSubmission);
    on<FetchGroupStudentsEvent>(_handleGroupDataLoading);
    on<FetchGroupNamesEvent>(_handleGroupNamesLoading);
    on<CheckPermissionEvent>(onCheckPermissionEvent);
    on<RequestPermissionEvent>(onRequestPermissionEvent);

    on<CreateGeofenceEvent>(onCreateGeofenceEvent);
    on<ReCreateGeofenceEvent>(onReCreateGeofenceEvent);
    on<GetStudentSideFeeEvent>(_handleGettingFee);
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

  Future<void> _handleGroupNamesLoading(
    FetchGroupNamesEvent event,
    Emitter<StudentFeatureState> emit,
  ) async {
    emit(GroupNamesfetching());
    var groupsNamesList = await _firestoreRepositry.getGroupsNames();
    emit(GroupNamesfetchingCompleted(listOfGroupNames: groupsNamesList));
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///

  FutureOr<void> onCheckPermissionEvent(
    CheckPermissionEvent event,
    Emitter<StudentFeatureState> emit,
  ) async {
    var notificationPermission =
        await permissionService.hasNotificationPermission();
    var locationPermission = await permissionService.hasLocationPermission();
    var locationAlwaysPermission =
        await permissionService.hasLocationAlwaysPermission();
    WorkManagerService.registerPeriodicLocationCheckAndReCreateFenceOnce();
    if (notificationPermission &&
        locationPermission &&
        locationAlwaysPermission) {
      add(CreateGeofenceEvent());
    } else {
      add(RequestPermissionEvent());
    }
  }

  FutureOr<void> onRequestPermissionEvent(
    RequestPermissionEvent event,
    Emitter<StudentFeatureState> emit,
  ) async {
    await permissionService.handleAllPermissions();
    add(CheckPermissionEvent());
  }

  FutureOr<void> onCreateGeofenceEvent(
    CreateGeofenceEvent event,
    Emitter<StudentFeatureState> emit,
  ) async {
    debugPrint("On Create Geofence Event");
    isLocationAlwaysPermissionGranted =
        await permissionService.hasLocationAlwaysPermission();
    isLocationPermissionGranted =
        await permissionService.hasLocationPermission();

    if (isLocationPermissionGranted && isLocationAlwaysPermissionGranted) {
      try {
        if (!await sharePreferenceRepository.getIsCreated()) {
          await geofenceService.createGeofence();

          await sharePreferenceRepository.setIsCreated(true);
          // log(isFencesCreated.toString(), name: "isFencesCreated");
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      //To Trigger Geofence event Quicker
      await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
      );
    } else {
      add(RequestPermissionEvent());
    }
  }

  FutureOr<void> onReCreateGeofenceEvent(
    ReCreateGeofenceEvent event,
    Emitter<StudentFeatureState> emit,
  ) async {
    isLocationAlwaysPermissionGranted =
        await permissionService.hasLocationAlwaysPermission();
    isLocationPermissionGranted =
        await permissionService.hasLocationPermission();

    if (isLocationPermissionGranted && isLocationAlwaysPermissionGranted) {
      await geofenceService.reCreatefence();
      await sharePreferenceRepository.setIsCreated(true);

      //To Trigger Geofence event Quicker
      await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
      );
    } else {
      add(RequestPermissionEvent());
    }
  }

  FutureOr<void> _handleGettingFee(
    GetStudentSideFeeEvent event,
    Emitter<StudentFeatureState> emit,
  ) async {
    emit(StudentSideFeeLoadingState());
    final Feeadminreadinstalmentusecase feeadminreadinstalmentusecase =
        Feeadminreadinstalmentusecase();
    await feeadminreadinstalmentusecase.getStudent(event.studentId);
    debugPrint(
      "<<<<<<<<Inside Block and intiating StudentLoadingState>>>>>>>>>> ",
    );

    try {
      debugPrint("student id which reult in no document ${event.studentId}");
      final student = await feeadminreadinstalmentusecase.getStudent(
        event.studentId,
      );

      if (student != null) {
        emit(StudentFeeLoadedState(student: student));
      } else {
        emit(StudentFeeLoadFailureState(error: "Student not found"));
      }
    } catch (e) {
      emit(StudentFeeLoadFailureState(error: e.toString()));
    }
  }
}
