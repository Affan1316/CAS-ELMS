// import 'package:flutter_cas_app_main/src/features/student_quiz_page/data/quiz_manager.dart';
// import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/widgets/quiz_card.dart';
// import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart'; // Import AppColors

// class QuizHomeScreen extends StatefulWidget {
//   const QuizHomeScreen({super.key});

//   @override
//   State<QuizHomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<QuizHomeScreen>
//     with TickerProviderStateMixin {
//   late List<AnimationController> _controllers;
//   Map<String, dynamic>? userStats;
//   Map<String, int> categoryProgress = {};
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _controllers = List.generate(
//       3,
//       (i) => AnimationController(
//         duration: Duration(milliseconds: 300 + (i * 100)),
//         vsync: this,
//       )..forward(),
//     );
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       // Check and reset if new day
//       await QuizManager.instance.checkAndResetIfNewDay();

//       // Load user stats
//       final stats = await QuizManager.instance.getUserStats();

//       // Load category progress
//       final progress = await QuizManager.instance.getAllCategoryProgress();

//       setState(() {
//         userStats = stats;
//         categoryProgress = progress;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
//       }
//     }
//   }

//   @override
//   void dispose() {
//     for (var c in _controllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   /// Builds neumorphic header with back button and user profile
//   Widget _buildNeumorphicHeader(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final horizontalPadding = size.width * 0.05;
//     final titleFontSize = size.width * 0.07;
//     final iconSize = size.width * 0.065;
//     final backButtonPadding = size.width * 0.04;

//     return Container(
//       margin: EdgeInsets.symmetric(
//         horizontal: horizontalPadding * 0.8,
//         vertical: size.height * 0.02,
//       ),
//       child: Neumorphic(
//         style: NeumorphicStyle(
//           depth: 8,
//           intensity: 0.65,
//           boxShape: NeumorphicBoxShape.roundRect(
//             BorderRadius.circular(size.width * 0.06),
//           ),
//           color: const Color(0xFFFAFAFA),
//         ),
//         child: Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: horizontalPadding * 1.2,
//             vertical: size.height * 0.025,
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(size.width * 0.06),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 const Color(0xFFFAFAFA).withOpacity(0.9),
//                 const Color(0xFFF0F0F0).withOpacity(0.8),
//               ],
//             ),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Back Button
//               FadeInDown(
//                 delay: const Duration(milliseconds: 300),
//                 child: NeumorphicButton(
//                   onPressed: () {
//                     Navigator.of(context).maybePop();
//                   },
//                   style: NeumorphicStyle(
//                     boxShape: const NeumorphicBoxShape.circle(),
//                     depth: 6,
//                     intensity: 0.8,
//                     shape: NeumorphicShape.flat,
//                     color: const Color(0xFFFAFAFA),
//                   ),
//                   padding: EdgeInsets.all(backButtonPadding),
//                   child: Icon(
//                     Icons.arrow_back_ios_new,
//                     size: iconSize,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               SizedBox(width: size.width * 0.04),

//               // Title Section
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     FadeInDown(
//                       delay: const Duration(milliseconds: 400),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: size.width * 0.01,
//                             height: titleFontSize * 0.65,
//                             decoration: BoxDecoration(
//                               color: AppColors.primaryDark, // Using AppColors
//                               borderRadius: BorderRadius.circular(
//                                 size.width * 0.01,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: size.width * 0.025),
//                           Text(
//                             'Welcome back',
//                             style: TextStyle(
//                               fontSize: titleFontSize * 0.5,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey[500],
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: size.height * 0.008),
//                     FadeInDown(
//                       delay: const Duration(milliseconds: 500),
//                       child: ShaderMask(
//                         shaderCallback:
//                             (bounds) => LinearGradient(
//                               colors: [
//                                 AppColors.primary, // Using AppColors
//                                 AppColors.primaryDark, // Using AppColors
//                               ],
//                             ).createShader(bounds),
//                         child: Text(
//                           'Let\'s Learn Today',
//                           style: TextStyle(
//                             fontSize: titleFontSize * 1.1,
//                             fontWeight: FontWeight.w900,
//                             color: Colors.white,
//                             letterSpacing: -0.5,
//                             height: 1.1,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFAFA),
//       body: Column(
//         children: [
//           // Neumorphic Header with SafeArea
//           SafeArea(bottom: false, child: _buildNeumorphicHeader(context)),

//           // Stats Card
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: Responsive.wp(context, 6),
//               vertical: Responsive.hp(context, 1.5),
//             ),
//             child: Container(
//               padding: EdgeInsets.all(Responsive.wp(context, 5)),
//               decoration: BoxDecoration(
//                 gradient: AppColors.primaryGradient, // Using AppColors gradient
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(
//                       0.25,
//                     ), // Using AppColors
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(Responsive.wp(context, 3)),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: Icon(
//                       Icons.stars_rounded,
//                       color: Colors.white,
//                       size: Responsive.wp(context, 7),
//                     ),
//                   ),
//                   SizedBox(width: Responsive.wp(context, 4)),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Your Total Score',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: Responsive.sp(context, 13),
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//                         SizedBox(height: Responsive.hp(context, 0.5)),
//                         isLoading
//                             ? Text(
//                               'Loading...',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: Responsive.sp(context, 22),
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             )
//                             : Text(
//                               '${userStats?['total_score'] ?? 0} Points',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: Responsive.sp(context, 22),
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: -0.5,
//                               ),
//                             ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: Responsive.wp(context, 3.5),
//                       vertical: Responsive.hp(context, 1),
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.local_fire_department_rounded,
//                           color: Color(0xFFFFA500),
//                           size: Responsive.wp(context, 4.5),
//                         ),
//                         SizedBox(width: Responsive.wp(context, 1.5)),
//                         Text(
//                           '${userStats?['current_streak'] ?? 0}',
//                           style: TextStyle(
//                             color: Color(0xFF1E293B),
//                             fontWeight: FontWeight.w800,
//                             fontSize: Responsive.sp(context, 15),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Quiz Categories List
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _loadData,
//               child: ListView(
//                 padding: EdgeInsets.all(Responsive.wp(context, 6)),
//                 physics: const BouncingScrollPhysics(),
//                 children: [
//                   Text(
//                     'Quiz Categories',
//                     style: TextStyle(
//                       fontSize: Responsive.sp(context, 20),
//                       fontWeight: FontWeight.w800,
//                       color: Color(0xFF1E293B),
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   SizedBox(height: Responsive.hp(context, 2.5)),
//                   if (isLoading)
//                     Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(Responsive.hp(context, 5)),
//                         child: CircularProgressIndicator(),
//                       ),
//                     )
//                   else
//                     ...List.generate(
//                       quizCategories.length,
//                       (i) => FadeTransition(
//                         opacity: _controllers[i],
//                         child: SlideTransition(
//                           position: Tween<Offset>(
//                             begin: const Offset(0, 0.2),
//                             end: Offset.zero,
//                           ).animate(
//                             CurvedAnimation(
//                               parent: _controllers[i],
//                               curve: Curves.easeOut,
//                             ),
//                           ),
//                           child: QuizCardUpdated(
//                             category: quizCategories[i],
//                             questionsAnswered:
//                                 categoryProgress[quizCategories[i]['id']] ?? 0,
//                             onRefresh: _loadData,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Updated quiz categories (replacing old hardcoded data)
// final List<Map<String, dynamic>> quizCategories = [
//   {
//     'id': 'Java',
//     'title': 'Java Programming',
//     'description': 'Master Java fundamentals',
//     'icon': Icons.code_rounded,
//     'gradientColors': [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//   },
//   {
//     'id': 'Dart',
//     'title': 'Dart Language',
//     'description': 'Learn Dart essentials',
//     'icon': Icons.flutter_dash_rounded,
//     'gradientColors': [Color(0xFF06B6D4), Color(0xFF3B82F6)],
//   },
//   {
//     'id': 'Python',
//     'title': 'Python Basics',
//     'description': 'Explore Python programming',
//     'icon': Icons.terminal_rounded,
//     'gradientColors': [Color(0xFF10B981), Color(0xFF34D399)],
//   },
// ];

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/data/quiz_manager.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/widgets/quiz_card.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';

// ── Tokens ────────────────────────────────────────────────────────────────────

class _T {
  static const pageBg = Color(0xFFF5F5F5);
  static const cardBg = Color(0xFFFFFFFF);
  static const surfaceBg = Color(0xFFEAEAEA);
  static const heroBg = Color(0xFF111111);
  static const inkDeep = Color(0xFF111111);
  static const inkMid = Color(0xFF555555);
  static const inkSoft = Color(0xFFAAAAAA);
  static const inkFaint = Color(0xFFBBBBBB);
  static const divider = Color(0xFFEBEBEB);
}

// ── Page ──────────────────────────────────────────────────────────────────────

class QuizHomeScreen extends StatefulWidget {
  const QuizHomeScreen({super.key});

  @override
  State<QuizHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<QuizHomeScreen>
    with TickerProviderStateMixin {
  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  late List<AnimationController> _controllers;
  Map<String, dynamic>? userStats;
  Map<String, int> categoryProgress = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        duration: Duration(milliseconds: 300 + (i * 100)),
        vsync: this,
      )..forward(),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await QuizManager.instance.checkAndResetIfNewDay();
      final stats = await QuizManager.instance.getUserStats();
      final progress = await QuizManager.instance.getAllCategoryProgress();
      setState(() {
        userStats = stats;
        categoryProgress = progress;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }
  // ── END LOGIC ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: _T.pageBg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: _T.inkDeep,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: FadeInDown(
                  duration: const Duration(milliseconds: 380),
                  child: _Header(
                    onBack: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),

              // ── Score banner ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 60),
                  child: _ScoreBanner(
                    isLoading: isLoading,
                    totalScore: userStats?['total_score'] ?? 0,
                    streak: userStats?['current_streak'] ?? 0,
                  ),
                ),
              ),

              // ── Section label ────────────────────────────────────────
              const SliverToBoxAdapter(child: _SectionLabel('Categories')),

              // ── Category cards ───────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 32),
                sliver:
                    isLoading
                        ? const SliverToBoxAdapter(child: _LoadingState())
                        : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => FadeTransition(
                              opacity: _controllers[i],
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.2),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _controllers[i],
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  // ── LOGIC UNCHANGED: QuizCardUpdated ──
                                  child: QuizCardUpdated(
                                    category: quizCategories[i],
                                    questionsAnswered:
                                        categoryProgress[quizCategories[i]['id']] ??
                                        0,
                                    onRefresh: _loadData,
                                  ),
                                ),
                              ),
                            ),
                            childCount: quizCategories.length,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: _T.surfaceBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 15,
                  color: _T.inkMid,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CHALLENGE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: _T.inkSoft,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'IQ Test',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                    height: 1.0,
                    color: _T.inkDeep,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Score banner ──────────────────────────────────────────────────────────────

