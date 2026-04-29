// import 'package:flutter/material.dart';
// import 'package:flutter_cas_app_main/src/features/student_quiz_page/data/quiz_manager.dart';
// import 'package:flutter_cas_app_main/src/features/student_quiz_page/domain/services/google_sheets_service.dart';
// import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';
// import 'quiz_home_screen.dart';

// class ResultScreenUpdated extends StatefulWidget {
//   final int score;
//   final int totalQuestions;
//   final Map<String, dynamic> category;
//   final List<QuestionModel> questions;
//   final List<bool> answersCorrect;
//   final List<int> timeTaken;
//   final VoidCallback onComplete;

//   const ResultScreenUpdated({
//     super.key,
//     required this.score,
//     required this.totalQuestions,
//     required this.category,
//     required this.questions,
//     required this.answersCorrect,
//     required this.timeTaken,
//     required this.onComplete,
//   });

//   @override
//   State<ResultScreenUpdated> createState() => _ResultScreenUpdatedState();
// }

// class _ResultScreenUpdatedState extends State<ResultScreenUpdated>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   bool isSaving = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 700),
//       vsync: this,
//     );
//     _scaleAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.elasticOut,
//     );
//     _controller.forward();
//     _saveResults();
//   }

//   Future<void> _saveResults() async {
//     try {
//       // Save quiz results to database
//       await QuizManager.instance.saveQuizResult(
//         category: widget.category['id'],
//         questions: widget.questions,
//         answers: widget.answersCorrect,
//         timeTaken: widget.timeTaken,
//       );

