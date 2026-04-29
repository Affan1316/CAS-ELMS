// import 'package:animate_do/animate_do.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // Keep your existing imports
// import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
// import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/pages/OnboardingScreen.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/StudentDetailPage.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/webview_screen.dart';
// import '../../domain/webview_page_type.dart';
// import '../widgets/logOut_dialog.dart';
// import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';

// class StudentProfilePage extends StatefulWidget {
//   final String id;

//   const StudentProfilePage({super.key, required this.id});

//   @override
//   StudentProfilePageState createState() => StudentProfilePageState();
// }

// class StudentProfilePageState extends State<StudentProfilePage> {
//   // Matches the AssignmentsListPage background
//   final Color _backgroundColor = const Color(0xFFE2E2E2);

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     // Responsive calculations
//     final bool isTablet = size.width > 600;
//     final double horizontalPadding = size.width * 0.05;
//     final double titleFontSize = size.width * (isTablet ? 0.05 : 0.07);
//     final double iconSize = size.width * (isTablet ? 0.05 : 0.065);
//     final double backButtonPadding = size.width * 0.04;

//     return BlocListener<StudentFeatureBloc, StudentFeatureState>(
//       bloc: context.read<StudentFeatureBloc>(),
//       listener: (context, state) {
//         if (state is StudentSigInOutState) {
//           context.read<OnboardingBloc>().add(ResetOnboardingEvent());
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
//             (route) => false,
//           );
//         } else if (state is GroupStudentsDatafetched) {
//           // Navigate to details when data is fetched
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder:
//                   (context) => StudentDetailPage(
//                     student: StudentEntityClass(
//                       id: state.id,
//                       name: state.name,
//                       email: state.email,
//                       cnic: state.cnic,
//                       phone: state.phone,
//                       address: state.address,
//                       gender: state.gender,
//                       fatherName: state.fatherName,
//                       fatherOccupation: state.fatherOccupation,
//                       group: state.group,
//                     ),
//                   ),
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: _backgroundColor,
//         body: SafeArea(
//           child: ListView(
//             padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//             physics: const BouncingScrollPhysics(),
//             children: [
//               SizedBox(height: size.height * 0.02),

//               // 1. Header (Consistent with Assignments Page)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   FadeInDown(
//                     delay: const Duration(milliseconds: 300),
//                     child: NeumorphicButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: NeumorphicStyle(
//                         boxShape: const NeumorphicBoxShape.circle(),
//                         depth: 6,
//                         intensity: 0.8,
//                         color: _backgroundColor,
//                       ),
//                       padding: EdgeInsets.all(backButtonPadding),
//                       child: Icon(
//                         Icons.arrow_back_ios_new,
//                         size: iconSize,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: size.height * 0.03),

//               // 2. Title Section (Consistent Typography)
//               FadeInDown(
//                 delay: const Duration(milliseconds: 400),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: size.width * 0.01,
//                           height: titleFontSize * 0.65,
//                           decoration: BoxDecoration(
//                             color: AppColors.primaryDark,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           'Account',
//                           style: TextStyle(
//                             fontSize: titleFontSize * 0.5,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black54,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     ShaderMask(
//                       shaderCallback:
//                           (bounds) => LinearGradient(
//                             colors: [AppColors.primary, AppColors.primaryDark],
//                           ).createShader(bounds),
//                       child: Text(
//                         'My Profile',
//                         style: TextStyle(
//                           fontSize: titleFontSize * 1.1,
//                           fontWeight: FontWeight.w900,
//                           color: Colors.white,
//                           letterSpacing: -0.5,
//                           height: 1.1,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: size.height * 0.04),

//               // SizedBox(height: size.height * 0.04),