class _ScoreBanner extends StatelessWidget {
  final bool isLoading;
  final int totalScore;
  final int streak;
  const _ScoreBanner({
    required this.isLoading,
    required this.totalScore,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _T.heroBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Icon bed
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Center(
              child: Icon(Icons.stars_rounded, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          // Score text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total score',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0x80FFFFFF),
                  ),
                ),
                const SizedBox(height: 3),
                isLoading
                    ? const Text(
                      '—',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    )
                    : Text(
                      '$totalScore Points',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Colors.white,
                      ),
                    ),
              ],
            ),
          ),
          // Streak pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFFFA500),
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  '$streak',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 10),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: _T.divider)),
          const SizedBox(width: 10),
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: _T.inkSoft,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 1, color: _T.divider)),
        ],
      ),
    );
  }
}

// ── Loading state ─────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: _T.inkDeep),
      ),
    );
  }
}

// ── Category data (UNCHANGED) ─────────────────────────────────────────────────

final List<Map<String, dynamic>> quizCategories = [
  {
    'id': 'Java',
    'title': 'Java Programming',
    'description': 'Master Java fundamentals',
    'icon': Icons.code_rounded,
    'gradientColors': [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  },
  {
    'id': 'Dart',
    'title': 'Dart Language',
    'description': 'Learn Dart essentials',
    'icon': Icons.flutter_dash_rounded,
    'gradientColors': [Color(0xFF06B6D4), Color(0xFF3B82F6)],
  },
  {
    'id': 'Python',
    'title': 'Python Basics',
    'description': 'Explore Python programming',
    'icon': Icons.terminal_rounded,
    'gradientColors': [Color(0xFF10B981), Color(0xFF34D399)],
  },
];
