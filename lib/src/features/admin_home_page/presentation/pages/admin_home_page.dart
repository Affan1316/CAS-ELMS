import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_event.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_state.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/widgets/buildAdminCarouselSlider.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/widgets/buildAdminHeader.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/widgets/buildAdminOverviewSection.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/widgets/buildAdminTitleSection.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;
  // int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _pageController = PageController();
    _animationController.forward();
    context.read<AdminHomeBloc>().add(LoadPendingLeavesEvent());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            buildAdminHeader(),
            buildAdminTitleSection(),
            SizedBox(height: 24),
            buildAdminCarouselSlider(_pageController),
            SizedBox(height: 32),
            buildAdminOverviewSection(),
            SizedBox(height: 24),
            BlocBuilder<AdminHomeBloc, AdminHomeState>(
              builder: (context, state) {
                return buildFeaturesGrid(
                  _animationController,
                  pendingLeaveCount: state.pendingLeavesCount,
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
