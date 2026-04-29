// import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/model/assignment_model.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
// import 'package:animate_do/animate_do.dart';

// class AssignmentDetailPage extends StatelessWidget {
//   final String assignmentId;

//   const AssignmentDetailPage({
//     super.key,
//     required this.assignmentId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Get the assignment data
//     final assignment = AssignmentsData.getAssignmentById(assignmentId);

//     // Handle case where assignment is not found
//     if (assignment == null) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFE2E2E2),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 size: 80,
//                 color: Colors.black38,
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Assignment not found',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black54,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     final size = MediaQuery.of(context).size;
//     final horizontalPadding = size.width * 0.05;
//     final titleFontSize = size.width * 0.08;
//     final subtitleFontSize = size.width * 0.032;
//     final contentFontSize = size.width * 0.038;
//     final buttonFontSize = size.width * 0.045;
//     final backButtonSize = size.width * 0.042;

//     return Scaffold(
//       backgroundColor: const Color(0xFFE2E2E2),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SafeArea(
//             bottom: false,
//             child: FadeInDown(
//               duration: const Duration(milliseconds: 400),
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(
//                   horizontalPadding,
//                   size.height * 0.02,
//                   horizontalPadding,
//                   size.height * 0.01,
//                 ),
//                 child: Row(
//                   children: [
//                     // Neumorphic Back Button
//                     NeumorphicButton(
//                       onPressed: () {
//                         Navigator.of(context).maybePop();
//                       },
//                       style: const NeumorphicStyle(
//                         shape: NeumorphicShape.flat,
//                         boxShape: NeumorphicBoxShape.circle(),
//                         depth: 8,
//                         intensity: 0.8,
//                       ),
//                       padding: EdgeInsets.all(size.width * 0.04),
//                       child: Icon(
//                         Icons.arrow_back_ios_new,
//                         size: backButtonSize,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(width: size.width * 0.05),
//                     // Title Section
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             assignment.title,
//                             style: TextStyle(
//                               fontSize: titleFontSize,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.black87,
//                               letterSpacing: -0.5,
//                             ),
//                           ),
//                           SizedBox(height: size.height * 0.003),
//                           Wrap(
//                             spacing: size.width * 0.02,
//                             runSpacing: size.height * 0.008,
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: size.width * 0.025,
//                                   vertical: size.height * 0.005,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black87.withOpacity(0.08),
//                                   borderRadius: BorderRadius.circular(
//                                     size.width * 0.03,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   assignment.questionCount,
//                                   style: TextStyle(
//                                     fontSize: subtitleFontSize,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: size.width * 0.025,
//                                   vertical: size.height * 0.005,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black87.withOpacity(0.08),
//                                   borderRadius: BorderRadius.circular(
//                                     size.width * 0.03,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   assignment.difficulty,
//                                   style: TextStyle(
//                                     fontSize: subtitleFontSize,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: size.width * 0.025,
//                                   vertical: size.height * 0.005,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black87.withOpacity(0.08),
//                                   borderRadius: BorderRadius.circular(
//                                     size.width * 0.03,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   assignment.subject,
//                                   style: TextStyle(
//                                     fontSize: subtitleFontSize,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           SizedBox(height: size.height * 0.02),

//           // Content Section with Enhanced Design
//           Expanded(
//             child: FadeInUp(
//               duration: const Duration(milliseconds: 500),
//               delay: const Duration(milliseconds: 200),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 padding: EdgeInsets.symmetric(
//                   horizontal: horizontalPadding,
//                   vertical: size.height * 0.01,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Main Content Card with Neumorphic Design
//                     Neumorphic(
//                       style: NeumorphicStyle(
//                         depth: -6,
//                         intensity: 0.85,
//                         surfaceIntensity: 0.4,
//                         boxShape: NeumorphicBoxShape.roundRect(
//                           BorderRadius.circular(size.width * 0.06),
//                         ),
//                         color: const Color(0xFFE2E2E2),
//                         lightSource: LightSource.topLeft,
//                         shape: NeumorphicShape.concave,
//                       ),
//                       child: Container(
//                         padding: EdgeInsets.all(size.width * 0.06),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Section Header
//                             Row(
//                               children: [
//                                 Container(
//                                   width: size.width * 0.01,
//                                   height: size.height * 0.03,
//                                   decoration: BoxDecoration(
//                                     color: Colors.black87,
//                                     borderRadius: BorderRadius.circular(
//                                       size.width * 0.005,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: size.width * 0.03),
//                                 Text(
//                                   "Assignment Overview",
//                                   style: TextStyle(
//                                     fontSize: buttonFontSize,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.black87,
//                                     letterSpacing: -0.3,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: size.height * 0.025),

//                             // All Questions List
//                             ...List.generate(assignment.questions.length, (index) {
//                               return _buildQuestionItem(
//                                 context,
//                                 "${index + 1}",
//                                 assignment.questions[index],
//                                 contentFontSize,
//                               );
//                             }),
//                           ],
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: size.height * 0.03),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           SizedBox(height: size.height * 0.03),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestionItem(
//     BuildContext context,
//     String number,
//     String question,
//     double fontSize,
//   ) {
//     final size = MediaQuery.of(context).size;

//     return Padding(
//       padding: EdgeInsets.only(bottom: size.height * 0.02),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Question Number Badge
//           Container(
//             width: size.width * 0.08,
//             height: size.width * 0.08,
//             decoration: BoxDecoration(
//               color: Colors.black87.withOpacity(0.08),
//               borderRadius: BorderRadius.circular(size.width * 0.025),
//             ),
//             child: Center(
//               child: Text(
//                 number,
//                 style: TextStyle(
//                   fontSize: fontSize * 0.93,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: size.width * 0.035),
//           // Question Text
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(top: size.height * 0.005),
//               child: Text(
//                 question,
//                 style: TextStyle(
//                   fontSize: fontSize,
//                   height: 1.5,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/model/assignment_model.dart';

// ── Design tokens (shared with list page — move to a shared file if preferred)

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

  static const badgeEasyBg = Color(0xFFE6F5EB);
  static const badgeEasyFg = Color(0xFF27500A);
  static const badgeMedBg = Color(0xFFFAEEDA);
  static const badgeMedFg = Color(0xFF633806);
  static const badgeHardBg = Color(0xFFFCEBEB);
  static const badgeHardFg = Color(0xFF791F1F);
  static const badgeNeutralBg = Color(0xFFF0F0F0);
  static const badgeNeutralFg = Color(0xFF666666);
}

