// import 'package:flutter/material.dart';
// import 'package:flutter_cas_app_main/src/features/student_quiz_page/data/quiz_manager.dart';
// import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/pages/quiz_screen.dart';
// import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';

// class QuizIntroScreenUpdated extends StatefulWidget {
//   final Map<String, dynamic> category;
//   final VoidCallback onComplete;

//   const QuizIntroScreenUpdated({
//     super.key,
//     required this.category,
//     required this.onComplete,
//   });

//   @override
//   State<QuizIntroScreenUpdated> createState() => _QuizIntroScreenUpdatedState();
// }

// class _QuizIntroScreenUpdatedState extends State<QuizIntroScreenUpdated> {
//   bool isLoading = false;
//   int remainingQuestions = 10;

//   @override
//   void initState() {
//     super.initState();
//     _loadRemainingQuestions();
//   }

//   Future<void> _loadRemainingQuestions() async {
//     final remaining = await QuizManager.instance.getRemainingQuestions(
//       widget.category['id'],
//     );
//     setState(() {
//       remainingQuestions = remaining;
//     });
//   }

//   Future<void> _startQuiz() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       // Check if user can attempt
//       final canAttempt = await QuizManager.instance.canAttemptQuiz(
//         widget.category['id'],
//       );

//       if (!canAttempt) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Daily limit reached for ${widget.category['title']}',
//               ),
//               backgroundColor: Colors.orange,
//             ),
//           );
//           Navigator.pop(context);
//         }
//         return;
//       }

//       // Fetch questions from Google Sheets
//       final questions = await QuizManager.instance.getDailyQuestions(
//         widget.category['id'],
//       );

//       if (questions.isEmpty) {
//         throw Exception('No questions available');
//       }

