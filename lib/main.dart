import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_theme.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/bloc/chat_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/alumni_page/presentation/pages/year_selector_page.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/pages/onboarding_screen.dart';
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
    return YearSelectorPage();
  }
}
