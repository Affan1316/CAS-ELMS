import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/firebase_options.dart';
import 'package:flutter_cas_app_main/src/core/dependencies/injections.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_theme.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/bloc/chat_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/presentation/bloc/add_course_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/pages/admin_home_page.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/local_fee_service.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/bloc/fee_history_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/bloc/fee_history_event.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/page/fee_history_screen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/groups_list_screen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/groups_loading_screen.dart';
import 'package:flutter_cas_app_main/src/features/group/data/repositories/group_repository_implementation.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/add_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/update_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/bloc/group_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/bloc/inquiry_bloc.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/bloc/installment_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/installment_service.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter_cas_app_main/src/features/pay_fee/presentation/pages/group_detail_page.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';
// import 'package:flutter_cas_app_main/src/features/course_catalog/presentation/pages/course_catalog_screen_state.dart';

// void main() {
//   runApp(const MyApp());
// }

// add that
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
          BlocProvider<AdminHomeBloc>(create: (context) => AdminHomeBloc()),
          BlocProvider<StudentFeatureBloc>(
            create: (context) => StudentFeatureBloc(),
          ),
          BlocProvider<InquiryBloc>(create: (context) => sl<InquiryBloc>()),
          BlocProvider<AddCourseBloc>(create: (context) => sl<AddCourseBloc>()),
          BlocProvider<InstallmentPageBloc>(
            create:
                (context) => InstallmentPageBloc(
                  installmentService: InstallmentService(),
                ),
          ),

          BlocProvider<AddInstructorBloc>(
            create: (context) => AddInstructorBloc(),
          ),
          BlocProvider<AdminLoginBloc>(create: (context) => AdminLoginBloc()),
          BlocProvider<FeeHistoryBloc>(
            create:
                (context) => FeeHistoryBloc(LocalFeeService())..add(LoadFees()),
            child: FeeHistoryScreen(),
          ),
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
          BlocProvider(create: (context) => FeeAdminBloc()),
        ],
        child: MaterialApp(
          title: 'CAS ELMS',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: AdminHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return OnboardingScreen();
  }
}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fee Management System',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//         useMaterial3: true,
//       ),
//       home: const GroupsLoadingScreen(),
//     );
//   }
// }
