// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/presentation/widgets/buildHeader.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/presentation/widgets/buildQuickActions.dart';

// import '../bloc/Student_feature_event.dart';
// import '../bloc/student_feature_bloc.dart';

// class StudentHomePage extends StatefulWidget {
//   final String id;
//   final StudentEntityClass studentEntityClass;
//   const StudentHomePage({
//     super.key,
//     required this.id,
//     required this.studentEntityClass,
//   });

//   @override
//   State<StudentHomePage> createState() {
//     // if (studentEntityClass == null) {
//     //   //   AssertionError("student is null");
//     //   throw AssertionError('student is null');
//     // }
//     return _StudentHomePageState();
//   }
// }

// class _StudentHomePageState extends State<StudentHomePage>
//     with TickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   final List<Map<String, dynamic>> subjects = [
//     {
//       'title': 'Mathematics',
//       'icon': Icons.calculate_rounded,
//       'gradient': [const Color(0xFF667eea), const Color(0xFF764ba2)],
//       'isSelected': true,
//       'courses': 24,
//       'progress': 0.75,
//     },
//     {
//       'title': 'Physics',
//       'icon': Icons.science_rounded,
//       'gradient': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
//       'isSelected': false,
//       'courses': 18,
//       'progress': 0.60,
//     },
//     {
//       'title': 'Chemistry',
//       'icon': Icons.biotech_rounded,
//       'gradient': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
//       'isSelected': false,
//       'courses': 22,
//       'progress': 0.45,
//     },
//     {
//       'title': 'Biology',
//       'icon': Icons.eco_rounded,
//       'gradient': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
//       'isSelected': false,
//       'courses': 20,
//       'progress': 0.80,
//     },
//     {
//       'title': 'Computer Science',
//       'icon': Icons.computer_rounded,
//       'gradient': [const Color(0xFF667eea), const Color(0xFF764ba2)],
//       'isSelected': false,
//       'courses': 32,
//       'progress': 0.55,
//     },
//     {
//       'title': 'English',
//       'icon': Icons.book_rounded,
//       'gradient': [const Color(0xFFfa709a), const Color(0xFFfee140)],
//       'isSelected': false,
//       'courses': 16,
//       'progress': 0.70,
//     },
//     {
//       'title': 'History',
//       'icon': Icons.history_edu_rounded,
//       'gradient': [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
//       'isSelected': false,
//       'courses': 14,
//       'progress': 0.65,
//     },
//     {
//       'title': 'Art & Design',
//       'icon': Icons.palette_rounded,
//       'gradient': [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
//       'isSelected': false,
//       'courses': 12,
//       'progress': 0.40,
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();

//     context.read<StudentFeatureBloc>().add(CheckPermissionEvent());
//     debugPrint(widget.studentEntityClass.name);
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     debugPrint("Build get callled");

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
//           ),
//         ),
//         child: SafeArea(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     buildHeader(
//                       widget.studentEntityClass.name,
//                       context,
//                       widget.id,
//                     ),
//                     // buildStatsCard(),
//                     buildQuickActions(
//                       widget.studentEntityClass.group,
//                       widget.studentEntityClass.name,
//                       widget.studentEntityClass.id,
//                     ),
//                     // buildPopularTeachersSection(),

//                     // buildRecentActivities(),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// student_home_page.dart
//
// Design concept: "Morning Edition"
// Editorial magazine aesthetic — bold serif typography, asymmetric layout,
// time-aware cinematic greeting, stacked chapter-style feature cards.
// Color palette: warm stone neutrals, organic tones, ink on cream.
//
// Dependencies to add to pubspec.yaml:
//   google_fonts: ^6.1.0   (uses DM Serif Display + DM Sans)
//
// All BLoC wiring is unchanged from original.
// VISUAL ENHANCEMENT ONLY — zero logic, state, navigation, or backend changes.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/pages/list_of_request_leave_page.dart';
import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/pages/assignments_list_page.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_profile_page.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_side_fee_details_screen%20.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/pages/quiz_home_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_workshop_time_tracker/presentation/pages/student_workshop_time_tracker.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/presentation/student_adentence_page.dart';
import '../bloc/Student_feature_event.dart';
import '../bloc/student_feature_bloc.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PALETTE — Warm stone neutrals (UNCHANGED)
// ══════════════════════════════════════════════════════════════════════════════

