// import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/model/assignment_model.dart';
// import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/widgets/assignment_cards.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart'; // Import AppColors

// class AssignmentsListPage extends StatefulWidget {
//   const AssignmentsListPage({super.key});

//   @override
//   State<AssignmentsListPage> createState() => _AssignmentsListPageState();
// }

// class _AssignmentsListPageState extends State<AssignmentsListPage> {
//   String _searchQuery = '';

//   List<Assignment> get _filteredAssignments {
//     if (_searchQuery.isEmpty) {
//       return AssignmentsData.allAssignments;
//     }
//     return AssignmentsData.allAssignments.where((assignment) {
//       return assignment.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//              assignment.subject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//              assignment.difficulty.toLowerCase().contains(_searchQuery.toLowerCase());
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final horizontalPadding = size.width * 0.05;
//     final titleFontSize = size.width * 0.07;
//     final searchFontSize = size.width * 0.04;
//     final iconSize = size.width * 0.065;
//     final backButtonPadding = size.width * 0.04;

//     return Scaffold(
//       backgroundColor: const Color(0xFFE2E2E2),
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           physics: const BouncingScrollPhysics(),
//           children: [
//             // Enhanced Header Section
//             Container(
//               margin: EdgeInsets.symmetric(
//                 horizontal: horizontalPadding * 0.8,
//                 vertical: size.height * 0.02,
//               ),
//               child: Neumorphic(
//                 style: NeumorphicStyle(
//                   depth: 8,
//                   intensity: 0.65,
//                   boxShape: NeumorphicBoxShape.roundRect(
//                     BorderRadius.circular(size.width * 0.06),
//                   ),
//                   color: const Color(0xFFE2E2E2),
//                 ),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: horizontalPadding * 1.2,
//                     vertical: size.height * 0.025,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(size.width * 0.06),
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         const Color(0xFFE2E2E2).withOpacity(0.9),
//                         const Color(0xFFD5D5D5).withOpacity(0.8),
//                       ],
//                     ),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       FadeInDown(
//                         delay: const Duration(milliseconds: 300),
//                         child: NeumorphicButton(
//                           onPressed: () {
//                             Navigator.of(context).maybePop();
//                           },
//                           style: NeumorphicStyle(
//                             boxShape: const NeumorphicBoxShape.circle(),
//                             depth: 6,
//                             intensity: 0.8,
//                             shape: NeumorphicShape.flat,
//                             color: const Color(0xFFE2E2E2),
//                           ),
//                           padding: EdgeInsets.all(backButtonPadding),
//                           child: Icon(
//                             Icons.arrow_back_ios_new,
//                             size: iconSize,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: size.width * 0.04),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             FadeInDown(
//                               delay: const Duration(milliseconds: 400),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: size.width * 0.01,
//                                     height: titleFontSize * 0.65,
//                                     decoration: BoxDecoration(
//                                       color: AppColors.primaryDark, // Using AppColors
//                                       borderRadius: BorderRadius.circular(size.width * 0.01),
//                                     ),
//                                   ),
//                                   SizedBox(width: size.width * 0.025),
//                                   Text(
//                                     'Explore',
//                                     style: TextStyle(
//                                       fontSize: titleFontSize * 0.5,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black54,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: size.height * 0.008),
//                             FadeInDown(
//                               delay: const Duration(milliseconds: 500),
//                               child: ShaderMask(
//                                 shaderCallback: (bounds) => LinearGradient(
//                                   colors: [
//                                     AppColors.primary,      // Using AppColors
//                                     AppColors.primaryDark,  // Using AppColors
//                                   ],
//                                 ).createShader(bounds),
//                                 child: Text(
//                                   'Assignments',
//                                   style: TextStyle(
//                                     fontSize: titleFontSize * 1.1,
//                                     fontWeight: FontWeight.w900,
//                                     color: Colors.white,
//                                     letterSpacing: -0.5,
//                                     height: 1.1,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: size.height * 0.02),

//             // Search Bar
//             FadeInDown(
//               delay: const Duration(milliseconds: 400),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: horizontalPadding,
//                   vertical: size.height * 0.01,
//                 ),
//                 child: Neumorphic(
//                   style: NeumorphicStyle(
//                     depth: -4,
//                     intensity: 0.8,
//                     boxShape: NeumorphicBoxShape.roundRect(
//                       BorderRadius.circular(size.width * 0.075),
//                     ),
//                     color: const Color(0xFFE2E2E2),
//                   ),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: TextField(
//                       style: TextStyle(
//                         color: Colors.black87,
//                         fontSize: searchFontSize,
//                       ),
//                       decoration: InputDecoration(
//                         hintText: 'Search assignments...',
//                         hintStyle: TextStyle(
//                           color: Colors.black54,
//                           fontSize: searchFontSize,
//                         ),
//                         prefixIcon: Icon(
//                           Icons.search,
//                           color: Colors.black54,
//                           size: iconSize,
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: size.height * 0.017,
//                         ),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           _searchQuery = value;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: size.height * 0.04),

//             // Assignment Cards List - Using real data
//             ..._filteredAssignments.asMap().entries.map((entry) {
//               final index = entry.key;
//               final assignment = entry.value;

