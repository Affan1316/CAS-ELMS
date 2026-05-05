// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/student_workshop_time_tracker/data/student_data.dart';
// import 'package:intl/intl.dart';
// import 'package:responsive_ui_kit/responsive_ui_kit.dart';

// import '../../../../core/theme/app_colors.dart';
// import '../../data/dummy_data.dart';
// import '../bloc/time_graph_page_bloc.dart';
// import '../widgets/average_time_container.dart';
// import '../widgets/bar_graph_data.dart';
// import '../widgets/info_card.dart';
// import '../widgets/my_appbar.dart';
// import '../widgets/my_choice_chip.dart';
// import '../widgets/shadow_container.dart';
// import '../widgets/title_text.dart';

// class StudentTimeTrackerPage extends StatefulWidget {
//   const StudentTimeTrackerPage({super.key, required this.rollNo});
//   final String rollNo;

//   @override
//   State<StudentTimeTrackerPage> createState() => _StudentTimeTrackerPageState();
// }

// typedef DummyStudent =
//     ({String name, String courseName, String batchName, String? rollno});

// class _StudentTimeTrackerPageState extends State<StudentTimeTrackerPage> {
//   DateTimeRange? _selectedDateRange;
//   String selectedFilter = 'This Week';

//   //TODO: add real but its dummy Student DAta
//   DummyStudent studentData = (
//     name: "...",
//     courseName: "Flutter",
//     batchName: "...",
//     rollno: "...",
//   );
//   final double studentMaxHours = 8;

//   update(String? rollNo) async {
//     getStudentData(givenNullableRollno: rollNo).then((value) {
//       setState(() {
//         value != null ? studentData = value : studentData;
//       });
//     });
//   }

//   // Add this getter method to calculate max hours
//   double maxHours(List<DailyStudyData> filteredStudyData) {
//     if (filteredStudyData.isEmpty) return studentMaxHours;

//     double maxValue = filteredStudyData
//         .map((data) => data.hours)
//         .reduce((a, b) => a > b ? a : b);

//     // Add some padding (10%) to the max value
//     return (maxValue * 1.1).ceilToDouble().clamp(
//       studentMaxHours * 0.5,
//       double.infinity,
//     );
//   }

//   // Filter options
//   final Map<String, List<DailyStudyData>> _filterOptions = {
//     // First 7 days (this week)
//     'Last Week': studyData['Last Week']!.toList(), // Next 7 days (last week)
//     'This Month': studyData['This Month']!.toList(), // All data (this month)
//     'Custom': [],
//   };

//   Future<void> _selectDateRange(BuildContext context) async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2010),
//       lastDate: DateTime.now(),
//       currentDate: DateTime.now(),
//       saveText: 'Apply',
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.primary,
//               onPrimary: Colors.white,
//               surface: const Color(0xFFE6E9EF),
//               onSurface: const Color(0xFF3D4C5F),
//             ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null && picked != _selectedDateRange) {
//       if (context.mounted) {
//         context.read<TimeGraphPageBloc>().add(
//           SelectiveRangeEvent(dateRange: picked, rollNo: widget.rollNo),
//         );
//       }

//       // setState(() {
//       //   _selectedDateRange = picked;
//       //   _selectedFilter = 'Custom';
//       // });
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     context.read<TimeGraphPageBloc>().add(ThisWeekEvent(rollNo: widget.rollNo));
//     update(widget.rollNo);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE6E9EF),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               MyAppbar(studentName: studentData.name),
//               const SizedBox(height: 24),
//               const TitleText(data: 'Student Info'),
//               StudentInfoCard(student: studentData),

//               // Date range selector
//               const TitleText(data: 'Select Time Range'),
//               const SizedBox(height: 12),
//               MyChoiceChips(selectedFilter: selectedFilter,rollNo: widget.rollNo,),
//               const SizedBox(height: 12),
//               InkWell(
//                 onTap: () => _selectDateRange(context),
//                 child: ShadowedContainer(
//                   // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.calendar_today,
//                         size: 18,
//                         color: AppColors.primary,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         _selectedDateRange != null
//                             ? '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}'
//                             : 'Select Custom Date Range',
//                         style: const TextStyle(
//                           color: Color(0xFF3D4C5F),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const TitleText(data: 'Study Hours'),

