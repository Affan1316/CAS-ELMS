// import 'dart:math' as math;

// import 'package:animate_do/animate_do.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
// import 'package:flutter_cas_app_main/src/features/my_student_attendence/presentation/widget/attendence_content_view.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
// import 'package:responsive_ui_kit/responsive_ui_kit.dart';

// import 'bloc/student_attendence_bloc_bloc.dart';

// /// StudentAttendancePage with enhanced neumorphic UI
// class StudentAdentencePage extends StatefulWidget {
//   const StudentAdentencePage({super.key, this.name, this.rollNo});
//   final String? rollNo;
//   final String? name;

//   @override
//   State<StudentAdentencePage> createState() => _StudentAdentencePageState();
// }

// class _StudentAdentencePageState extends State<StudentAdentencePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _locationAnimController;
//   late Animation<double> _pulseAnimation;

//   // Metrological constants (8dp grid system)
//   static const double _baseUnit = 8.0;
//   static const double _goldenRatio = 1.618;

//   // Calculated dimensions using geometric principles
//   static const double _iconSize = _baseUnit * 3; // 24dp
//   static const double _minTouchTarget = _baseUnit * 6; // 48dp
//   static const double _horizontalPadding = _baseUnit * 2; // 16dp

//   @override
//   void initState() {
//     super.initState();
//     context.read<StudentAttendenceBloc>().add(
//       LoadAttendance(name: widget.name, rollNo: widget.rollNo),
//     );

//     // Initialize location pulse animation
//     _locationAnimController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
//       CurvedAnimation(parent: _locationAnimController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _locationAnimController.dispose();
//     super.dispose();
//   }

//   void _onLocationPressed() {
//     context.read<StudentAttendenceBloc>().add(LocationCheckEvent());

//     // Visual feedback using animation
//     _locationAnimController.forward().then((_) {
//       _locationAnimController.reverse();
//     });
//   }

//   /// Calculates Euclidean distance between two points
//   /// Used for ensuring proper touch target spacing
//   double _calculateDistance(Offset p1, Offset p2) {
//     final dx = p2.dx - p1.dx;
//     final dy = p2.dy - p1.dy;
//     return math.sqrt(dx * dx + dy * dy);
//   }

//   Future<void> _selectDateRange() async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//       lastDate: DateTime.now(),
//       initialDateRange: DateTimeRange(
//         start: DateTime.now().subtract(const Duration(days: 7)),
//         end: DateTime.now(),
//       ), // 👇 YEH ADD KAR - White background ke liye
//       builder: (context, child) {
//         return Container(
//           color: Colors.white,
//           child: Theme(
//             data: ThemeData.light().copyWith(
//               scaffoldBackgroundColor: Colors.white,
//               dialogBackgroundColor: Colors.white,
//               colorScheme: const ColorScheme.light(
//                 surface: Colors.white,
//                 background: Colors.white,
//                 onSurface: Colors.black,
//               ),
//             ),
//             child: child!,
//           ),
//         );
//       },
//     );

//     if (picked != null && context.mounted) {
//       context.read<StudentAttendenceBloc>().add(
//         LoadAttendance(dateRange: picked),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = context.width;
//     final screenHeight = context.height;

