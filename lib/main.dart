// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cas_app_main/firebase_options.dart';
// import 'package:flutter_cas_app_main/src/core/dependencies/injections.dart';
// import 'package:flutter_cas_app_main/src/core/theme/app_theme.dart';
// import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/bloc/chat_page_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/add_courses/presentation/bloc/add_course_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/pages/admin_home_page.dart';
// import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';

// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_history_screen.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/groups_list_screen.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/groups_loading_screen.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_defaulters.dart';
// import 'package:flutter_cas_app_main/src/features/group/data/repositories/group_repository_implementation.dart';
// import 'package:flutter_cas_app_main/src/features/group/domain/usecases/add_group_usecase.dart';
// import 'package:flutter_cas_app_main/src/features/group/domain/usecases/update_group_usecase.dart';
// import 'package:flutter_cas_app_main/src/features/group/presentation/bloc/group_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/inquiry/presentation/bloc/inquiry_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
// import 'package:flutter_cas_app_main/src/features/onboarding/presentation/pages/onboarding_screen.dart';
// import 'package:flutter_cas_app_main/src/features/pay_fee/presentation/pages/group_detail_page.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:responsive_ui_kit/responsive_ui_kit.dart';
// // import 'package:flutter_cas_app_main/src/features/course_catalog/presentation/pages/course_catalog_screen_state.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // add that
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveLayoutProvider(
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider<OnboardingBloc>(create: (context) => OnboardingBloc()),
//           BlocProvider<ChatPageBloc>(create: (context) => ChatPageBloc()),
//           BlocProvider<AdminHomeBloc>(create: (context) => AdminHomeBloc()),
//           BlocProvider<StudentFeatureBloc>(
//             create: (context) => StudentFeatureBloc(),
//           ),
//           BlocProvider<InquiryBloc>(create: (context) => sl<InquiryBloc>()),
//           BlocProvider<AddCourseBloc>(create: (context) => sl<AddCourseBloc>()),

//           // BlocProvider<InstallmentPageBloc>(
//           //   create:
//           //       (context) => InstallmentPageBloc(
//           //         installmentService: ActualImplemetationInstallmentRepo(),
//           //       ),
//           // ),
//           BlocProvider<AddInstructorBloc>(
//             create: (context) => AddInstructorBloc(),
//           ),
//           BlocProvider<AdminLoginBloc>(create: (context) => AdminLoginBloc()),
//           // BlocProvider<FeeHistoryBloc>(
//           //   create:
//           //       (context) => FeeHistoryBloc(LocalFeeService())..add(LoadFees()),
//           //   child: FeeHistoryScreen(),
//           // ),
//           // BlocProvider(
//           //   create: (_) {
//           //     return FeeHistoryBloc(
//           //       repository: FeeHistoryRepository(
//           //         firestore: FirebaseFirestore.instance,
//           //       ),
//           //     ); // ✅ presentation layer
//           //   },
//           //   child: const FeeHistoryScreen(),
//           // ),
//           BlocProvider<AddGroupBloc>(
//             create:
//                 (context) => AddGroupBloc(
//                   addGroupUsecase: AddGroupUsecase(
//                     abstractGroupRepository: GroupRepositoryImplementation(),
//                   ),
//                   updateGroupUsecase: UpdateGroupUsecase(
//                     abstractGroupRepository: GroupRepositoryImplementation(),
//                   ),
//                 ),
//           ),
//           BlocProvider(create: (context) => FeeAdminBloc()),
//         ],
//         child: MaterialApp(
//           title: 'CAS ELMS',
//           theme: AppTheme.lightTheme,
//           darkTheme: AppTheme.darkTheme,
//           themeMode: ThemeMode.system,
//           home: AdminHomePage(),
//         ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return OnboardingScreen();
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationsScreen(),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, String>> notifications = const [
    {"id": "1", "name": "Safi Ur Rehman", "group": "Ai 2 group"},
    {"id": "2", "name": "Sajjad Hussain", "group": "Ai 2 group"},
    {"id": "2", "name": "Arhum Nadeem", "group": "A24"},
    {"id": "6", "name": "Syed Awais Bukhari", "group": "F20"},
    {"id": "8", "name": "Ameer Hamza", "group": "A23"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E5EC),
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _TopTab(icon: Icons.install_mobile, label: "Installment"),
                _TopTab(icon: Icons.no_accounts, label: "Leave"),
                _TopTab(icon: Icons.bar_chart, label: "Concession"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E5EC),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: const Offset(-5, -5),
                          blurRadius: 10,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(5, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E5EC),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              offset: const Offset(-3, -3),
                              blurRadius: 6,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(3, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          item["id"]!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        item["name"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        item["group"]!,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E5EC),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              offset: const Offset(-3, -3),
                              blurRadius: 6,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(3, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TopTab({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-3, -3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