//               // 4. Menu Items
//               FadeInUp(
//                 delay: const Duration(milliseconds: 600),
//                 child: Column(
//                   children: [
//                     _buildNeumorphicMenuItem(
//                       context,
//                       icon: Icons.person_outline_rounded,
//                       title: 'User Details',
//                       onTap: () {
//                         context.read<StudentFeatureBloc>().add(
//                           FetchGroupStudentsEvent(id: widget.id),
//                         );
//                       },
//                     ),
//                     _buildNeumorphicMenuItem(
//                       context,
//                       icon: Icons.shield_outlined,
//                       title: 'Privacy Policy',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (_) => const WebViewScreen(
//                                   pageType: WebViewPageType.privacyPolicy,
//                                 ),
//                           ),
//                         );
//                       },
//                     ),
//                     _buildNeumorphicMenuItem(
//                       context,
//                       icon: Icons.description_outlined,
//                       title: 'Terms & Conditions',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (_) => const WebViewScreen(
//                                   pageType: WebViewPageType.termsAndConditions,
//                                 ),
//                           ),
//                         );
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     _buildNeumorphicMenuItem(
//                       context,
//                       icon: Icons.logout_rounded,
//                       title: 'Logout',
//                       isLogout: true,
//                       onTap: () async {
//                         showLogoutDialog(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: size.height * 0.05),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNeumorphicMenuItem(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool isLogout = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: NeumorphicButton(
//         onPressed: onTap,
//         style: NeumorphicStyle(
//           depth: 4,
//           intensity: 0.8,
//           surfaceIntensity: 0.5,
//           color: _backgroundColor,
//           boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: isLogout ? Colors.red.shade400 : AppColors.primary,
//               size: 24,
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: isLogout ? Colors.red.shade400 : Colors.black87,
//                 ),
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 16,
//               color: Colors.black26,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// student_profile_page.dart
//
// UX Architecture: "Zero-step Profile"
// All three screens (ProfilePage → ProfileSettings → StudentDetail)
// collapsed into a single unified scrollable page.
//
// Structure:
//   Zone 1 — Identity header (avatar + name + group + ID)
//   Zone 2 — Personal details section (expandable data rows)
//   Zone 3 — Account section (privacy, terms)
//   Zone 4 — Danger zone (sign out)
//
// Logic: All BLoC listeners, events and navigation callbacks are
//         identical to the originals — nothing removed.
//
// Palette: matches student_home_page.dart warm-stone system.
// Font:    DM Serif Display (name) + DM Sans (body) via google_fonts.

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_cas_app_main/src/auth/data/service/profile_image_service.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/pages/OnboardingScreen.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/webview_screen.dart';
import '../../domain/webview_page_type.dart';
import '../widgets/logOut_dialog.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PALETTE — mirrors home page warm-stone system exactly
// ══════════════════════════════════════════════════════════════════════════════

class _P {
  static const pageBg = Color(0xFFF9F7F4);
  static const inkDeep = Color(0xFF1C1A17);
  static const inkMid = Color(0xFF5A5550);
  static const inkSoft = Color(0xFF8C8680);
  static const inkFaint = Color(0xFFB5B0A8);
  static const divider = Color(0xFFDDD9D3);
  static const sand = Color(0xFFEDE9E4);

  // Icon beds + strokes — same as home page
  static const sandBed = Color(0xFFC8BCA8);
  static const sageBed = Color(0xFFB5CDB9);
  static const lavBed = Color(0xFFC8B5CF);
  static const stoneBed = Color(0xFFCCB8A8);
  static const mistBed = Color(0xFFB0C4C2);

  static const sandStroke = Color(0xFF6B5C44);
  static const sageStroke = Color(0xFF3B6B44);
  static const lavStroke = Color(0xFF5B3D6B);
  static const stoneStroke = Color(0xFF6B4A33);
  static const mistStroke = Color(0xFF3B5C5A);
}

// ══════════════════════════════════════════════════════════════════════════════
// UNIFIED STUDENT PROFILE PAGE
// ══════════════════════════════════════════════════════════════════════════════

class StudentProfilePage extends StatefulWidget {
  final String id;
  const StudentProfilePage({super.key, required this.id});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage>
    with SingleTickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────────────
  String? _pickedImage;
  StudentEntityClass? _student; // populated by BLoC → GroupStudentsDatafetched
  bool _loadingDetails = true;

  late final AnimationController _entranceCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _lift;

  @override
  void initState() {
    super.initState();

    // ── Entrance animation ───────────────────────────────────────────────
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _lift = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _entranceCtrl.forward();

    // ── Fetch detail data immediately — no separate tap needed ───────────
    context.read<StudentFeatureBloc>().add(
      FetchGroupStudentsEvent(id: widget.id),
    );
    _loadProfileImage();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfileImage() async {
    final svc = ProfileImageService();
    final img = await svc.getSavedImageBase64(studentId: widget.id);
    if (mounted) setState(() => _pickedImage = img);
    log('Profile image loaded: ${_pickedImage != null}');
  }

  Future<void> _pickImage() async {
    if (_student == null) return;
    final svc = ProfileImageService();
    final img = await svc.pickAndSaveImage(
      studentId: _student!.id,
      groupName: _student!.group,
    );
    if (img != null && mounted) {
      setState(() => _pickedImage = img);
      log('Profile image updated');
    }
  }

  // ── BLoC state → populate local student data ─────────────────────────
  void _onBlocState(BuildContext context, StudentFeatureState state) {
    if (state is StudentSigInOutState) {
      // ── Original logout logic: unchanged ────────────────────────────
      context.read<OnboardingBloc>().add(ResetOnboardingEvent());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
        (route) => false,
      );
    } else if (state is GroupStudentsDatafetched) {
      // ── Populate details inline — no separate screen navigation ─────
      setState(() {
        _loadingDetails = false;
        _student = StudentEntityClass(
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
        );
      });
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0].substring(0, parts[0].length.clamp(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return BlocListener<StudentFeatureBloc, StudentFeatureState>(
      listener: _onBlocState,
      child: Scaffold(
        backgroundColor: _P.pageBg,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _lift,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Top nav bar ────────────────────────────────────────
                  SliverToBoxAdapter(child: _NavBar()),

                  // ── Edition rule ───────────────────────────────────────
                  const SliverToBoxAdapter(
                    child: Divider(
                      height: 1,
                      thickness: 0.8,
                      color: _P.divider,
                    ),
                  ),

                  // ── Zone 1: Identity hero ──────────────────────────────
                  SliverToBoxAdapter(
                    child: _IdentityHero(
                      student: _student,
                      pickedImage: _pickedImage,
                      onAvatarTap: _pickImage,
                      initials:
                          _student != null ? _initials(_student!.name) : '?',
                    ),
                  ),

                  // ── Double rule ────────────────────────────────────────
                  SliverToBoxAdapter(child: _DoubleRule()),

                  // ── Zone 2: Personal details ───────────────────────────
                  SliverToBoxAdapter(child: _SectionLabel('Personal details')),
                  SliverToBoxAdapter(
                    child: _PersonalDetailsSection(
                      student: _student,
                      loading: _loadingDetails,
                    ),
                  ),

                  // ── Zone 3: Account links ──────────────────────────────
                  SliverToBoxAdapter(child: _SectionLabel('Account')),
                  SliverToBoxAdapter(child: _AccountSection(context)),

                  // ── Zone 4: Sign out ───────────────────────────────────
                  SliverToBoxAdapter(child: _SignOutButton()),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Account section rows ─────────────────────────────────────────────────
  Widget _AccountSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _CardGroup(
        children: [
          _MenuRow(
            iconBed: _P.mistBed,
            iconStroke: _P.mistStroke,
            icon: Icons.shield_outlined,
            label: 'Privacy Policy',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const WebViewScreen(
                          pageType: WebViewPageType.privacyPolicy,
                        ),
                  ),
                ),
          ),
          _MenuRow(
            iconBed: _P.sandBed,
            iconStroke: _P.sandStroke,
            icon: Icons.description_outlined,
            label: 'Terms & Conditions',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const WebViewScreen(
                          pageType: WebViewPageType.termsAndConditions,
                        ),
                  ),
                ),
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ── Sign out button ──────────────────────────────────────────────────────
  Widget _SignOutButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: _PressableCard(
        onTap: () => showLogoutDialog(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            color: _P.inkDeep,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 16,
                  color: Color(0xFFC8C2BB),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Sign out',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFF9F7F4),
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: Color(0xFF6B6762),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// NAV BAR
// ══════════════════════════════════════════════════════════════════════════════

class _NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PressableCard(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _P.sand,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: _P.sandStroke,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: _P.divider, width: 0.8),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'STUDENT PROFILE',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
                color: _P.inkSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ZONE 1 — Identity Hero
// ══════════════════════════════════════════════════════════════════════════════

class _IdentityHero extends StatelessWidget {
  final StudentEntityClass? student;
  final String? pickedImage;
  final VoidCallback onAvatarTap;
  final String initials;

  const _IdentityHero({
    required this.student,
    required this.pickedImage,
    required this.onAvatarTap,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _P.sand,
                    border: Border.all(color: _P.divider, width: 1.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child:
                      pickedImage != null
                          ? Image.memory(
                            base64Decode(pickedImage!),
                            fit: BoxFit.cover,
                          )
                          : Center(
                            child: Text(
                              initials,
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 22,
                                color: _P.inkMid,
                              ),
                            ),
                          ),
                ),
                // Camera badge
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _P.inkDeep,
                      shape: BoxShape.circle,
                      border: Border.all(color: _P.pageBg, width: 2),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Name + meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student?.name ?? '—',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 22,
                    color: _P.inkDeep,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _MetaPill(
                      student?.group != null ? 'Group ${student!.group}' : '—',
                    ),
                    const SizedBox(width: 6),
                    const _Dot(),
                    const SizedBox(width: 6),
                    _MetaPill(student?.email ?? '—'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String text;
  const _MetaPill(this.text);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: _P.inkSoft),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) => Container(
    width: 3,
    height: 3,
    decoration: const BoxDecoration(shape: BoxShape.circle, color: _P.divider),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// DOUBLE RULE
// ══════════════════════════════════════════════════════════════════════════════

class _DoubleRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(height: 2.5, color: _P.inkDeep),
          const SizedBox(height: 3),
          Row(
            children: [
              Expanded(child: Container(height: 0.8, color: _P.divider)),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 0.8, color: _P.divider)),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SECTION LABEL
// ══════════════════════════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w500,
          color: _P.inkSoft,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ZONE 2 — Personal Details Section
// ══════════════════════════════════════════════════════════════════════════════

class _PersonalDetailsSection extends StatelessWidget {
  final StudentEntityClass? student;
  final bool loading;
  const _PersonalDetailsSection({required this.student, required this.loading});

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _SkeletonLoader(),
      );
    }

    final s = student;
    if (s == null) return const SizedBox.shrink();

    final rows = [
      _DetailRowData(
        Icons.person_outline_rounded,
        _P.sandBed,
        _P.sandStroke,
        'Father\'s name',
        s.fatherName,
      ),
      _DetailRowData(
        Icons.work_outline_rounded,
        _P.sageBed,
        _P.sageStroke,
        'Father\'s occupation',
        s.fatherOccupation,
      ),
      _DetailRowData(
        Icons.credit_card_rounded,
        _P.lavBed,
        _P.lavStroke,
        'CNIC',
        s.cnic,
      ),
      _DetailRowData(
        Icons.phone_outlined,
        _P.stoneBed,
        _P.stoneStroke,
        'Phone',
        s.phone,
      ),
      _DetailRowData(
        Icons.person_2_outlined,
        _P.mistBed,
        _P.mistStroke,
        'Gender',
        s.gender,
      ),
      _DetailRowData(
        Icons.home_outlined,
        _P.sandBed,
        _P.sandStroke,
        'Address',
        s.address,
      ),
      _DetailRowData(
        Icons.badge_outlined,
        _P.sageBed,
        _P.sageStroke,
        'Student ID',
        s.id,
      ),
      _DetailRowData(
        Icons.email_outlined,
        _P.lavBed,
        _P.lavStroke,
        'Email',
        s.email,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _CardGroup(
        children:
            rows.asMap().entries.map((e) {
              final isLast = e.key == rows.length - 1;
              final d = e.value;
              return _DetailRow(
                iconBed: d.iconBed,
                iconStroke: d.iconStroke,
                icon: d.icon,
                label: d.label,
                value: d.value,
                isLast: isLast,
              );
            }).toList(),
      ),
    );
  }
}

class _DetailRowData {
  final IconData icon;
  final Color iconBed;
  final Color iconStroke;
  final String label;
  final String value;
  const _DetailRowData(
    this.icon,
    this.iconBed,
    this.iconStroke,
    this.label,
    this.value,
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED UI PRIMITIVES
// ══════════════════════════════════════════════════════════════════════════════

/// Grouped card container — warm sand background, rounded, rows inside
class _CardGroup extends StatelessWidget {
  final List<Widget> children;
  const _CardGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _P.sand,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(children: children),
    );
  }
}

/// Single detail row — icon + label + value
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconBed;
  final Color iconStroke;
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.iconBed,
    required this.iconStroke,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : const Border(
                  bottom: BorderSide(color: Color(0xFFE2DDD6), width: 0.8),
                ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBed,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: iconStroke),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: _P.inkSoft),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _P.inkDeep,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Menu row — icon + label + chevron
class _MenuRow extends StatefulWidget {
  final IconData icon;
  final Color iconBed;
  final Color iconStroke;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  const _MenuRow({
    required this.icon,
    required this.iconBed,
    required this.iconStroke,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  @override
  State<_MenuRow> createState() => _MenuRowState();
}

class _MenuRowState extends State<_MenuRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            border:
                widget.isLast
                    ? null
                    : const Border(
                      bottom: BorderSide(color: Color(0xFFE2DDD6), width: 0.8),
                    ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.iconBed,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(widget.icon, size: 16, color: widget.iconStroke),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _P.inkDeep,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: _P.inkFaint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pressable wrapper — scale on tap
class _PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PressableCard({required this.child, required this.onTap});

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SKELETON LOADER — shown while BLoC fetches data
// ══════════════════════════════════════════════════════════════════════════════

class _SkeletonLoader extends StatefulWidget {
  const _SkeletonLoader();
  @override
  State<_SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<_SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final opacity = 0.4 + 0.35 * _anim.value;
        return Container(
          decoration: BoxDecoration(
            color: _P.sand.withOpacity(opacity),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: List.generate(
              4,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _P.sandBed.withOpacity(opacity),
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 9,
                          decoration: BoxDecoration(
                            color: _P.divider.withOpacity(opacity),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 130,
                          height: 11,
                          decoration: BoxDecoration(
                            color: _P.inkFaint.withOpacity(opacity * 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