class _Ink {
  static const pageBg = Color(0xFFF9F7F4);
  static const inkDeep = Color(0xFF1C1A17);
  static const inkMid = Color(0xFF5A5550);
  static const inkSoft = Color(0xFF8C8680);
  static const inkFaint = Color(0xFFB5B0A8);
  static const divider = Color(0xFFDDD9D3);

  static const sand = Color(0xFFEDE9E4);
  static const sage = Color(0xFFE4EDE7);
  static const lavender = Color(0xFFE9E4ED);
  static const stone = Color(0xFFEDE8E4);
  static const mist = Color(0xFFE4EAE9);

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
// PREMIUM SHADOW SYSTEM
// Translates web neumorphic-outset / neumorphic-inset into Flutter BoxShadow
// ══════════════════════════════════════════════════════════════════════════════

class _Shadows {
  // Raised surface — dark shadow below-right, faint light lift above-left
  static List<BoxShadow> outset({double intensity = 1.0}) => [
    BoxShadow(
      color: Colors.black.withOpacity(0.13 * intensity),
      blurRadius: 18,
      spreadRadius: 0,
      offset: const Offset(6, 8),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.72 * intensity),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(-4, -4),
    ),
  ];

  // Card-level soft lift — used on feature cards
  static List<BoxShadow> card({Color? tint}) => [
    BoxShadow(
      color: Colors.black.withOpacity(0.09),
      blurRadius: 24,
      spreadRadius: -2,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.80),
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(-3, -3),
    ),
    if (tint != null)
      BoxShadow(
        color: tint.withOpacity(0.10),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 6),
      ),
  ];

  // Dark card (hero assignment slab) — inverted neumorphism
  static List<BoxShadow> darkCard() => [
    BoxShadow(
      color: Colors.black.withOpacity(0.35),
      blurRadius: 22,
      spreadRadius: 0,
      offset: const Offset(6, 10),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.04),
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(-4, -4),
    ),
  ];

  // Pressed / inset state
  static List<BoxShadow> pressed() => [
    BoxShadow(
      color: Colors.black.withOpacity(0.18),
      blurRadius: 6,
      spreadRadius: 0,
      offset: const Offset(3, 4),
    ),
  ];

  // Profile avatar ring
  static List<BoxShadow> avatarRing() => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 10,
      offset: const Offset(3, 4),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.90),
      blurRadius: 8,
      offset: const Offset(-2, -2),
    ),
  ];
}

// ══════════════════════════════════════════════════════════════════════════════
// PREMIUM DECORATION HELPERS
// ══════════════════════════════════════════════════════════════════════════════

class _Dec {
  // Glass rim border — directional gradient, bright top-left fading bottom-right
  static Border glassRim({double opacity = 0.18}) =>
      Border.all(color: Colors.white.withOpacity(opacity), width: 1.0);

  // Card surface gradient — very subtle warm light catch from top
  static LinearGradient cardSurface(Color base) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.lerp(base, Colors.white, 0.18)!,
      base,
      Color.lerp(base, Colors.black, 0.04)!,
    ],
    stops: const [0.0, 0.45, 1.0],
  );

  // Dark slab gradient — used on hero assignment card
  static LinearGradient darkSlab(Color base) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color.lerp(base, const Color(0xFF2E2B26), 0.5)!, base],
  );

  // Icon bed gradient — tiny raised pill surface
  static LinearGradient iconBed(Color base) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color.lerp(base, Colors.white, 0.22)!, base],
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// TIME OF DAY MODEL — unchanged from original
// ══════════════════════════════════════════════════════════════════════════════

enum _TimeOfDay { morning, afternoon, evening, night }

class _TimeContext {
  final _TimeOfDay period;
  final String salutation;
  final String tagline;
  final Color heroBg;
  final Color heroAccent;
  final String quote;

