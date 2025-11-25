
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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

import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';

import 'package:flutter_cas_app_main/src/features/group/data/repositories/group_repository_implementation.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/add_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/update_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/bloc/group_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/bloc/inquiry_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/bloc/leave_bloc.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/pages/assignments_detail_page.dart';
import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/pages/assignments_list_page.dart';

import 'package:flutter_cas_app_main/src/features/student_feature/domain/get_groups_names_usecase.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_home_page.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/data_source/SuperAdminFeeRepositoryImpl.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/confirm_super_admin_fee_payment_use_case.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/fetch_group_fee_history_usecase.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/get_groups_names_super_admin_usecase.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/usecases/get_super_admin_fee_notifications_usecase.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';

import 'package:responsive_ui_kit/responsive_ui_kit.dart';

import 'src/features/my_student_attendence/presentation/bloc/student_attendence_bloc_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/course_catalog/presentation/pages/course_catalog_screen_state.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await init();

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
          BlocProvider<LeaveBloc>(create: (context) => sl<LeaveBloc>()),
          BlocProvider<AdminHomeBloc>(
            create: (context) => AdminHomeBloc(context.read<LeaveBloc>()),
          ),
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
                  fetchGroupFeeHistoryUsecase: FetchGroupFeeHistoryUsecase(
                    repo: SuperAdminFeeRepositoryImpl(
                      FirebaseFirestore.instance,
                    ),
                  ),
                  getGroupsNamesSuperAdminUsecase:
                      GetGroupsNamesSuperAdminUsecase(
                        orignalUsecase: GetGroupsNamesUsecase(),
                      ),
                ),
          ),
          BlocProvider(create: (context) => FeeAdminBloc()),
          BlocProvider(create: (context) => StudentAttendenceBloc()),
        ],
        child: MaterialApp(
          title: 'CAS ELMS',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: OnboardingScreen(),
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
  const SplashScreen({super.key});

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
        builder: (context) => const OnboardingScreen(),
        // ⚠️ Replace with your screen
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