//               // Neumorphic chart container
//               SizedBox(
//                 height: context.height * 0.45,
//                 child: ShadowedContainer(
//                   child: BlocConsumer<TimeGraphPageBloc, TimeGraphPageState>(
//                     bloc: context.read<TimeGraphPageBloc>(),
//                     listener: (context, state) {},
//                     builder: (context, state) {
//                       if (state is TimeGraphPageLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (state is TimeGraphPageLoaded) {
//                         var studentData = state.studentData;
//                         return studentData.isNotEmpty
//                             ? BarChart(
//                               BarChartData(
//                                 borderData: FlBorderData(show: false),
//                                 barGroups: generateBarGroups(studentData),
//                                 alignment: BarChartAlignment.spaceAround,
//                                 maxY: maxHours(studentData),
//                                 minY: 0,
//                                 groupsSpace: 16,
//                                 barTouchData: BarTouchData(
//                                   enabled: true,
//                                   touchTooltipData: BarTouchTooltipData(
//                                     getTooltipItem: (
//                                       group,
//                                       groupIndex,
//                                       rod,
//                                       rodIndex,
//                                     ) {
//                                       final data =
//                                           state.studentData[group.x.toInt()];
//                                       return BarTooltipItem(
//                                         '${data.hours} hrs\n${DateFormat('MMM d').format(data.date)}',
//                                         TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 titlesData: FlTitlesData(
//                                   show: true,
//                                   bottomTitles: AxisTitles(
//                                     sideTitles: SideTitles(
//                                       showTitles: true,
//                                       getTitlesWidget: (
//                                         double value,
//                                         TitleMeta meta,
//                                       ) {
//                                         final index = value.toInt();
//                                         if (index >= 0 &&
//                                             index < studentData.length) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(
//                                               top: 8.0,
//                                             ),
//                                             child: Text(
//                                               selectedFilter == 'Custom'
//                                                   ? DateFormat('MMM d').format(
//                                                     state
//                                                         .studentData[index]
//                                                         .date,
//                                                   )
//                                                   : state
//                                                       .studentData[index]
//                                                       .day,
//                                               style: const TextStyle(
//                                                 color: Color(0xFF3D4C5F),
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           );
//                                         }
//                                         return const Text('');
//                                       },
//                                     ),
//                                   ),
//                                   leftTitles: AxisTitles(
//                                     sideTitles: SideTitles(
//                                       showTitles: true,
//                                       getTitlesWidget: (
//                                         double value,
//                                         TitleMeta meta,
//                                       ) {
//                                         if (value == meta.min ||
//                                             value == meta.max) {
//                                           return const Text('');
//                                         }
//                                         return Text(
//                                           value.toInt().toString(),
//                                           style: const TextStyle(
//                                             color: Color(0xFF3D4C5F),
//                                             fontSize: 12,
//                                           ),
//                                         );
//                                       },
//                                       reservedSize: 28,
//                                     ),
//                                   ),
//                                   rightTitles: AxisTitles(
//                                     sideTitles: SideTitles(showTitles: false),
//                                   ),
//                                   topTitles: AxisTitles(
//                                     sideTitles: SideTitles(showTitles: false),
//                                   ),
//                                 ),
//                                 gridData: FlGridData(
//                                   show: true,
//                                   drawVerticalLine: false,
//                                   horizontalInterval:
//                                       maxHours(studentData) > 10 ? 2 : 1,
//                                   getDrawingHorizontalLine: (value) {
//                                     return FlLine(
//                                       color: const Color(0xFFD1D9E6),
//                                       strokeWidth: 1.5,
//                                     );
//                                   },
//                                 ),
//                               ),
//                             )
//                             : const Center(
//                               child: Text(
//                                 'No data available for selected range',
//                                 style: TextStyle(
//                                   color: Color(0xFF3D4C5F),
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             );
//                       } else if (state is TimeGraphPageErrorState) {
//                         return Center(child: Text(state.message));
//                       } else {
//                         return const Center(
//                           child: Text("Something went wrong"),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Summary section
//               Builder(
//                 builder: (context) {
//                   var totalHours =
//                       context.watch<TimeGraphPageBloc>().totalHours;
//                   var averageHours =
//                       context.watch<TimeGraphPageBloc>().averageHours;
//                   return AverageTimeContainer(
//                     totalHours: totalHours,
//                     averageHours: averageHours,
//                   );
//                 },
//               ),
//               const SizedBox(height: 26),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// student_time_tracker_page.dart
//
// Design: "Morning Edition" — matches home + profile page system exactly.
// All original widget logic absorbed inline:
//   MyAppbar          → _NavBar + _StudentIdentity
//   StudentInfoCard   → _StudentIdentity (_InfoSection rows)
//   MyChoiceChips     → _TimeRangeChips  (fires ThisWeekEvent / LastWeekEvent / SelectiveRangeEvent)
//   ShadowedContainer → sand Container
//   AverageTimeContainer → _SummaryRow   (reads totalHours / averageHours from BLoC)
//   generateBarGroups → _ChartCard._buildGroups (warm-tone color mapping)
//   TitleText         → _label() helper

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_workshop_time_tracker/data/student_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../bloc/time_graph_page_bloc.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PALETTE
// ══════════════════════════════════════════════════════════════════════════════