//       setState(() {
//         isSaving = false;
//       });
//     } catch (e) {
//       setState(() {
//         isSaving = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error saving results: $e')));
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final percentage = (widget.score / widget.totalQuestions * 100).round();
//     final passed = percentage >= 60;
//     final gradientColors = widget.category['gradientColors'] as List<Color>;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFAFA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Quiz Complete',
//           style: TextStyle(
//             color: Color(0xFF1E293B),
//             fontWeight: FontWeight.w700,
//             fontSize: Responsive.sp(context, 18),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.all(Responsive.wp(context, 6)),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight:
//                     MediaQuery.of(context).size.height -
//                     MediaQuery.of(context).padding.top -
//                     kToolbarHeight -
//                     Responsive.wp(context, 12),
//               ),
//               child: IntrinsicHeight(
//                 child: Column(
//                   children: [
//                     SizedBox(height: Responsive.hp(context, 3)),
//                     ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: Container(
//                         width: Responsive.wp(context, 32),
//                         height: Responsive.wp(context, 32),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors:
//                                 passed
//                                     ? [
//                                       const Color(0xFF10B981),
//                                       const Color(0xFF34D399),
//                                     ]
//                                     : [
//                                       const Color(0xFFEF4444),
//                                       const Color(0xFFF87171),
//                                     ],
//                           ),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: (passed
//                                       ? const Color(0xFF10B981)
//                                       : const Color(0xFFEF4444))
//                                   .withOpacity(0.4),
//                               blurRadius: 40,
//                               spreadRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: Icon(
//                           passed
//                               ? Icons.emoji_events_rounded
//                               : Icons.refresh_rounded,
//                           size: Responsive.wp(context, 16),
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: Responsive.hp(context, 3)),
//                     Text(
//                       passed ? 'Excellent Work!' : 'Keep Trying!',
//                       style: TextStyle(
//                         fontSize: Responsive.sp(context, 30),
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFF1E293B),
//                         letterSpacing: -0.8,
//                       ),
//                     ),
//                     SizedBox(height: Responsive.hp(context, 1)),
//                     Text(
//                       passed
//                           ? 'You did an amazing job!'
//                           : 'Practice makes perfect',
//                       style: TextStyle(
//                         fontSize: Responsive.sp(context, 14),
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     if (isSaving) ...[
//                       SizedBox(height: Responsive.hp(context, 2)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 gradientColors[0],
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: Responsive.wp(context, 2)),
//                           Text(
//                             'Saving progress...',
//                             style: TextStyle(
//                               fontSize: Responsive.sp(context, 12),
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                     SizedBox(height: Responsive.hp(context, 3.5)),
//                     Container(
//                       padding: EdgeInsets.all(Responsive.wp(context, 6)),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.03),
//                             blurRadius: 20,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Your Score',
//                             style: TextStyle(
//                               fontSize: Responsive.sp(context, 14),
//                               color: Color(0xFF64748B),
//                               fontWeight: FontWeight.w700,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                           SizedBox(height: Responsive.hp(context, 1.5)),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 '${widget.score}',
//                                 style: TextStyle(
//                                   fontSize: Responsive.sp(context, 64),
//                                   fontWeight: FontWeight.w800,
//                                   color:
//                                       passed
//                                           ? const Color(0xFF10B981)
//                                           : const Color(0xFFEF4444),
//                                   height: 0.9,
//                                   letterSpacing: -2,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   bottom: Responsive.hp(context, 1.2),
//                                 ),
//                                 child: Text(
//                                   '/${widget.totalQuestions}',
//                                   style: TextStyle(
//                                     fontSize: Responsive.sp(context, 28),
//                                     color: Colors.grey[500],
//                                     fontWeight: FontWeight.w700,
//                                     letterSpacing: -0.5,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: Responsive.hp(context, 2)),
//                           Container(
//                             padding: EdgeInsets.all(Responsive.wp(context, 4)),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFF8F9FA),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 _buildStat(
//                                   context,
//                                   Icons.check_circle_rounded,
//                                   'Correct',
//                                   '${widget.score}',
//                                   const Color(0xFF10B981),
//                                 ),
//                                 Container(
//                                   width: 1.5,
//                                   height: Responsive.hp(context, 5.5),
//                                   color: const Color(0xFFE9ECEF),
//                                 ),
//                                 _buildStat(
//                                   context,
//                                   Icons.cancel_rounded,
//                                   'Wrong',
//                                   '${widget.totalQuestions - widget.score}',
//                                   const Color(0xFFEF4444),
//                                 ),
//                                 Container(
//                                   width: 1.5,
//                                   height: Responsive.hp(context, 5.5),
//                                   color: const Color(0xFFE9ECEF),
//                                 ),
//                                 _buildStat(
//                                   context,
//                                   Icons.percent_rounded,
//                                   'Score',
//                                   '$percentage%',
//                                   const Color(0xFF6366F1),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(),
//                     SizedBox(height: Responsive.hp(context, 3)),
//                     SizedBox(
//                       width: double.infinity,
//                       height: Responsive.hp(context, 6.5),
//                       child: OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(
//                             color: Color(0xFFE9ECEF),
//                             width: 2,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         onPressed: () {
//                           widget.onComplete();
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             PageRouteBuilder(
//                               pageBuilder: (c, a, sa) => const QuizHomeScreen(),
//                               transitionsBuilder:
//                                   (c, a, sa, child) =>
//                                       FadeTransition(opacity: a, child: child),
//                             ),
//                             (route) => false,
//                           );
//                         },
//                         child: Text(
//                           'Back to Home',
//                           style: TextStyle(
//                             fontSize: Responsive.sp(context, 16),
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF1E293B),
//                             letterSpacing: 0.2,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: Responsive.hp(context, 2)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStat(
//     BuildContext context,
//     IconData icon,
//     String label,
//     String value,
//     Color color,
//   ) {
//     return Flexible(
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(Responsive.wp(context, 2.75)),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(13),
//             ),
//             child: Icon(icon, color: color, size: Responsive.wp(context, 6.5)),
//           ),
//           SizedBox(height: Responsive.hp(context, 1.2)),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: Responsive.sp(context, 22),
//               fontWeight: FontWeight.w800,
//               color: color,
//               letterSpacing: -0.5,
//             ),
//           ),
//           SizedBox(height: Responsive.hp(context, 0.25)),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: Responsive.sp(context, 11),
//               color: Color(0xFF64748B),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/data/quiz_manager.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/domain/services/google_sheets_service.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';
import 'quiz_home_screen.dart';

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

  static const passColor = Color(0xFF10B981);
  static const failColor = Color(0xFFEF4444);
  static const infoColor = Color(0xFF6366F1);
}

// ── Page ──────────────────────────────────────────────────────────────────────

class ResultScreenUpdated extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final Map<String, dynamic> category;
  final List<QuestionModel> questions;
  final List<bool> answersCorrect;
  final List<int> timeTaken;
  final VoidCallback onComplete;

  const ResultScreenUpdated({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.category,
    required this.questions,
    required this.answersCorrect,
    required this.timeTaken,
    required this.onComplete,
  });

  @override
  State<ResultScreenUpdated> createState() => _ResultScreenUpdatedState();
}