//               return Padding(
//                 padding: EdgeInsets.only(
//                   left: horizontalPadding * 0.5,
//                   right: horizontalPadding * 0.5,
//                   bottom: size.height * 0.03,
//                 ),
//                 child: FadeInUp(
//                   duration: Duration(milliseconds: 500 + (index * 120)),
//                   child: AssignmentCard(
//                     assignmentId: assignment.id,
//                     title: assignment.title,
//                     extraDetail: assignment.questionCount,
//                     subject: assignment.subject,
//                     difficulty: assignment.difficulty,
//                   ),
//                 ),
//               );
//             }),

//             // Bottom Padding
//             SizedBox(height: size.height * 0.02),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/model/assignment_model.dart';
import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/widgets/assignment_cards.dart';

// ── Design tokens ────────────────────────────────────────────────────────────

class _T {
  static const pageBg = Color(0xFFF5F5F5);
  static const cardBg = Color(0xFFFFFFFF);
  static const surfaceBg = Color(0xFFEAEAEA);
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

// ── Difficulty filter chip list ──────────────────────────────────────────────

const _kFilters = ['All'];

// ── Page ─────────────────────────────────────────────────────────────────────

class AssignmentsListPage extends StatefulWidget {
  const AssignmentsListPage({super.key});

  @override
  State<AssignmentsListPage> createState() => _AssignmentsListPageState();
}

class _AssignmentsListPageState extends State<AssignmentsListPage> {
  // ── LOGIC UNCHANGED ──────────────────────────────────────────────────────
  String _searchQuery = '';

  List<Assignment> get _filteredAssignments {
    if (_searchQuery.isEmpty) {
      return AssignmentsData.allAssignments;
    }
    return AssignmentsData.allAssignments.where((assignment) {
      return assignment.title.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          assignment.subject.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          assignment.difficulty.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }
  // ── END LOGIC ─────────────────────────────────────────────────────────────

  // UI-only state
  String _activeFilter = 'All';

  List<Assignment> get _displayedAssignments {
    final base = _filteredAssignments;
    if (_activeFilter == 'All') return base;
    return base
        .where((a) => a.difficulty.toLowerCase() == _activeFilter.toLowerCase())
        .toList();
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
      backgroundColor: _T.pageBg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: FadeInDown(
                duration: const Duration(milliseconds: 400),
                child: _Header(onBack: () => Navigator.of(context).maybePop()),
              ),
            ),

            // ── Search ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: FadeInDown(
                duration: const Duration(milliseconds: 420),
                delay: const Duration(milliseconds: 60),
                child: _SearchBar(
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
            ),

            // ── Filter chips ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: FadeInDown(
                duration: const Duration(milliseconds: 420),
                delay: const Duration(milliseconds: 120),
                child: _FilterChips(
                  active: _activeFilter,
                  onSelect: (f) => setState(() => _activeFilter = f),
                ),
              ),
            ),

            // ── Section meta row ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: _SectionMeta(count: _displayedAssignments.length),
            ),

            // ── Assignment cards ─────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final assignment = _displayedAssignments[index];
                  return FadeInUp(
                    duration: Duration(milliseconds: 400 + (index * 80)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      // ── LOGIC UNCHANGED: AssignmentCard widget ──
                      child: AssignmentCard(
                        assignmentId: assignment.id,
                        title: assignment.title,
                        extraDetail: assignment.questionCount,
                        subject: assignment.subject,
                        difficulty: assignment.difficulty,
                      ),
                    ),
                  );
                }, childCount: _displayedAssignments.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button
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
          // Title block
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACADEMIC',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: _T.inkSoft,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Assignments',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    height: 1.0,
                    color: _T.inkDeep,
                  ),
                ),
              ],
            ),
          ),
          // Avatar placeholder
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: _T.surfaceBg,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'SA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _T.inkMid,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _T.surfaceBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, size: 18, color: _T.inkSoft),
            const SizedBox(width: 9),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: const TextStyle(fontSize: 14, color: _T.inkDeep),
                decoration: const InputDecoration(
                  hintText: 'Search by title, subject…',
                  hintStyle: TextStyle(fontSize: 14, color: _T.inkSoft),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter chips ──────────────────────────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  final String active;
  final ValueChanged<String> onSelect;
  const _FilterChips({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
        itemCount: _kFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (_, i) {
          final f = _kFilters[i];
          final isOn = f == active;
          return GestureDetector(
            onTap: () => onSelect(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isOn ? _T.inkDeep : _T.surfaceBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isOn ? const Color(0xFFF5F5F5) : _T.inkMid,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Section meta row ──────────────────────────────────────────────────────────

class _SectionMeta extends StatelessWidget {
  final int count;
  const _SectionMeta({required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TASKS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: _T.inkSoft,
            ),
          ),
          Text(
            '$count assignment${count == 1 ? '' : 's'}',
            style: const TextStyle(fontSize: 12, color: _T.inkFaint),
          ),
        ],
      ),
    );
  }
}

// ── Difficulty badge helper (used by AssignmentCard widget internally) ─────────

Color assignmentDiffBadgeBg(String diff) {
  switch (diff.toLowerCase()) {
    case 'easy':
      return _T.badgeEasyBg;
    case 'medium':
      return _T.badgeMedBg;
    case 'hard':
      return _T.badgeHardBg;
    default:
      return _T.badgeNeutralBg;
  }
}

Color assignmentDiffBadgeFg(String diff) {
  switch (diff.toLowerCase()) {
    case 'easy':
      return _T.badgeEasyFg;
    case 'medium':
      return _T.badgeMedFg;
    case 'hard':
      return _T.badgeHardFg;
    default:
      return _T.badgeNeutralFg;
  }
}
