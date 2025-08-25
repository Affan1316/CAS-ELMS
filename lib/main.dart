import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_theme.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/bloc/chat_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/pages/chat_page.dart';
import 'package:flutter_cas_app_main/src/features/add_inquiry/presentation/pages/add_instructor_screen.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/pages/AddInstructorScreen.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/pages/admin_home_page.dart';
import 'package:flutter_cas_app_main/src/features/alumni_page/presentation/pages/year_selector_page.dart';
import 'package:flutter_cas_app_main/src/features/assignment_screen/presentation/pages/assignments_page.dart';

import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/course_graph_screen/presentation/pages/elms_graph_page.dart';
import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/pages/course_catalog.dart';
import 'package:flutter_cas_app_main/src/features/creategroup/presentation/pages/create_group_page.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/elms_landing_page.dart';
import 'package:flutter_cas_app_main/src/features/enrollstudent/presentation/pages/enroll_student_page.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/page/fee_history_screen.dart';
import 'package:flutter_cas_app_main/src/features/feedefaulters/presentation/pages/fee_defaulters.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/pages/inquiry_page.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/pages/installment_page.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter_cas_app_main/src/features/pay_fee/presentation/pages/groups_page.dart';
import 'package:flutter_cas_app_main/src/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_cas_app_main/src/features/request_leave/presentation/pages/history_leaves_page.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/bloc/student_enrollment_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/pages/student_enrollment_screen.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/widgets/student_enrollment_form.dart';
import 'package:flutter_cas_app_main/src/features/student%20in%20each%20group%20screen/presentation/widget/update_group_screen.dart';
import 'package:flutter_cas_app_main/src/features/student%20in%20each%20group%20screen/presentation/page/group_page.dart';
import 'package:flutter_cas_app_main/src/features/student_home_page/presentation/pages/student_home_page.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';
// import 'package:flutter_cas_app_main/src/features/course_catalog/presentation/pages/course_catalog_screen_state.dart';

void main() {
  runApp(const MyApp());
}

// add that
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OnboardingBloc>(create: (context) => OnboardingBloc()),
          BlocProvider<ChatPageBloc>(create: (context) => ChatPageBloc()),
          BlocProvider<StudentEnrollmentBloc>(
            create: (context) => StudentEnrollmentBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'CAS ELMS',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const MyHomePage(),
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
    return StudentEnrollmentScreen();
  }
}