// ── Page ──────────────────────────────────────────────────────────────────────

class AssignmentDetailPage extends StatelessWidget {
  final String assignmentId;

  const AssignmentDetailPage({super.key, required this.assignmentId});

  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final assignment = AssignmentsData.getAssignmentById(assignmentId);

    if (assignment == null) {
      return const _NotFoundScreen();
    }
    // ── END LOGIC ─────────────────────────────────────────────────────────

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: _T.pageBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Dark hero header ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeInDown(
              duration: const Duration(milliseconds: 380),
              child: _HeroHeader(
                assignment: assignment,
                onBack: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),

          // ── Stat cards ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeInUp(
              duration: const Duration(milliseconds: 380),
              delay: const Duration(milliseconds: 100),
              child: _StatRow(assignment: assignment),
            ),
          ),

          // ── Questions section header ────────────────────────────────────
          const SliverToBoxAdapter(child: _QuestionsLabel()),

          // ── Question items ─────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => FadeInUp(
                  duration: Duration(milliseconds: 350 + (index * 60)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _QuestionItem(
                      number: index + 1,
                      text: assignment.questions[index],
                    ),
                  ),
                ),
                childCount: assignment.questions.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero header (dark slab) ───────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onBack;
  const _HeroHeader({required this.assignment, required this.onBack});

  Color get _subjectColor {
    switch (assignment.subject) {
      case 'Mathematics':
        return const Color(0xFF27500A);
      case 'Physics':
        return const Color(0xFF0C447C);
      case 'Chemistry':
        return const Color(0xFF712B13);
      default:
        return const Color(0xFF3C3489);
    }
  }

  (Color, Color) get _diffColors {
    switch (assignment.difficulty.toLowerCase()) {
      case 'easy':
        return (_T.badgeEasyBg, _T.badgeEasyFg);
      case 'medium':
        return (_T.badgeMedBg, _T.badgeMedFg);
      case 'hard':
        return (_T.badgeHardBg, _T.badgeHardFg);
      default:
        return (_T.badgeNeutralBg, _T.badgeNeutralFg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final (diffBg, diffFg) = _diffColors;

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

          // Subject label
          Text(
            assignment.subject.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Colors.white.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 8),

          // Assignment title
          Text(
            assignment.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              height: 1.15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Chips row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroChip(label: assignment.difficulty, bg: diffBg, fg: diffFg),
              _HeroChip(
                label: assignment.questionCount,
                bg: Colors.white.withOpacity(0.1),
                fg: Colors.white.withOpacity(0.75),
              ),
              _HeroChip(
                label: assignment.subject,
                bg: _subjectColor.withOpacity(0.25),
                fg: Colors.white.withOpacity(0.85),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _HeroChip({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

// ── Stat row (2 metric cards) ─────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  final Assignment assignment;
  const _StatRow({required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Questions',
              value: assignment.questions.length.toString(),
              sub: 'total tasks',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              label: 'Difficulty',
              value: assignment.difficulty,
              sub: assignment.subject,
              valueFontSize: 20,
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
  final double valueFontSize;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    this.valueFontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _T.divider, width: 1),
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
              fontSize: valueFontSize,
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

// ── Questions section label ───────────────────────────────────────────────────

class _QuestionsLabel extends StatelessWidget {
  const _QuestionsLabel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: _T.divider)),
          const SizedBox(width: 10),
          const Text(
            'QUESTIONS',
            style: TextStyle(
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

// ── Individual question item ──────────────────────────────────────────────────

class _QuestionItem extends StatelessWidget {
  final int number;
  final String text;
  const _QuestionItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _T.divider, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: _T.surfaceBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _T.inkMid,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Question text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.55,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Not-found screen ──────────────────────────────────────────────────────────

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _T.pageBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: _T.surfaceBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_late_outlined,
                size: 32,
                color: _T.inkSoft,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Assignment not found',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: _T.inkMid,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'This assignment may have been removed.',
              style: TextStyle(fontSize: 13, color: _T.inkSoft),
            ),
          ],
        ),
      ),
    );
  }
}