class _P {
  static const pageBg = Color(0xFFF9F7F4);
  static const inkDeep = Color(0xFF1C1A17);
  static const inkMid = Color(0xFF5A5550);
  static const inkSoft = Color(0xFF8C8680);
  static const inkFaint = Color(0xFFB5B0A8);
  static const divider = Color(0xFFDDD9D3);
  static const sand = Color(0xFFEDE9E4);
  static const sandBed = Color(0xFFC8BCA8);
  static const sandStroke = Color(0xFF6B5C44);
  static const sageBed = Color(0xFFB5CDB9);
  static const sageStroke = Color(0xFF3B6B44);
  static const lavBed = Color(0xFFC8B5CF);
  static const lavStroke = Color(0xFF5B3D6B);
  // Bar intensity tones
  static const barHigh = Color(0xFF1C1A17);
  static const barMid = Color(0xFFC8BCA8);
  static const barLow = Color(0xFFDDD9D3);
}

// ══════════════════════════════════════════════════════════════════════════════
// TYPE ALIAS — mirrors original
// ══════════════════════════════════════════════════════════════════════════════

typedef DummyStudent =
    ({String name, String courseName, String batchName, String? rollno});

// ══════════════════════════════════════════════════════════════════════════════
// PAGE
// ══════════════════════════════════════════════════════════════════════════════

class StudentTimeTrackerPage extends StatefulWidget {
  const StudentTimeTrackerPage({super.key, required this.rollNo});
  final String rollNo;

  @override
  State<StudentTimeTrackerPage> createState() => _StudentTimeTrackerPageState();
}

