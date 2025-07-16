import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_theme.dart';
<<<<<<< HEAD
import 'package:flutter_cas_app_main/src/features/course_catalog/presentation/pages/__course_catalog_screen_state.dart';
=======
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
>>>>>>> 01d65bc471f94e1a622bf413bc2487cb0027858f
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/elms_landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnboardingBloc>(create: (context) => OnboardingBloc()),
      ],
      child: MaterialApp(
        title: 'CAS ELMS',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MyHomePage(),
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
    return CourseCatalogScreen();
  }
}