//     // Calculate safe areas using geometric bounds
//     final safeHorizontal = math.max(
//       _horizontalPadding,
//       (screenWidth - (screenWidth / _goldenRatio)) / 2,
//     );

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       floatingActionButton: FloatingActionButton.extended(
//         heroTag: 'dateRange',
//         onPressed: _selectDateRange,
//         backgroundColor: const Color(0xFF2196F3),
//         elevation: 4,
//         highlightElevation: 8,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         icon: const Icon(Icons.date_range, color: Colors.white),
//         label: const Text(
//           'Select Dates',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Neumorphic Header with SafeArea
//           SafeArea(bottom: false, child: _buildNeumorphicHeader(context)),

//           // Main Content
//           Expanded(
//             child: BlocBuilder<StudentAttendenceBloc, AttendanceState>(
//               builder: (context, state) {
//                 return AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   switchInCurve: Curves.easeInOut,
//                   switchOutCurve: Curves.easeInOut,
//                   child: _buildStateContent(context, state, safeHorizontal),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Builds neumorphic header with back button and location button
//   Widget _buildNeumorphicHeader(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
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
//           color: const Color(0xFFF8F9FD),
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
//                 const Color(0xFFF8F9FD).withOpacity(0.9),
//                 const Color(0xFFEBEDF5).withOpacity(0.8),
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
//                     color: const Color(0xFFF8F9FD),
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
//                           Flexible(
//                             child: Text(
//                               widget.name ?? 'Student',
//                               style: TextStyle(
//                                 fontSize: titleFontSize * 0.5,
//                                 fontWeight: FontWeight.w600,
//                                 color: const Color(0xFF111827).withOpacity(0.7),
//                                 letterSpacing: 0.5,
//                               ),
//                               overflow: TextOverflow.ellipsis,
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
//                             (bounds) => AppColors.primaryGradient.createShader(
//                               bounds,
//                             ), // Using AppColors
//                         child: Text(
//                           'Attendance',
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
//               SizedBox(width: size.width * 0.02),
//               Builder(
//                 builder: (context) {
//                   if (widget.rollNo == null) {
//                     return FadeInDown(
//                       delay: const Duration(milliseconds: 600),
//                       child: AnimatedBuilder(
//                         animation: _pulseAnimation,
//                         builder: (context, child) {
//                           return Transform.scale(
//                             scale: _pulseAnimation.value,
//                             child: NeumorphicButton(
//                               onPressed: _onLocationPressed,
//                               style: NeumorphicStyle(
//                                 boxShape: const NeumorphicBoxShape.circle(),
//                                 depth: 6,
//                                 intensity: 0.8,
//                                 shape: NeumorphicShape.flat,
//                                 color: const Color(0xFFF8F9FD),
//                               ),
//                               padding: EdgeInsets.all(backButtonPadding),
//                               child: Icon(
//                                 Icons.location_on_rounded,
//                                 size: iconSize,
//                                 color: AppColors.accent, // Using AppColors
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   } else {
//                     return const SizedBox();
//                   }
//                 },
//               ),

//               // Location Button (conditional)
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Builds content based on state with smooth transitions
//   Widget _buildStateContent(
//     BuildContext context,
//     AttendanceState state,
//     double horizontalPadding,
//   ) {
//     if (state is AttendanceLoading) {
//       return _buildLoadingState();
//     }

//     if (state is AttendanceLoaded) {
//       return _buildLoadedState(state, horizontalPadding);
//     }

//     if (state is AttendanceError) {
//       return _buildErrorState(state.message);
//     }

//     return _buildEmptyState();
//   }

//   /// Loading state with centered circular progress indicator
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: _baseUnit * 8,
//             height: _baseUnit * 8,
//             child: CircularProgressIndicator(
//               strokeWidth: 3.5,
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 AppColors.primary,
//               ), // Using AppColors
//             ),
//           ),
//           SizedBox(height: _baseUnit * 3),
//           Text(
//             'Loading attendance data...',
//             style: TextStyle(
//               fontSize: _baseUnit * 2,
//               color: const Color(0xFF9CA3AF),
//               letterSpacing: 0.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Loaded state with content view
//   Widget _buildLoadedState(AttendanceLoaded state, double padding) {
//     return AttendanceContentView(
//       student: state.student,
//       records: state.records,
//     );
//   }

//   /// Error state with retry option
//   Widget _buildErrorState(String message) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(_baseUnit * 4),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline_rounded,
//               size: _baseUnit * 10,
//               color: Colors.red[400],
//             ),
//             SizedBox(height: _baseUnit * 3),
//             Text(
//               'Error Loading Data',
//               style: TextStyle(
//                 fontSize: _baseUnit * 2.5,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF111827),
//               ),
//             ),
//             SizedBox(height: _baseUnit * 1.5),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: _baseUnit * 2,
//                 color: const Color(0xFF9CA3AF),
//                 height: 1.5,
//               ),
//             ),
//             SizedBox(height: _baseUnit * 4),
//             ElevatedButton.icon(
//               onPressed: () {
//                 context.read<StudentAttendenceBloc>().add(LoadAttendance());
//               },
//               icon: const Icon(Icons.refresh_rounded, color: Colors.white),
//               label: const Text('Retry', style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary, // Using AppColors
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: _baseUnit * 4,
//                   vertical: _baseUnit * 2,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(_baseUnit),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Empty state placeholder
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.inbox_outlined,
//             size: _baseUnit * 10,
//             color: const Color(0xFF9CA3AF),
//           ),
//           SizedBox(height: _baseUnit * 3),
//           Text(
//             'No attendance data available',
//             style: TextStyle(
//               fontSize: _baseUnit * 2,
//               color: const Color(0xFF9CA3AF),
//               letterSpacing: 0.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Shows error snackbar with geometric positioning
//   void _showErrorSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.white, size: _iconSize),
//             SizedBox(width: _baseUnit * 1.5),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(fontSize: 14, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.red[700],
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.all(_baseUnit * 2),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(_baseUnit),
//         ),
//         duration: const Duration(seconds: 4),
//       ),
//     );
//   }
// }

import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/presentation/widget/attendence_content_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

import 'bloc/student_attendence_bloc_bloc.dart';

// ══════════════════════════════════════════════════════════════════════════════
// REDESIGNED StudentAdentencePage
// ── All logic, BLoC events, Firebase calls: UNCHANGED
// ── Only UI layer restyled to match the app's editorial newspaper design
// ══════════════════════════════════════════════════════════════════════════════

class StudentAdentencePage extends StatefulWidget {
  const StudentAdentencePage({super.key, this.name, this.rollNo});
  final String? rollNo;
  final String? name;

  @override
  State<StudentAdentencePage> createState() => _StudentAdentencePageState();
}

class _StudentAdentencePageState extends State<StudentAdentencePage>
    with SingleTickerProviderStateMixin {
  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  late AnimationController _locationAnimController;
  late Animation<double> _pulseAnimation;

  static const double _baseUnit = 8.0;
  static const double _goldenRatio = 1.618;
  static const double _iconSize = _baseUnit * 3;
  static const double _minTouchTarget = _baseUnit * 6;
  static const double _horizontalPadding = _baseUnit * 2;

  @override
  void initState() {
    super.initState();

    // ── BLoC event: UNCHANGED ─────────────────────────────────────────────
    context.read<StudentAttendenceBloc>().add(
      LoadAttendance(name: widget.name, rollNo: widget.rollNo),
    );

    _locationAnimController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _locationAnimController, curve: Curves.easeInOut),
    );

    // Status bar style — moved out of build()
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _locationAnimController.dispose();
    super.dispose();
  }

  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  void _onLocationPressed() {
    context.read<StudentAttendenceBloc>().add(LocationCheckEvent());
    _locationAnimController.forward().then((_) {
      _locationAnimController.reverse();
    });
  }

  double _calculateDistance(Offset p1, Offset p2) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Container(
          color: Colors.white,
          child: Theme(
            data: ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.white,
              dialogBackgroundColor: Colors.white,
              colorScheme: const ColorScheme.light(
                surface: Colors.white,
                background: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<StudentAttendenceBloc>().add(
        LoadAttendance(dateRange: picked),
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD — redesigned scaffold
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final safeHorizontal = math.max(
      _horizontalPadding,
      (screenWidth - (screenWidth / _goldenRatio)) / 2,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4), // warm cream — matches app
      floatingActionButton: _DateRangeButton(onTap: _selectDateRange),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Editorial header ─────────────────────────────────────────
            _EditorialHeader(
              name: widget.name,
              rollNo: widget.rollNo,
              pulseAnimation: _pulseAnimation,
              onBackPressed: () => Navigator.of(context).maybePop(),
              onLocationPressed:
                  widget.rollNo == null ? _onLocationPressed : null,
            ),

            // ── Rule — double editorial rule, same as home page ──────────
            const _DoubleRule(),

            // ── Section label ─────────────────────────────────────────────
            const _SectionLabel('Attendance record'),

            // ── Main content from BLoC ────────────────────────────────────
            Expanded(
              child: BlocBuilder<StudentAttendenceBloc, AttendanceState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: _buildStateContent(context, state, safeHorizontal),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── State content builder: LOGIC UNCHANGED ────────────────────────────────
  Widget _buildStateContent(
    BuildContext context,
    AttendanceState state,
    double horizontalPadding,
  ) {
    if (state is AttendanceLoading) return _buildLoadingState();
    if (state is AttendanceLoaded) {
      return _buildLoadedState(state, horizontalPadding);
    }
    if (state is AttendanceError) return _buildErrorState(state.message);
    return _buildEmptyState();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _baseUnit * 8,
            height: _baseUnit * 8,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(height: _baseUnit * 3),
          const Text(
            'Loading attendance data...',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8C8680),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(AttendanceLoaded state, double padding) {
    // LOGIC UNCHANGED — same AttendanceContentView
    return AttendanceContentView(
      student: state.student,
      records: state.records,
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_baseUnit * 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFCEBEB),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 28,
                color: Color(0xFFA32D2D),
              ),
            ),
            SizedBox(height: _baseUnit * 3),
            Text(
              'Couldn\'t load data',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 22,
                color: const Color(0xFF1C1A17),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: _baseUnit * 1.5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8C8680),
                height: 1.55,
              ),
            ),
            SizedBox(height: _baseUnit * 4),
            _RetryButton(
              onTap: () {
                context.read<StudentAttendenceBloc>().add(LoadAttendance());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9E4),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 26,
              color: Color(0xFF8C8680),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No attendance data available',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8C8680),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITORIAL HEADER
// Matches the home page's editorial newspaper design language
// ══════════════════════════════════════════════════════════════════════════════

class _EditorialHeader extends StatelessWidget {
  final String? name;
  final String? rollNo;
  final Animation<double> pulseAnimation;
  final VoidCallback onBackPressed;
  final VoidCallback? onLocationPressed; // null = hide location button

  const _EditorialHeader({
    required this.name,
    required this.rollNo,
    required this.pulseAnimation,
    required this.onBackPressed,
    this.onLocationPressed,
  });

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
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top dateline bar ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button — editorial circle
              FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: GestureDetector(
                  onTap: onBackPressed,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9E4),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFDDD9D3),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 14,
                      color: Color(0xFF5A5550),
                    ),
                  ),
                ),
              ),

              // Date pill
              FadeInDown(
                delay: const Duration(milliseconds: 150),
                child: Row(
                  children: [
                    Text(
                      _dateString,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8C8680),
                        letterSpacing: 0.2,
                      ),
                    ),
                    // Location button — only when rollNo is null
                    if (onLocationPressed != null) ...[
                      const SizedBox(width: 10),
                      AnimatedBuilder(
                        animation: pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: pulseAnimation.value,
                            child: GestureDetector(
                              onTap: onLocationPressed,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDE9E4),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFDDD9D3),
                                    width: 0.8,
                                  ),
                                ),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  size: 15,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Hairline rule ─────────────────────────────────────────────────
        const Divider(height: 1, thickness: 0.8, color: Color(0xFFDDD9D3)),

        // ── Typographic hero — student name + page title ──────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Eyebrow
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  'ATTENDANCE',
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8C8680),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Large serif name
              FadeInDown(
                delay: const Duration(milliseconds: 280),
                child: Text(
                  name ?? 'Student',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1C1A17),
                    height: 1.05,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED EDITORIAL COMPONENTS — matches home page design language
// ══════════════════════════════════════════════════════════════════════════════

class _DoubleRule extends StatelessWidget {
  const _DoubleRule();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 2.5, color: const Color(0xFF1C1A17)),
          const SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: Container(height: 0.8, color: const Color(0xFFDDD9D3)),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(height: 0.8, color: const Color(0xFFDDD9D3)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 9.5,
          letterSpacing: 1.6,
          fontWeight: FontWeight.w500,
          color: Color(0xFF8C8680),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DATE RANGE FAB — styled to match editorial palette
// ══════════════════════════════════════════════════════════════════════════════

class _DateRangeButton extends StatefulWidget {
  final VoidCallback onTap;
  const _DateRangeButton({required this.onTap});

  @override
  State<_DateRangeButton> createState() => _DateRangeButtonState();
}

class _DateRangeButtonState extends State<_DateRangeButton> {
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
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1A17),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.date_range_rounded,
                size: 16,
                color: Color(0xFFC4A882),
              ),
              SizedBox(width: 8),
              Text(
                'Select Dates',
                style: TextStyle(
                  color: Color(0xFFF9F7F4),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// RETRY BUTTON
// ══════════════════════════════════════════════════════════════════════════════

class _RetryButton extends StatefulWidget {
  final VoidCallback onTap;
  const _RetryButton({required this.onTap});

  @override
  State<_RetryButton> createState() => _RetryButtonState();
}

class _RetryButtonState extends State<_RetryButton> {
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
        duration: const Duration(milliseconds: 110),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1A17),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_rounded, size: 15, color: Color(0xFFC4A882)),
              SizedBox(width: 8),
              Text(
                'Try again',
                style: TextStyle(
                  color: Color(0xFFF9F7F4),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