//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder:
//                 (c, a, sa) => QuizScreenUpdated(
//                   category: widget.category,
//                   questions: questions,
//                   onComplete: widget.onComplete,
//                 ),
//             transitionsBuilder:
//                 (c, a, sa, child) => FadeTransition(opacity: a, child: child),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $e'),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final gradientColors = widget.category['gradientColors'] as List<Color>;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFAFA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             padding: EdgeInsets.all(Responsive.wp(context, 2)),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF8F9FA),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: gradientColors[0],
//               size: Responsive.wp(context, 4.5),
//             ),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Quiz Overview',
//           style: TextStyle(
//             color: Color(0xFF1E293B),
//             fontWeight: FontWeight.w700,
//             fontSize: Responsive.sp(context, 18),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(Responsive.wp(context, 6)),
//           child: Column(
//             children: [
//               const Spacer(),
//               Container(
//                 padding: EdgeInsets.all(Responsive.wp(context, 10.5)),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: gradientColors),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: gradientColors[0].withOpacity(0.4),
//                       blurRadius: 40,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   widget.category['icon'],
//                   size: Responsive.wp(context, 21),
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: Responsive.hp(context, 4.5)),
//               Text(
//                 widget.category['title'],
//                 style: TextStyle(
//                   fontSize: Responsive.sp(context, 38),
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF1E293B),
//                   letterSpacing: -1,
//                 ),
//               ),
//               SizedBox(height: Responsive.hp(context, 1.5)),
//               Text(
//                 widget.category['description'],
//                 style: TextStyle(
//                   fontSize: Responsive.sp(context, 16),
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: Responsive.hp(context, 5)),
//               Container(
//                 padding: EdgeInsets.all(Responsive.wp(context, 6)),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.03),
//                       blurRadius: 20,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     _buildInfoRow(
//                       context,
//                       Icons.help_outline_rounded,
//                       'Questions Today',
//                       '$remainingQuestions',
//                       gradientColors,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: Responsive.hp(context, 2.2),
//                       ),
//                       child: const Divider(height: 1, thickness: 1),
//                     ),
//                     _buildInfoRow(
//                       context,
//                       Icons.schedule_rounded,
//                       'Time Per Question',
//                       '20 sec',
//                       gradientColors,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: Responsive.hp(context, 2.2),
//                       ),
//                       child: const Divider(height: 1, thickness: 1),
//                     ),
//                     _buildInfoRow(
//                       context,
//                       Icons.workspace_premium_rounded,
//                       'Points Available',
//                       '${remainingQuestions * 10}',
//                       gradientColors,
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               SizedBox(
//                 width: double.infinity,
//                 height: Responsive.hp(context, 7),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: gradientColors[0],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 0,
//                     shadowColor: Colors.transparent,
//                   ),
//                   onPressed: isLoading ? null : _startQuiz,
//                   child:
//                       isLoading
//                           ? SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.white,
//                               ),
//                             ),
//                           )
//                           : Text(
//                             'Start Quiz Now',
//                             style: TextStyle(
//                               fontSize: Responsive.sp(context, 17),
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(
//     BuildContext context,
//     IconData icon,
//     String label,
//     String value,
//     List<Color> gradientColors,
//   ) {
//     return Row(
//       children: [
//         Container(
//           padding: EdgeInsets.all(Responsive.wp(context, 3)),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: gradientColors),
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: [
//               BoxShadow(
//                 color: gradientColors[0].withOpacity(0.25),
//                 blurRadius: 10,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Icon(
//             icon,
//             color: Colors.white,
//             size: Responsive.wp(context, 5.5),
//           ),
//         ),
//         SizedBox(width: Responsive.wp(context, 4)),
//         Expanded(
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: Responsive.sp(context, 15),
//               color: Colors.grey[700],
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: Responsive.sp(context, 16),
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF1E293B),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/data/quiz_manager.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/pages/quiz_screen.dart';
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

class QuizIntroScreenUpdated extends StatefulWidget {
  final Map<String, dynamic> category;
  final VoidCallback onComplete;

  const QuizIntroScreenUpdated({
    super.key,
    required this.category,
    required this.onComplete,
  });

  @override
  State<QuizIntroScreenUpdated> createState() => _QuizIntroScreenUpdatedState();
}

class _QuizIntroScreenUpdatedState extends State<QuizIntroScreenUpdated> {
  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  bool isLoading = false;
  int remainingQuestions = 10;

  @override
  void initState() {
    super.initState();
    _loadRemainingQuestions();
  }

  Future<void> _loadRemainingQuestions() async {
    final remaining = await QuizManager.instance.getRemainingQuestions(
      widget.category['id'],
    );
    setState(() => remainingQuestions = remaining);
  }

  Future<void> _startQuiz() async {
    setState(() => isLoading = true);
    try {
      final canAttempt = await QuizManager.instance.canAttemptQuiz(
        widget.category['id'],
      );
      if (!canAttempt) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Daily limit reached for ${widget.category['title']}',
              ),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.pop(context);
        }
        return;
      }
      final questions = await QuizManager.instance.getDailyQuestions(
        widget.category['id'],
      );
      if (questions.isEmpty) throw Exception('No questions available');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (c, a, sa) => QuizScreenUpdated(
                  category: widget.category,
                  questions: questions,
                  onComplete: widget.onComplete,
                ),
            transitionsBuilder:
                (c, a, sa, child) => FadeTransition(opacity: a, child: child),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
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

    final gradientColors = widget.category['gradientColors'] as List<Color>;
    final accentColor = gradientColors[0];

    return Scaffold(
      backgroundColor: _T.pageBg,
      body: Column(
        children: [
          // ── Dark hero header ─────────────────────────────────────────
          _HeroHeader(
            category: widget.category,
            remainingQuestions: remainingQuestions,
            onBack: () => Navigator.of(context).pop(),
          ),

          // ── Scrollable body ──────────────────────────────────────────
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Stat cards
                SliverToBoxAdapter(
                  child: _StatRow(
                    remainingQuestions: remainingQuestions,
                    accentColor: accentColor,
                  ),
                ),

                // Rules section
                const SliverToBoxAdapter(child: _SectionLabel('Rules')),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _RuleItem(
                        icon: Icons.schedule_rounded,
                        title: '20 seconds',
                        subtitle: 'per question',
                      ),
                      const SizedBox(height: 8),
                      _RuleItem(
                        icon: Icons.stars_rounded,
                        title: '10 points',
                        subtitle: 'per correct answer',
                      ),
                      const SizedBox(height: 8),
                      _RuleItem(
                        icon: Icons.block_rounded,
                        title: 'No skipping',
                        subtitle: 'every question counts',
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // ── Start button pinned at bottom ────────────────────────────
          _StartButton(isLoading: isLoading, onTap: _startQuiz),
        ],
      ),
    );
  }
}

// ── Hero header ───────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  final Map<String, dynamic> category;
  final int remainingQuestions;
  final VoidCallback onBack;
  const _HeroHeader({
    required this.category,
    required this.remainingQuestions,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      color: _T.heroBg,
      padding: EdgeInsets.fromLTRB(22, topPad + 20, 22, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Category label
          Text(
            (category['title'] as String).toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Color(0x73FFFFFF),
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'Quiz Overview',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              height: 1.15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroChip(label: '$remainingQuestions questions'),
              const _HeroChip(label: '20 sec each'),
              _HeroChip(label: '${remainingQuestions * 10} pts available'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;
  const _HeroChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xBFFFFFFF),
        ),
      ),
    );
  }
}

// ── Stat row ──────────────────────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  final int remainingQuestions;
  final Color accentColor;
  const _StatRow({required this.remainingQuestions, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Questions',
              value: '$remainingQuestions',
              sub: 'today\'s set',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              label: 'Points',
              value: '${remainingQuestions * 10}',
              sub: 'available',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
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
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: _T.inkDeep,
            ),
          ),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 11, color: _T.inkFaint)),
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

// ── Rule item ─────────────────────────────────────────────────────────────────

class _RuleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _RuleItem({
    required this.icon,
    required this.title,
    required this.subtitle,
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
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _T.surfaceBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Icon(icon, size: 17, color: _T.inkMid)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _T.inkDeep,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: _T.inkSoft),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Start button ──────────────────────────────────────────────────────────────

class _StartButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _StartButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 12 + bottomPad),
      color: _T.pageBg,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: isLoading ? const Color(0xFF555555) : _T.heroBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Text(
                      'Start quiz now',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
