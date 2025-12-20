import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/presentation/widget/attendence_content_view.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';

import 'bloc/student_attendence_bloc_bloc.dart';

/// StudentAttendancePage with enhanced neumorphic UI
class StudentAdentencePage extends StatefulWidget {
  const StudentAdentencePage({
    super.key,
    required this.name,
    required this.rollNo,
  });
  final String? rollNo;
  final String? name;

  @override
  State<StudentAdentencePage> createState() => _StudentAdentencePageState();
}

class _StudentAdentencePageState extends State<StudentAdentencePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _locationAnimController;
  late Animation<double> _pulseAnimation;

  // Metrological constants (8dp grid system)
  static const double _baseUnit = 8.0;
  static const double _goldenRatio = 1.618;

  // Calculated dimensions using geometric principles
  static const double _iconSize = _baseUnit * 3; // 24dp
  static const double _minTouchTarget = _baseUnit * 6; // 48dp
  static const double _horizontalPadding = _baseUnit * 2; // 16dp

  @override
  void initState() {
    super.initState();
    context.read<StudentAttendenceBloc>().add(
      LoadAttendance(name: widget.name, rollNo: widget.rollNo),
    );

    // Initialize location pulse animation
    _locationAnimController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _locationAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _locationAnimController.dispose();
    super.dispose();
  }

  void _onLocationPressed() {
    context.read<StudentAttendenceBloc>().add(LocationCheckEvent());

    // Visual feedback using animation
    _locationAnimController.forward().then((_) {
      _locationAnimController.reverse();
    });
  }

  /// Calculates Euclidean distance between two points
  /// Used for ensuring proper touch target spacing
  double _calculateDistance(Offset p1, Offset p2) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate safe areas using geometric bounds
    final safeHorizontal = math.max(
      _horizontalPadding,
      (screenWidth - (screenWidth / _goldenRatio)) / 2,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Column(
        children: [
          // Neumorphic Header with SafeArea
          SafeArea(
            bottom: false,
            child: _buildNeumorphicHeader(context),
          ),
          
          // Main Content
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
    );
  }

  /// Builds neumorphic header with back button and location button
  Widget _buildNeumorphicHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;
    final titleFontSize = size.width * 0.07;
    final iconSize = size.width * 0.065;
    final backButtonPadding = size.width * 0.04;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding * 0.8,
        vertical: size.height * 0.02,
      ),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 8,
          intensity: 0.65,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(size.width * 0.06),
          ),
          color: const Color(0xFFF8F9FD),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding * 1.2,
            vertical: size.height * 0.025,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width * 0.06),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF8F9FD).withOpacity(0.9),
                const Color(0xFFEBEDF5).withOpacity(0.8),
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              FadeInDown(
                delay: const Duration(milliseconds: 300),
                child: NeumorphicButton(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  style: NeumorphicStyle(
                    boxShape: const NeumorphicBoxShape.circle(),
                    depth: 6,
                    intensity: 0.8,
                    shape: NeumorphicShape.flat,
                    color: const Color(0xFFF8F9FD),
                  ),
                  padding: EdgeInsets.all(backButtonPadding),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: iconSize,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.04),
              
              // Title Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      delay: const Duration(milliseconds: 400),
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.01,
                            height: titleFontSize * 0.65,
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark, // Using AppColors
                              borderRadius: BorderRadius.circular(size.width * 0.01),
                            ),
                          ),
                          SizedBox(width: size.width * 0.025),
                          Flexible(
                            child: Text(
                              widget.name ?? 'Student',
                              style: TextStyle(
                                fontSize: titleFontSize * 0.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF111827).withOpacity(0.7),
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.008),
                    FadeInDown(
                      delay: const Duration(milliseconds: 500),
                      child: ShaderMask(
                        shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds), // Using AppColors
                        child: Text(
                          'Attendance',
                          style: TextStyle(
                            fontSize: titleFontSize * 1.1,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Location Button (conditional)
              if (widget.rollNo == null) ...[
                SizedBox(width: size.width * 0.02),
                FadeInDown(
                  delay: const Duration(milliseconds: 600),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: NeumorphicButton(
                          onPressed: _onLocationPressed,
                          style: NeumorphicStyle(
                            boxShape: const NeumorphicBoxShape.circle(),
                            depth: 6,
                            intensity: 0.8,
                            shape: NeumorphicShape.flat,
                            color: const Color(0xFFF8F9FD),
                          ),
                          padding: EdgeInsets.all(backButtonPadding),
                          child: Icon(
                            Icons.location_on_rounded,
                            size: iconSize,
                            color: AppColors.accent, // Using AppColors
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds content based on state with smooth transitions
  Widget _buildStateContent(
    BuildContext context,
    AttendanceState state,
    double horizontalPadding,
  ) {
    if (state is AttendanceLoading) {
      return _buildLoadingState();
    }

    if (state is AttendanceLoaded) {
      return _buildLoadedState(state, horizontalPadding);
    }

    if (state is AttendanceError) {
      return _buildErrorState(state.message);
    }

    return _buildEmptyState();
  }

  /// Loading state with centered circular progress indicator
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _baseUnit * 8,
            height: _baseUnit * 8,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary), // Using AppColors
            ),
          ),
          SizedBox(height: _baseUnit * 3),
          Text(
            'Loading attendance data...',
            style: TextStyle(
              fontSize: _baseUnit * 2,
              color: const Color(0xFF9CA3AF),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Loaded state with content view
  Widget _buildLoadedState(AttendanceLoaded state, double padding) {
    return AttendanceContentView(
      student: state.student,
      records: state.records,
    );
  }

  /// Error state with retry option
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_baseUnit * 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: _baseUnit * 10,
              color: Colors.red[400],
            ),
            SizedBox(height: _baseUnit * 3),
            Text(
              'Error Loading Data',
              style: TextStyle(
                fontSize: _baseUnit * 2.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
            SizedBox(height: _baseUnit * 1.5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _baseUnit * 2,
                color: const Color(0xFF9CA3AF),
                height: 1.5,
              ),
            ),
            SizedBox(height: _baseUnit * 4),
            ElevatedButton.icon(
              onPressed: () {
                context.read<StudentAttendenceBloc>().add(LoadAttendance());
              },
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text('Retry', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // Using AppColors
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: _baseUnit * 4,
                  vertical: _baseUnit * 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_baseUnit),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state placeholder
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: _baseUnit * 10,
            color: const Color(0xFF9CA3AF),
          ),
          SizedBox(height: _baseUnit * 3),
          Text(
            'No attendance data available',
            style: TextStyle(
              fontSize: _baseUnit * 2,
              color: const Color(0xFF9CA3AF),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows error snackbar with geometric positioning
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: _iconSize),
            SizedBox(width: _baseUnit * 1.5),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(_baseUnit * 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_baseUnit),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}