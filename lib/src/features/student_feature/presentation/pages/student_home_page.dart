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
// PALETTE — Warm stone neutrals
// ══════════════════════════════════════════════════════════════════════════════

class _Ink {
  static const pageBg = Color(0xFFF9F7F4); // warm cream
  static const inkDeep = Color(0xFF1C1A17); // near-black
  static const inkMid = Color(0xFF5A5550); // editorial gray
  static const inkSoft = Color(0xFF8C8680); // muted label
  static const inkFaint = Color(0xFFB5B0A8); // hairline
  static const divider = Color(0xFFDDD9D3); // rule line

  // Feature card tones
  static const sand = Color(0xFFEDE9E4);
  static const sage = Color(0xFFE4EDE7);
  static const lavender = Color(0xFFE9E4ED);
  static const stone = Color(0xFFEDE8E4);
  static const mist = Color(0xFFE4EAE9);

  // Icon bed tones
  static const sandBed = Color(0xFFC8BCA8);
  static const sageBed = Color(0xFFB5CDB9);
  static const lavBed = Color(0xFFC8B5CF);
  static const stoneBed = Color(0xFFCCB8A8);
  static const mistBed = Color(0xFFB0C4C2);

  // Icon stroke tones
  static const sandStroke = Color(0xFF6B5C44);
  static const sageStroke = Color(0xFF3B6B44);
  static const lavStroke = Color(0xFF5B3D6B);
  static const stoneStroke = Color(0xFF6B4A33);
  static const mistStroke = Color(0xFF3B5C5A);
}

// ══════════════════════════════════════════════════════════════════════════════
// TIME OF DAY MODEL — drives cinematic greeting
// ══════════════════════════════════════════════════════════════════════════════

enum _TimeOfDay { morning, afternoon, evening, night }

class _TimeContext {
  final _TimeOfDay period;
  final String salutation; // e.g. "Good morning"
  final String tagline; // e.g. "Morning Edition"
  final Color heroBg; // dark slab behind name
  final Color heroAccent; // progress bar accent
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
// STUDENT HOME PAGE
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
      body: SafeArea(
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
                SliverToBoxAdapter(child: _SectionLabel('Today\'s chapters')),
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
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITION BANNER — dateline + profile icon
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
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E3DC),
                    shape: BoxShape.circle,
                    border: Border.all(color: _Ink.divider),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: _Ink.divider),
        borderRadius: BorderRadius.circular(3),
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
// HERO RULE — single hairline then thick rule (editorial double-rule)
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
          Container(height: 2.5, color: _Ink.inkDeep),
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
// GREETING BLOCK — the typographic hero
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
          // Full name — professional, confident, no decoration
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
// SECTION LABEL
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
// HERO CHAPTER CARD — Assignments (full-width dark slab)
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
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: _Ink.inkDeep,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Stack(
              children: [
                // Decorative circle
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.04),
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
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(11),
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
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 3,
                              color: const Color(0xFFC4A882),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 3,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
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
// WIDE CHAPTER CARD — horizontal layout with accent dot
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(22),
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
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.accentColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: widget.iconBed,
                        borderRadius: BorderRadius.circular(11),
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
// DUO PAIR ROW — two square chapter cards side by side
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
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: widget.spec.bgColor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: widget.spec.iconBed,
                    borderRadius: BorderRadius.circular(10),
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
// FOOTER — masthead-style colophon
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
