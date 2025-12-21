import 'package:animate_do/animate_do.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Keep your existing imports
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/pages/OnboardingScreen.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/StudentDetailPage.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/webview_screen.dart';
import '../../domain/webview_page_type.dart';
import '../widgets/logOut_dialog.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';

class StudentProfilePage extends StatefulWidget {
  final String id;

  const StudentProfilePage({super.key, required this.id});

  @override
  StudentProfilePageState createState() => StudentProfilePageState();
}

class StudentProfilePageState extends State<StudentProfilePage> {
  // Matches the AssignmentsListPage background
  final Color _backgroundColor = const Color(0xFFE2E2E2);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Responsive calculations
    final bool isTablet = size.width > 600;
    final double horizontalPadding = size.width * 0.05;
    final double titleFontSize = size.width * (isTablet ? 0.05 : 0.07);
    final double iconSize = size.width * (isTablet ? 0.05 : 0.065);
    final double backButtonPadding = size.width * 0.04;

    return BlocListener<StudentFeatureBloc, StudentFeatureState>(
      bloc: context.read<StudentFeatureBloc>(),
      listener: (context, state) {
        if (state is StudentSigInOutState) {
          context.read<OnboardingBloc>().add(ResetOnboardingEvent());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
            (route) => false,
          );
        } else if (state is GroupStudentsDatafetched) {
          // Navigate to details when data is fetched
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => StudentDetailPage(
                    student: StudentEntityClass(
                      id: state.id,
                      name: state.name,
                      email: state.email,
                      cnic: state.cnic,
                      phone: state.phone,
                      address: state.address,
                      gender: state.gender,
                      fatherName: state.fatherName,
                      fatherOccupation: state.fatherOccupation,
                      group: state.group,
                    ),
                  ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            physics: const BouncingScrollPhysics(),
            children: [
              SizedBox(height: size.height * 0.02),

              // 1. Header (Consistent with Assignments Page)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    child: NeumorphicButton(
                      onPressed: () => Navigator.pop(context),
                      style: NeumorphicStyle(
                        boxShape: const NeumorphicBoxShape.circle(),
                        depth: 6,
                        intensity: 0.8,
                        color: _backgroundColor,
                      ),
                      padding: EdgeInsets.all(backButtonPadding),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: iconSize,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.03),

              // 2. Title Section (Consistent Typography)
              FadeInDown(
                delay: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.01,
                          height: titleFontSize * 0.65,
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Account',
                          style: TextStyle(
                            fontSize: titleFontSize * 0.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                          ).createShader(bounds),
                      child: Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: titleFontSize * 1.1,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.04),

              // SizedBox(height: size.height * 0.04),

              // 4. Menu Items
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Column(
                  children: [
                    _buildNeumorphicMenuItem(
                      context,
                      icon: Icons.person_outline_rounded,
                      title: 'User Details',
                      onTap: () {
                        context.read<StudentFeatureBloc>().add(
                          FetchGroupStudentsEvent(id: widget.id),
                        );
                      },
                    ),
                    _buildNeumorphicMenuItem(
                      context,
                      icon: Icons.shield_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const WebViewScreen(
                                  pageType: WebViewPageType.privacyPolicy,
                                ),
                          ),
                        );
                      },
                    ),
                    _buildNeumorphicMenuItem(
                      context,
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const WebViewScreen(
                                  pageType: WebViewPageType.termsAndConditions,
                                ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    _buildNeumorphicMenuItem(
                      context,
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      isLogout: true,
                      onTap: () async {
                        showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: NeumorphicButton(
        onPressed: onTap,
        style: NeumorphicStyle(
          depth: 4,
          intensity: 0.8,
          surfaceIntensity: 0.5,
          color: _backgroundColor,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red.shade400 : AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isLogout ? Colors.red.shade400 : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}