class _ResultScreenUpdatedState extends State<ResultScreenUpdated>
    with SingleTickerProviderStateMixin {
  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isSaving = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
    _saveResults();
  }

  Future<void> _saveResults() async {
    try {
      await QuizManager.instance.saveQuizResult(
        category: widget.category['id'],
        questions: widget.questions,
        answers: widget.answersCorrect,
        timeTaken: widget.timeTaken,
      );
      setState(() => isSaving = false);
    } catch (e) {
      setState(() => isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving results: $e')));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  // ── END LOGIC ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final percentage = (widget.score / widget.totalQuestions * 100).round();
    final passed = percentage >= 60;
    final resultColor = passed ? _T.passColor : _T.failColor;
    final wrong = widget.totalQuestions - widget.score;

    return Scaffold(
      backgroundColor: _T.pageBg,
      body: Column(
        children: [
          // ── Dark hero ────────────────────────────────────────────────
          _ResultHero(
            passed: passed,
            scaleAnimation: _scaleAnimation,
            categoryTitle: widget.category['title'] as String,
            isSaving: isSaving,
          ),

          // ── Scrollable body ──────────────────────────────────────────
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Big score
                SliverToBoxAdapter(
                  child: _BigScore(
                    score: widget.score,
                    total: widget.totalQuestions,
                    resultColor: resultColor,
                  ),
                ),

                // Tri-stat grid
                SliverToBoxAdapter(
                  child: _TriStatGrid(
                    correct: widget.score,
                    wrong: wrong,
                    percentage: percentage,
                  ),
                ),

                // Points earned section
                const SliverToBoxAdapter(child: _SectionLabel('Points earned')),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'This quiz',
                            value: '+${widget.score * 10}',
                            sub: 'points earned',
                            valueColor: resultColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            label: 'Accuracy',
                            value: '$percentage%',
                            sub: passed ? 'great work' : 'keep going',
                            valueColor: resultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),

          // ── Back to home button ──────────────────────────────────────
          _HomeButton(
            onTap: () {
              widget.onComplete();
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a, sa) => const QuizHomeScreen(),
                  transitionsBuilder:
                      (c, a, sa, child) =>
                          FadeTransition(opacity: a, child: child),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Result hero ───────────────────────────────────────────────────────────────

class _ResultHero extends StatelessWidget {
  final bool passed;
  final Animation<double> scaleAnimation;
  final String categoryTitle;
  final bool isSaving;

  const _ResultHero({
    required this.passed,
    required this.scaleAnimation,
    required this.categoryTitle,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final medalColor = passed ? _T.passColor : _T.failColor;

    return Container(
      width: double.infinity,
      color: _T.heroBg,
      padding: EdgeInsets.fromLTRB(22, topPad + 20, 22, 26),
      child: Column(
        children: [
          // Medal circle
          ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: medalColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: medalColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                  size: 34,
                  color: medalColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          Text(
            passed ? 'Excellent work!' : 'Keep trying!',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            categoryTitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0x73FFFFFF),
              fontWeight: FontWeight.w500,
            ),
          ),

          // Saving indicator
          if (isSaving) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Color(0x80FFFFFF),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Saving progress…',
                  style: TextStyle(fontSize: 12, color: Color(0x80FFFFFF)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Big score ─────────────────────────────────────────────────────────────────

class _BigScore extends StatelessWidget {
  final int score;
  final int total;
  final Color resultColor;
  const _BigScore({
    required this.score,
    required this.total,
    required this.resultColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$score',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w800,
              color: resultColor,
              height: 0.9,
              letterSpacing: -2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              '/$total',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: _T.inkFaint,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tri-stat grid ─────────────────────────────────────────────────────────────

class _TriStatGrid extends StatelessWidget {
  final int correct;
  final int wrong;
  final int percentage;
  const _TriStatGrid({
    required this.correct,
    required this.wrong,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: Row(
        children: [
          Expanded(
            child: _TriItem(
              value: '$correct',
              label: 'Correct',
              valueColor: _T.passColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TriItem(
              value: '$wrong',
              label: 'Wrong',
              valueColor: _T.failColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TriItem(
              value: '$percentage%',
              label: 'Score',
              valueColor: _T.infoColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TriItem extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  const _TriItem({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _T.divider),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: _T.inkSoft,
              fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 10),
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

// ── Stat card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color valueColor;
  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _T.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: _T.inkSoft,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 11, color: _T.inkFaint)),
        ],
      ),
    );
  }
}

// ── Home button ───────────────────────────────────────────────────────────────

class _HomeButton extends StatelessWidget {
  final VoidCallback onTap;
  const _HomeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 12 + bottomPad),
      color: _T.pageBg,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: _T.surfaceBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'Back to home',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _T.inkDeep,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