  const _TimeContext({
    required this.period,
    required this.salutation,
    required this.tagline,
    required this.heroBg,
    required this.heroAccent,
    required this.quote,
  });

  static _TimeContext now() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) {
      return const _TimeContext(
        period: _TimeOfDay.morning,
        salutation: 'Good morning',
        tagline: 'Morning Edition',
        heroBg: Color(0xFF1C1A17),
        heroAccent: Color(0xFFC4A882),
        quote: '"The secret of getting ahead is getting started."',
      );
    } else if (h >= 12 && h < 17) {
      return const _TimeContext(
        period: _TimeOfDay.afternoon,
        salutation: 'Good afternoon',
        tagline: 'Afternoon Edition',
        heroBg: Color(0xFF2A2318),
        heroAccent: Color(0xFF7EC8A4),
        quote: '"Focus is the art of knowing what to ignore."',
      );
    } else if (h >= 17 && h < 21) {
      return const _TimeContext(
        period: _TimeOfDay.evening,
        salutation: 'Good evening',
        tagline: 'Evening Edition',
        heroBg: Color(0xFF1A1C2A),
        heroAccent: Color(0xFF9B8FCE),
        quote: '"Reflect on what you built today."',
      );
    } else {
      return const _TimeContext(
        period: _TimeOfDay.night,
        salutation: 'Late night',
        tagline: 'Night Edition',
        heroBg: Color(0xFF141214),
        heroAccent: Color(0xFF85B7EB),
        quote: '"Rest is productive. Sleep is a skill."',
      );
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// STUDENT HOME PAGE — structure & logic UNCHANGED
// ══════════════════════════════════════════════════════════════════════════════

class StudentHomePage extends StatefulWidget {
  final String id;
  final StudentEntityClass studentEntityClass;

  const StudentHomePage({
    super.key,
    required this.id,
    required this.studentEntityClass,
  });

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _lift;
  late final _TimeContext _time;

  @override
  void initState() {
    super.initState();

    // ── BLoC: unchanged ──────────────────────────────────────────────────
    context.read<StudentFeatureBloc>().add(CheckPermissionEvent());
    debugPrint(widget.studentEntityClass.name);

    _time = _TimeContext.now();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );
    _lift = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: _Ink.pageBg,
      // ── Premium: subtle ambient light-leak radial at top — mimics web's
      //    fixed `.light-leak` divs, but as a Stack layer behind content ──
      body: Stack(
        children: [
          // Ambient warm glow — top left corner
          Positioned(
            top: -80,
            left: -80,
            child: IgnorePointer(
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _time.heroAccent.withOpacity(0.07),
                      _time.heroAccent.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Ambient cool glow — bottom right corner
          Positioned(
            bottom: -60,
            right: -60,
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _Ink.inkSoft.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Main scroll content
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _lift,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _EditionBanner(time: _time, studentId: widget.id),
                    ),
                    SliverToBoxAdapter(child: _HeroRule()),
                    SliverToBoxAdapter(
                      child: _GreetingBlock(
                        name: widget.studentEntityClass.name,
                        time: _time,
                      ),
                    ),
                    SliverToBoxAdapter(child: _ThickRule()),
                    SliverToBoxAdapter(
                      child: _SectionLabel('Today\'s chapters'),
                    ),
                    SliverToBoxAdapter(
                      child: _HeroChapterCard(
                        studentName: widget.studentEntityClass.name,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _DuoPairRow(
                        left: _ChapterSpec(
                          title: 'Work-',
                          titleItalic: 'shop',
                          subtitle: 'Time tracker',
                          bgColor: _Ink.sand,
                          iconBed: _Ink.sandBed,
                          iconStroke: _Ink.sandStroke,
                          icon: Icons.schedule_rounded,
                          destination: StudentTimeTrackerPage(
                            rollNo: widget.studentEntityClass.id,
                          ),
                        ),
                        right: _ChapterSpec(
                          title: 'IQ',
                          titleItalic: 'Test',
                          subtitle: 'Challenge',
                          bgColor: _Ink.sage,
                          iconBed: _Ink.sageBed,
                          iconStroke: _Ink.sageStroke,
                          icon: Icons.psychology_rounded,
                          destination: const QuizHomeScreen(),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _WideChapterCard(
                        title: 'Leave',
                        titleItalic: 'Request',
                        subtitle: '2 pending review',
                        bgColor: _Ink.lavender,
                        accentColor: const Color(0xFF9B8FCE),
                        iconBed: _Ink.lavBed,
                        iconStroke: _Ink.lavStroke,
                        icon: Icons.event_note_rounded,
                        destination: ListOfRequestLeaveScreen(
                          section: widget.studentEntityClass.group,
                          studentName: widget.studentEntityClass.name,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _DuoPairRow(
                        left: _ChapterSpec(
                          title: 'Install-',
                          titleItalic: 'ments',
                          subtitle: 'Fee details',
                          bgColor: _Ink.stone,
                          iconBed: _Ink.stoneBed,
                          iconStroke: _Ink.stoneStroke,
                          icon: Icons.receipt_long_rounded,
                          destination: StudentSideFeeDetailsScreen(
                            studentId: widget.studentEntityClass.id,
                          ),
                        ),
                        right: _ChapterSpec(
                          title: 'Attend-',
                          titleItalic: 'ance',
                          subtitle: 'My record',
                          bgColor: _Ink.mist,
                          iconBed: _Ink.mistBed,
                          iconStroke: _Ink.mistStroke,
                          icon: Icons.event_available_rounded,
                          destination: StudentAdentencePage(
                            name: widget.studentEntityClass.name,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _Footer(
                        group: widget.studentEntityClass.group,
                        name: widget.studentEntityClass.name,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITION BANNER — dateline + profile icon  [ENHANCED]
// Premium: avatar gets neumorphic ring + outset shadow
//          tag pill gets subtle glass-rim border + surface gradient
// ══════════════════════════════════════════════════════════════════════════════

class _EditionBanner extends StatelessWidget {
  final _TimeContext time;
  final String studentId;
  const _EditionBanner({required this.time, required this.studentId});

  String get _dateString {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TagPill(time.tagline),
          Row(
            children: [
              Text(
                _dateString,
                style: const TextStyle(
                  fontSize: 11,
                  color: _Ink.inkSoft,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentProfilePage(id: studentId),
                      ),
                    ),
                // ── ENHANCED: neumorphic avatar ring ──────────────────────
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    // Subtle gradient surface — warm cream catching light
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFEFEBE5),
                        const Color(0xFFE0DAD2),
                      ],
                    ),
                    shape: BoxShape.circle,
                    // Hair-thin border rim — simulates glass-rim
                    border: Border.all(
                      color: Colors.white.withOpacity(0.75),
                      width: 1.2,
                    ),
                    // Neumorphic outset lift
                    boxShadow: _Shadows.avatarRing(),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 16,
                      color: _Ink.inkMid,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  final String label;
  const _TagPill(this.label);

  @override
  Widget build(BuildContext context) {
    // ── ENHANCED: gradient surface + glass-rim border ──────────────────
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        // Warm cream gradient — catches light from top-left
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.85),
            const Color(0xFFF0ECE7).withOpacity(0.60),
          ],
        ),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _Ink.divider.withOpacity(0.70), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(1, 2),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.85),
            blurRadius: 4,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          letterSpacing: 1.6,
          fontWeight: FontWeight.w500,
          color: _Ink.inkSoft,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HERO RULE — UNCHANGED structurally, micro-refined
// ══════════════════════════════════════════════════════════════════════════════

class _HeroRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Divider(height: 1, thickness: 0.8, color: _Ink.divider)],
    );
  }
}

class _ThickRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── ENHANCED: slight gradient fade on thick rule ───────────────
          Container(
            height: 2.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_Ink.inkDeep, _Ink.inkDeep.withOpacity(0.3)],
              ),
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Expanded(child: Container(height: 0.8, color: _Ink.divider)),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 0.8, color: _Ink.divider)),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// GREETING BLOCK — typographic hero  [UNCHANGED — already premium]
// ══════════════════════════════════════════════════════════════════════════════

class _GreetingBlock extends StatelessWidget {
  final String name;
  final _TimeContext time;
  const _GreetingBlock({required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time.salutation,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.4,
              color: _Ink.inkSoft,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 44,
              fontWeight: FontWeight.w400,
              color: _Ink.inkDeep,
              height: 1.05,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            time.quote,
            style: const TextStyle(
              fontSize: 12.5,
              color: _Ink.inkSoft,
              fontStyle: FontStyle.italic,
              height: 1.55,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SECTION LABEL — UNCHANGED
// ══════════════════════════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w500,
          color: _Ink.inkSoft,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HERO CHAPTER CARD — Assignments  [ENHANCED]
// Premium layer:
//   • darkCard() neumorphic shadow system
//   • Gradient slab instead of flat color
//   • Glass-frosted decorative circle (BackdropFilter)
//   • Progress bar gains a soft ambient glow
//   • Icon container gets glass-rim border
// ══════════════════════════════════════════════════════════════════════════════

class _HeroChapterCard extends StatefulWidget {
  final String studentName;
  const _HeroChapterCard({required this.studentName});

  @override
  State<_HeroChapterCard> createState() => _HeroChapterCardState();
}

class _HeroChapterCardState extends State<_HeroChapterCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AssignmentsListPage()),
          );
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.975 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              // ── ENHANCED: gradient slab ───────────────────────────────
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2A2722),
                  const Color(0xFF1C1A17),
                  const Color(0xFF111009),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
              borderRadius: BorderRadius.circular(22),
              // ── ENHANCED: glass-rim top border ────────────────────────
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1.0,
              ),
              // ── ENHANCED: dark neumorphic outset ──────────────────────
              boxShadow: _pressed ? _Shadows.pressed() : _Shadows.darkCard(),
            ),
            child: Stack(
              children: [
                // ── ENHANCED: glassmorphic frosted circle ────────────────
                Positioned(
                  right: -24,
                  top: -24,
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                            width: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Secondary smaller circle — decorative depth layer
                Positioned(
                  right: 30,
                  bottom: -10,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.025),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'My\n',
                                style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFF9F7F4),
                                  height: 1.0,
                                ),
                              ),
                              TextSpan(
                                text: 'Assignments',
                                style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  color: const Color(0xFFF9F7F4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ── ENHANCED: icon box with glass-rim ─────────────
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.12),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.10),
                              width: 0.8,
                            ),
                          ),
                          child: const Icon(
                            Icons.assignment_rounded,
                            size: 18,
                            color: Color(0xFFC8C2BB),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // ── ENHANCED: progress bar with ambient glow ──────────
                    Stack(
                      children: [
                        // Glow layer behind bar
                        Container(
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFC4A882,
                                ).withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 3,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFD4B892),
                                        Color(0xFFC4A882),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 3,
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '3 of 5 complete',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B6762)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// WIDE CHAPTER CARD  [ENHANCED]
// Premium layer:
//   • card() neumorphic shadow system with tint
//   • Surface gradient from bgColor (light-catch simulation)
//   • Glass-rim top border
//   • Icon bed gets gradient surface
//   • Accent dot picks up a soft glow BoxShadow
// ══════════════════════════════════════════════════════════════════════════════

class _WideChapterCard extends StatefulWidget {
  final String title;
  final String titleItalic;
  final String subtitle;
  final Color bgColor;
  final Color accentColor;
  final Color iconBed;
  final Color iconStroke;
  final IconData icon;
  final Widget destination;

  const _WideChapterCard({
    required this.title,
    required this.titleItalic,
    required this.subtitle,
    required this.bgColor,
    required this.accentColor,
    required this.iconBed,
    required this.iconStroke,
    required this.icon,
    required this.destination,
  });

  @override
  State<_WideChapterCard> createState() => _WideChapterCardState();
}

class _WideChapterCardState extends State<_WideChapterCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => widget.destination),
          );
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.975 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              // ── ENHANCED: gradient surface ─────────────────────────────
              gradient: _Dec.cardSurface(widget.bgColor),
              borderRadius: BorderRadius.circular(22),
              // ── ENHANCED: glass-rim border ─────────────────────────────
              border: Border.all(
                color: Colors.white.withOpacity(0.55),
                width: 1.0,
              ),
              // ── ENHANCED: neumorphic card shadow with tint ─────────────
              boxShadow:
                  _pressed
                      ? _Shadows.pressed()
                      : _Shadows.card(tint: widget.accentColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${widget.title} ',
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: _Ink.inkDeep,
                              ),
                            ),
                            TextSpan(
                              text: widget.titleItalic,
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: _Ink.inkDeep,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _Ink.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // ── ENHANCED: accent dot with ambient glow ─────────
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.accentColor,
                        boxShadow: [
                          BoxShadow(
                            color: widget.accentColor.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // ── ENHANCED: icon container with gradient bed ────
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: _Dec.iconBed(widget.iconBed),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.50),
                          width: 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(2, 3),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.70),
                            blurRadius: 4,
                            offset: const Offset(-1, -1),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        size: 17,
                        color: widget.iconStroke,
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
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DUO PAIR ROW — UNCHANGED
// ══════════════════════════════════════════════════════════════════════════════

class _ChapterSpec {
  final String title;
  final String titleItalic;
  final String subtitle;
  final Color bgColor;
  final Color iconBed;
  final Color iconStroke;
  final IconData icon;
  final Widget destination;

  const _ChapterSpec({
    required this.title,
    required this.titleItalic,
    required this.subtitle,
    required this.bgColor,
    required this.iconBed,
    required this.iconStroke,
    required this.icon,
    required this.destination,
  });
}

class _DuoPairRow extends StatelessWidget {
  final _ChapterSpec left;
  final _ChapterSpec right;
  const _DuoPairRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          Expanded(child: _SquareChapterCard(spec: left)),
          const SizedBox(width: 10),
          Expanded(child: _SquareChapterCard(spec: right)),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SQUARE CHAPTER CARD  [ENHANCED]
// Premium layer:
//   • card() neumorphic shadow system
//   • Surface gradient from bgColor
//   • Glass-rim border (top-left bright, fades to near-invisible)
//   • Icon bed gets gradient surface + inner-border rim
//   • Pressed state maps to shadow switch (outset → inset feel)
// ══════════════════════════════════════════════════════════════════════════════

class _SquareChapterCard extends StatefulWidget {
  final _ChapterSpec spec;
  const _SquareChapterCard({required this.spec});

  @override
  State<_SquareChapterCard> createState() => _SquareChapterCardState();
}

class _SquareChapterCardState extends State<_SquareChapterCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => widget.spec.destination),
        );
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              // ── ENHANCED: gradient surface ────────────────────────────
              gradient: _Dec.cardSurface(widget.spec.bgColor),
              borderRadius: BorderRadius.circular(22),
              // ── ENHANCED: glass-rim border ────────────────────────────
              border: Border.all(
                color: Colors.white.withOpacity(0.55),
                width: 1.0,
              ),
              // ── ENHANCED: neumorphic shadow, flips on press ───────────
              boxShadow: _pressed ? _Shadows.pressed() : _Shadows.card(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ── ENHANCED: icon container with gradient + rim ─────
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: _Dec.iconBed(widget.spec.iconBed),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.50),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.65),
                        blurRadius: 4,
                        offset: const Offset(-1, -1),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.spec.icon,
                    size: 16,
                    color: widget.spec.iconStroke,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: widget.spec.title,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: _Ink.inkDeep,
                              height: 1.05,
                            ),
                          ),
                          TextSpan(
                            text: '\n${widget.spec.titleItalic}',
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: _Ink.inkDeep,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.spec.subtitle,
                      style: const TextStyle(fontSize: 11, color: _Ink.inkSoft),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// FOOTER — masthead-style colophon  [UNCHANGED — minimal, already right]
// ══════════════════════════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  final String group;
  final String name;
  const _Footer({required this.group, required this.name});

  String get _firstName => name.split(' ').first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Divider(height: 1, thickness: 0.8, color: _Ink.divider),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CAS LEARNING SYSTEM',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.4,
                  color: _Ink.inkFaint,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Group $group · $_firstName',
                style: const TextStyle(fontSize: 10, color: _Ink.inkFaint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
