import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/firebase_options.dart';
import 'package:flutter_cas_app_main/src/auth/data/service/AuthService.dart';
import 'package:flutter_cas_app_main/src/core/dependencies/injections.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_theme.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/bloc/chat_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/presentation/bloc/add_course_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';

import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_history_screen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/data/datasource/geofence_service_impl.dart';
import 'package:flutter_cas_app_main/src/features/group/data/repositories/group_repository_implementation.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/add_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/update_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/bloc/group_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/bloc/inquiry_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/data/datasource/attendance_remote_datasource.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/data/repositories/attendance_repository_impl.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/domain/usecases/get_attendance_usecase.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/presentation/bloc/student_attendance_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/presentation/infrastructure/background/background_fetch_handler.dart'
    hide callbackDispatcher;
import 'package:flutter_cas_app_main/src/features/student_attendance/presentation/pages/student_attendance_page.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/SuperAdminFeeRepositoryImpl.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/confirm_super_admin_fee_payment_use_case.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/get_super_admin_fee_notifications_usecase.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';
import 'package:geofence_foreground_service/geofence_foreground_service.dart';
import 'package:geofence_foreground_service/models/notification_icon_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';
import 'package:workmanager/workmanager.dart';
// import 'package:flutter_cas_app_main/src/features/course_catalog/presentation/pages/course_catalog_screen_state.dart';

// void main() {
//   runApp(const MyApp());
// }

// add that
Future<bool> ensureLocationAlwaysOn() async {
  Location location = Location();
  bool serviceEnabled = await location.serviceEnabled();

  // Keep looping until location is turned ON
  while (!serviceEnabled) {
    serviceEnabled = await location.requestService();

    // Wait a bit before checking again
    await Future.delayed(const Duration(seconds: 2));
  }
  return serviceEnabled;
}

Future<bool> requestPermission() async {
  PermissionStatus locationStatus = await Permission.location.request();
  PermissionStatus alwaysStatus = await Permission.locationAlways.request();

  // Keep requesting until granted
  while (!locationStatus.isGranted || !alwaysStatus.isGranted) {
    locationStatus = await Permission.location.request();
    alwaysStatus = await Permission.locationAlways.request();
  }

  return true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await init();
  // Register background headless task

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await Workmanager().initialize(
      callbackDispatcher, // 👈 background callback
    );
  }

  final now = DateTime.now();
  final nextMidnight = DateTime(now.year, now.month, now.day + 1);
  final delay = nextMidnight.difference(now);
  //Register a periodic background task (runs daily)
  await Workmanager().registerPeriodicTask(
    "dailyAttendanceCheck",
    "dailyAttendanceCheck",
    frequency: const Duration(hours: 24), // every 24 hours
    initialDelay: delay, // wait before first run
    constraints: Constraints(
      networkType: NetworkType.connected, // only run when online
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OnboardingBloc>(create: (context) => OnboardingBloc()),
          BlocProvider<ChatPageBloc>(create: (context) => ChatPageBloc()),
          BlocProvider<AdminHomeBloc>(create: (context) => AdminHomeBloc()),
          BlocProvider<StudentFeatureBloc>(
            create: (context) => StudentFeatureBloc(),
          ),
          BlocProvider<InquiryBloc>(create: (context) => sl<InquiryBloc>()),
          BlocProvider<AddCourseBloc>(create: (context) => sl<AddCourseBloc>()),

          // BlocProvider<InstallmentPageBloc>(
          //   create:
          //       (context) => InstallmentPageBloc(
          //         installmentService: ActualImplemetationInstallmentRepo(),
          //       ),
          // ),
          BlocProvider<AddInstructorBloc>(
            create: (context) => AddInstructorBloc(),
          ),
          BlocProvider<AdminLoginBloc>(create: (context) => AdminLoginBloc()),
          // BlocProvider<FeeHistoryBloc>(
          //   create:
          //       (context) => FeeHistoryBloc(LocalFeeService())..add(LoadFees()),
          //   // child: FeeHistoryScreen(),
          // ),
          BlocProvider<AddGroupBloc>(
            create:
                (context) => AddGroupBloc(
                  addGroupUsecase: AddGroupUsecase(
                    abstractGroupRepository: GroupRepositoryImplementation(),
                  ),
                  updateGroupUsecase: UpdateGroupUsecase(
                    abstractGroupRepository: GroupRepositoryImplementation(),
                  ),
                ),
          ),
          BlocProvider(
            create:
                (context) => SuperAdminFeeBloc(
                  getNotifications: GetSuperAdminFeeNotificationsUsecase(
                    SuperAdminFeeRepositoryImpl(FirebaseFirestore.instance),
                  ),
                  confirmPayment: ConfirmSuperAdminFeePaymentUseCase(
                    SuperAdminFeeRepositoryImpl(FirebaseFirestore.instance),
                  ),
                ),
          ),
          BlocProvider(create: (context) => FeeAdminBloc()),
          BlocProvider(
            create:
                (context) => StudentAttendanceBloc(
                  getAttendance: GetAttendanceUsecase(
                    attendanceRepository: AttendanceRepositoryImpl(
                      abstractAttendanceRemoteDatasource:
                          AttendanceRemoteDatasource(
                            firestore: FirebaseFirestore.instance,
                          ),
                      firestore: FirebaseFirestore.instance,
                    ),
                  ),
                )..add(LoadAttendanceEvent(studentId: 'F17-02')),
          ),
        ],
        child: MaterialApp(
          title: 'CAS ELMS',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: SplashScreen(),
        ),
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return StudentAttendanceScreen();
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Wait a bit for splash effect (optional)
    await Future.delayed(const Duration(seconds: 1));

    final isLoggedIn = await _authService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // User is logged in - get student data and navigate to home
      final studentId = await _authService.getSavedStudentId();

      if (studentId != null) {
        // Trigger BLoC event to fetch student data
        context.read<OnboardingBloc>().add(
          ReadStudentNameFromFireBaseEvent(id: studentId),
        );
      } else {
        // No student ID found - go to login
        _navigateToOnboarding();
      }
    } else {
      // User is NOT logged in - go to onboarding/login
      _navigateToOnboarding();
    }
  }

  void _navigateToOnboarding() {
    // Replace with your actual onboarding screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) =>
                const OnboardingScreen(), // ⚠️ Replace with your screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) async {
        if (state is ReadingStudentNameCompleted) {
          final studentId = await _authService.getSavedStudentId();

          if (!mounted) return;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder:
                  (context) => StudentHomePage(
                    id: studentId!,
                    studentEntityClass: state.studentEntityClass,
                  ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF4DD0E1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your app logo
              Icon(Icons.school, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'ELMS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
