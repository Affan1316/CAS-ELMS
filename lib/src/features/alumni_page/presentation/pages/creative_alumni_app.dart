// import 'package:flutter/material.dart';
// import 'package:flutter_cas_app_main/src/core/routing/app_router.dart';
// import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/pages/alumni_showcase_page.dart';
// import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/pages/year_selector_page.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// // import 'package:project_cas/courses_detail_page/presentation/pages/alumni_showcase_page.dart';
// // import 'package:project_cas/courses_detail_page/presentation/pages/year_selector_page.dart';

// class CreativeAlumniApp extends StatelessWidget {
//   CreativeAlumniApp({super.key});
//   final GoRouter _router = goRouter;
//   //   GoRouter(
//   //   routes: [
//   //     GoRoute(path: '/', builder: (context, state) => const YearSelectorPage()),
//   //     GoRoute(
//   //       path: '/alumni/:year',
//   //       pageBuilder: (context, state) {
//   //         final year = state.pathParameters['year']!;
//   //         return CustomTransitionPage(
//   //           transitionDuration: const Duration(milliseconds: 700),
//   //           child: AlumniShowcasePage(selectedYear: year),
//   //           transitionsBuilder: (context, animation, _, child) =>
//   //               FadeTransition(opacity: animation, child: child),
//   //         );
//   //       },
//   //     ),
//   //   ],
//   // );
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light().copyWith(
//         scaffoldBackgroundColor: const Color(0xFFEFF1F5),
//         textTheme: GoogleFonts.poppinsTextTheme(),
//       ),
//       routerConfig: _router,
//     );
//   }
// }