class _StudentTimeTrackerPageState extends State<StudentTimeTrackerPage>
    with SingleTickerProviderStateMixin {
  // ── State (original) ─────────────────────────────────────────────────────
  DateTimeRange? _selectedDateRange;
  String selectedFilter = 'This Week';

  DummyStudent studentData = (
    name: '...',
    courseName: 'Flutter',
    batchName: '...',
    rollno: '...',
  );
  final double studentMaxHours = 8;

  // ── Filter map (original) ─────────────────────────────────────────────────
  final Map<String, List<DailyStudyData>> _filterOptions = {
    'Last Week': studyData['Last Week']!.toList(),
    'Custom': [],
  };

  // ── Entrance animation ────────────────────────────────────────────────────
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _lift;

  // ── Helpers (original logic) ──────────────────────────────────────────────
  Future<void> update(String? rollNo) async {
    final value = await getStudentData(givenNullableRollno: rollNo);
    if (mounted)
      setState(() {
        if (value != null) studentData = value;
      });
  }

  double maxHours(List<DailyStudyData> data) {
    if (data.isEmpty) return studentMaxHours;
    final maxVal = data.map((d) => d.hours).reduce((a, b) => a > b ? a : b);
    return (maxVal * 1.1).ceilToDouble().clamp(
      studentMaxHours * 0.5,
      double.infinity,
    );
  }

  // ── Date range picker (original logic) ───────────────────────────────────
  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'Apply',
      builder:
          (context, child) => Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                surface: const Color(0xFFE6E9EF),
                onSurface: const Color(0xFF3D4C5F),
              ),
              dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
            ),
            child: child!,
          ),
    );
    if (picked != null && picked != _selectedDateRange) {
      if (picked.duration.inDays > 10) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Date range cannot exceed 10 days'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        return;
      }
      setState(() {
        _selectedDateRange = picked;
        selectedFilter = 'Custom';
      });
      if (context.mounted) {
        context.read<TimeGraphPageBloc>().add(
          SelectiveRangeEvent(dateRange: picked, rollNo: widget.rollNo),
        );
      }
    }
  }

  // ── Chip handler — fires original BLoC events ─────────────────────────────
  void _onChipTap(String filter) {
    if (filter == 'Custom') {
      _selectDateRange(context);
      return;
    }
    setState(() {
      selectedFilter = filter;
      _selectedDateRange = null;
    });
    switch (filter) {
      case 'This Week':
        context.read<TimeGraphPageBloc>().add(
          ThisWeekEvent(rollNo: widget.rollNo),
        );
      case 'Last Week':
        context.read<TimeGraphPageBloc>().add(
          LastWeekEvent(rollNo: widget.rollNo),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    // ── BLoC: unchanged ───────────────────────────────────────────────────
    context.read<TimeGraphPageBloc>().add(ThisWeekEvent(rollNo: widget.rollNo));
    update(widget.rollNo);

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
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

  // ── Section label (replaces TitleText) ───────────────────────────────────
  SliverToBoxAdapter _label(String text) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w500,
          color: _P.inkSoft,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: _P.pageBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _lift,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ① Nav bar
                SliverToBoxAdapter(child: _NavBar()),
                const SliverToBoxAdapter(
                  child: Divider(height: 1, thickness: 0.8, color: _P.divider),
                ),

                // ② Student identity — name + info rows (MyAppbar + StudentInfoCard)
                SliverToBoxAdapter(
                  child: _StudentIdentity(student: studentData),
                ),
                SliverToBoxAdapter(child: _DoubleRule()),

                // ③ Time range chips (MyChoiceChips + custom date button)
                _label('Time range'),
                SliverToBoxAdapter(
                  child: _TimeRangeChips(
                    selected: selectedFilter,
                    selectedRange: _selectedDateRange,
                    onTap: _onChipTap,
                  ),
                ),

                // ④ Chart card (ShadowedContainer + BarChart + generateBarGroups)
                _label('Study hours'),
                SliverToBoxAdapter(
                  child: _ChartCard(
                    selectedFilter: selectedFilter,
                    maxHours: maxHours,
                  ),
                ),

                // ⑤ Summary (AverageTimeContainer)
                _label('Summary'),
                SliverToBoxAdapter(child: _SummaryRow()),

                // ⑥ Custom date range button — always at the bottom
                SliverToBoxAdapter(
                  child: _CustomDateButton(
                    selectedRange: _selectedDateRange,
                    onTap: () => _selectDateRange(context),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 36)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ① NAV BAR  (replaces MyAppbar back-button + tag)
// ══════════════════════════════════════════════════════════════════════════════

class _NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Tap(
            onTap: () => Navigator.of(context).maybePop(),
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
          _Tag('Workshop Hours'),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(color: _P.divider, width: 0.8),
      borderRadius: BorderRadius.circular(3),
    ),
    child: Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 9,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w500,
        color: _P.inkSoft,
      ),
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// ② STUDENT IDENTITY  (MyAppbar title block + StudentInfoCard)
// ══════════════════════════════════════════════════════════════════════════════

class _StudentIdentity extends StatelessWidget {
  final DummyStudent student;
  const _StudentIdentity({required this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Student',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              color: _P.inkSoft,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            student.name,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 32,
              color: _P.inkDeep,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (student.courseName.isNotEmpty && student.courseName != '...')
                _MetaPill(student.courseName),
              if (student.batchName.isNotEmpty && student.batchName != '...')
                _MetaPill(student.batchName),
              if ((student.rollno ?? '').isNotEmpty && student.rollno != '...')
                _MetaPill('Roll · ${student.rollno}'),
            ],
          ),
          const SizedBox(height: 18),
          // Info rows — original StudentInfoCard fields
          _InfoSection(
            children: [
              _InfoRow(
                icon: Icons.person_outline_rounded,
                iconBed: _P.sandBed,
                iconStroke: _P.sandStroke,
                label: 'Student name',
                value: student.name,
              ),
              _InfoRow(
                icon: Icons.groups_outlined,
                iconBed: _P.sageBed,
                iconStroke: _P.sageStroke,
                label: 'Batch name',
                value: student.batchName,
              ),
              _InfoRow(
                icon: Icons.badge_outlined,
                iconBed: _P.lavBed,
                iconStroke: _P.lavStroke,
                label: 'Roll no',
                value: student.rollno ?? '—',
                isLast: true,
              ),
            ],
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
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontSize: 11, color: _P.inkSoft));
}

class _InfoSection extends StatelessWidget {
  final List<Widget> children;
  const _InfoSection({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: _P.sand,
      borderRadius: BorderRadius.circular(18),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Column(children: children),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconBed, iconStroke;
  final String label, value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.iconBed,
    required this.iconStroke,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => Container(
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

// ══════════════════════════════════════════════════════════════════════════════
// ③ TIME RANGE CHIPS  (MyChoiceChips + custom date button)
//   Fires: ThisWeekEvent, LastWeekEvent, SelectiveRangeEvent
// ══════════════════════════════════════════════════════════════════════════════

class _TimeRangeChips extends StatelessWidget {
  final String selected;
  final DateTimeRange? selectedRange;
  final void Function(String) onTap;

  const _TimeRangeChips({
    required this.selected,
    required this.selectedRange,
    required this.onTap,
  });

  static const _chips = ['This Week', 'Last Week'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _chips.map((label) {
                  final isActive = selected == label;
                  return _Tap(
                    onTap: () => onTap(label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? _P.inkDeep : _P.sand,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isActive ? _P.inkDeep : _P.divider,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:
                                  isActive
                                      ? const Color(0xFFF9F7F4)
                                      : _P.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ④ CHART CARD  (ShadowedContainer + BarChart + generateBarGroups)
// ══════════════════════════════════════════════════════════════════════════════

class _ChartCard extends StatelessWidget {
  final String selectedFilter;
  final double Function(List<DailyStudyData>) maxHours;

  const _ChartCard({required this.selectedFilter, required this.maxHours});

  Color _barColor(double hours, double maxY) {
    final r = hours / maxY;
    if (r >= 0.75) return _P.barHigh;
    if (r >= 0.40) return _P.barMid;
    return _P.barLow;
  }

  // Replaces generateBarGroups — same data shape, warm palette
  List<BarChartGroupData> _buildGroups(List<DailyStudyData> data, double maxY) {
    return data.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value.hours,
            color: _barColor(e.value.hours, maxY),
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.38,
        decoration: BoxDecoration(
          color: _P.sand,
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: BlocConsumer<TimeGraphPageBloc, TimeGraphPageState>(
          listener: (_, __) {},
          builder: (context, state) {
            if (state is TimeGraphPageLoading) {
              return const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _P.inkSoft,
                  ),
                ),
              );
            }
            if (state is TimeGraphPageErrorState) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(fontSize: 13, color: _P.inkSoft),
                ),
              );
            }
            if (state is TimeGraphPageLoaded) {
              final data = state.studentData;
              if (data.isEmpty) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart_rounded, size: 36, color: _P.inkFaint),
                    SizedBox(height: 10),
                    Text(
                      'No data for selected range',
                      style: TextStyle(fontSize: 13, color: _P.inkSoft),
                    ),
                  ],
                );
              }
              final maxY = maxHours(data);
              return BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  barGroups: _buildGroups(data, maxY),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  minY: 0,
                  groupsSpace: 12,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => _P.inkDeep,
                      getTooltipItem: (group, _, rod, __) {
                        final d = data[group.x.toInt()];
                        return BarTooltipItem(
                          '${d.hours} hrs\n${DateFormat('MMM d').format(d.date)}',
                          GoogleFonts.dmSans(
                            color: const Color(0xFFF9F7F4),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= data.length) return const Text('');
                          final label =
                              selectedFilter == 'Custom'
                                  ? DateFormat('MMM d').format(data[i].date)
                                  : data[i].day;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 11,
                                color: _P.inkSoft,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.min || value == meta.max) {
                            return const Text('');
                          }
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: _P.inkFaint,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY > 10 ? 2 : 1,
                    getDrawingHorizontalLine:
                        (_) => const FlLine(
                          color: Color(0xFFE2DDD6),
                          strokeWidth: 1,
                        ),
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontSize: 13, color: _P.inkSoft),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ⑤ SUMMARY ROW  (replaces AverageTimeContainer)
//   Reads totalHours + averageHours from BLoC — identical to original.
// ══════════════════════════════════════════════════════════════════════════════

class _SummaryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeGraphPageBloc, TimeGraphPageState>(
      builder: (context, state) {
        final double totalHours;
        final double averageHours;

        if (state is TimeGraphPageLoaded) {
          totalHours = state.totalHours ?? 0;
          averageHours = state.averageHours ?? 0;
        } else {
          totalHours = 0;
          averageHours = 0;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _StatSlab(
                  icon: Icons.schedule_rounded,
                  iconBed: _P.sandBed,
                  iconStroke: _P.sandStroke,
                  label: 'Total hours',
                  value: '${totalHours.toStringAsFixed(1)} hrs',
                  sub: 'selected period',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatSlab(
                  icon: Icons.trending_up_rounded,
                  iconBed: _P.sageBed,
                  iconStroke: _P.sageStroke,
                  label: 'Daily average',
                  value: '${averageHours.toStringAsFixed(1)} hrs',
                  sub: 'hrs per day',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatSlab extends StatelessWidget {
  final IconData icon;
  final Color iconBed, iconStroke;
  final String label, value, sub;

  const _StatSlab({
    required this.icon,
    required this.iconBed,
    required this.iconStroke,
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: _P.sand,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconBed,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 15, color: iconStroke),
        ),
        const SizedBox(height: 14),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: _P.inkSoft,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 26,
            color: _P.inkDeep,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 3),
        Text(sub, style: const TextStyle(fontSize: 10, color: _P.inkFaint)),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// ⑥ CUSTOM DATE BUTTON — dark slab at the bottom, always visible
// ══════════════════════════════════════════════════════════════════════════════

class _CustomDateButton extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final VoidCallback onTap;

  const _CustomDateButton({required this.selectedRange, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasRange = selectedRange != null;
    final label =
        hasRange
            ? '${DateFormat('MMM d').format(selectedRange!.start)}'
                '  —  '
                '${DateFormat('MMM d').format(selectedRange!.end)}'
            : 'Custom date range';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: _Tap(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            color: _P.inkDeep,
            borderRadius: BorderRadius.circular(18),
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
                child: Icon(
                  hasRange
                      ? Icons.calendar_today_rounded
                      : Icons.calendar_today_outlined,
                  size: 16,
                  color:
                      hasRange
                          ? const Color(
                            0xFF7EC8A4,
                          ) // sage accent when range set
                          : const Color(0xFFC8C2BB),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color:
                        hasRange
                            ? const Color(0xFFF9F7F4)
                            : const Color(0xFF9C9890),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color:
                    hasRange
                        ? const Color(0xFF9C9890)
                        : const Color(0xFF6B6762),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED: DOUBLE RULE
// ══════════════════════════════════════════════════════════════════════════════

class _DoubleRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
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

// ══════════════════════════════════════════════════════════════════════════════
// SHARED: PRESSABLE TAP WRAPPER
// ══════════════════════════════════════════════════════════════════════════════

class _Tap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _Tap({required this.child, required this.onTap});

  @override
  State<_Tap> createState() => _TapState();
}

class _TapState extends State<_Tap> {
  bool _p = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _p = true),
      onTapUp: (_) {
        setState(() => _p = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _p = false),
      child: AnimatedScale(
        scale: _p ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
