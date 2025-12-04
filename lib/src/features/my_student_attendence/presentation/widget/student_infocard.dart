import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/data/model/model_classes.dart';
import 'dart:math' as math;

/// A responsive StatelessWidget for the student info card
///
/// Geometric Design Principles:
/// - 8dp grid system for precise spacing
/// - Golden ratio for proportional scaling
/// - Responsive breakpoints for different screen sizes
/// - Euclidean geometry for circular avatar sizing
class StudentInfoCard extends StatelessWidget {
  final Student student;

  const StudentInfoCard({super.key, required this.student});

  // Metrological constants (8dp grid system)
  static const double _baseUnit = 8.0;
  static const double _goldenRatio = 1.618;

  // Responsive breakpoints (based on Material Design)
  static const double _compactBreakpoint = 600.0;
  static const double _mediumBreakpoint = 840.0;

  /// Calculate responsive avatar radius based on screen width
  /// Uses geometric scaling with constraints
  double _calculateAvatarRadius(double screenWidth) {
    if (screenWidth < _compactBreakpoint) {
      // Compact: 28-32dp radius
      return math.max(28.0, math.min(32.0, screenWidth * 0.08));
    } else if (screenWidth < _mediumBreakpoint) {
      // Medium: 32-36dp radius
      return math.max(32.0, math.min(36.0, screenWidth * 0.06));
    } else {
      // Expanded: 36-40dp radius
      return math.max(36.0, math.min(40.0, screenWidth * 0.04));
    }
  }

  /// Calculate responsive padding using golden ratio
  EdgeInsets _calculateCardPadding(double screenWidth) {
    final basePadding =
        screenWidth < _compactBreakpoint
            ? _baseUnit *
                2 // 16dp for compact
            : _baseUnit * 2.5; // 20dp for medium+

    return EdgeInsets.all(basePadding);
  }

  /// Calculate responsive margin
  EdgeInsets _calculateCardMargin(double screenWidth) {
    final horizontalMargin =
        screenWidth < _compactBreakpoint
            ? _baseUnit *
                2 // 16dp
            : _baseUnit * 3; // 24dp

    return EdgeInsets.fromLTRB(
      horizontalMargin,
      _baseUnit * 2, // top: 16dp
      horizontalMargin,
      _baseUnit * 0.75, // bottom: 6dp
    );
  }

  /// Calculate responsive spacing between avatar and text
  double _calculateSpacing(double screenWidth) {
    return screenWidth < _compactBreakpoint
        ? _baseUnit *
            2 // 16dp
        : _baseUnit * 3; // 24dp
  }

  /// Calculate responsive font sizes using geometric scaling
  Map<String, double> _calculateFontSizes(double screenWidth) {
    if (screenWidth < _compactBreakpoint) {
      return {'name': 16.0, 'rollNo': 13.0};
    } else if (screenWidth < _mediumBreakpoint) {
      return {'name': 18.0, 'rollNo': 14.0};
    } else {
      return {'name': 20.0, 'rollNo': 15.0};
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive dimensions
    final avatarRadius = _calculateAvatarRadius(screenWidth);
    final cardPadding = _calculateCardPadding(screenWidth);
    final cardMargin = _calculateCardMargin(screenWidth);
    final spacing = _calculateSpacing(screenWidth);
    final fontSizes = _calculateFontSizes(screenWidth);

    // Calculate if we should use compact layout (very small screens)
    final isVeryCompact = screenWidth < 360;

    return Card(
      color: AppColors.containerColor,
      margin: cardMargin,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_baseUnit * 1.5),
      ),
      child: Padding(
        padding: cardPadding,
        child: Row(
          children: [
            // Avatar with geometric circle
            _buildAvatar(avatarRadius),

            SizedBox(width: spacing),

            // Student info - flexible to prevent overflow
            Expanded(child: _buildStudentInfo(fontSizes, isVeryCompact)),
          ],
        ),
      ),
    );
  }

  /// Builds circular avatar with precise geometry
  Widget _buildAvatar(double radius) {
    return Hero(
      tag: 'student_avatar_${student.rollNo}',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: _baseUnit,
              offset: Offset(0, _baseUnit / 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
          backgroundImage: const NetworkImage(
            "https://plus.unsplash.com/premium_photo-1689977807477-a579eda91fa2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600",
          ),
          onBackgroundImageError: (exception, stackTrace) {
            // Fallback handled by backgroundColor
          },
          child:
              student.name.isNotEmpty
                  ? null
                  : Icon(
                    Icons.person_rounded,
                    size: radius * 0.8,
                    color: AppColors.primaryColor,
                  ),
        ),
      ),
    );
  }

  /// Builds student information text with responsive typography
  Widget _buildStudentInfo(Map<String, double> fontSizes, bool isVeryCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Student name
        Text(
          student.name,
          style: TextStyle(
            fontSize: fontSizes['name'],
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: 0.3,
            height: 1.2,
          ),
          maxLines: isVeryCompact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: _baseUnit * 0.5),

        // Roll number
        Row(
          children: [
            Icon(
              Icons.badge_outlined,
              size: fontSizes['rollNo']! * 1.2,
              color: Colors.grey[600],
            ),
            SizedBox(width: _baseUnit * 0.5),
            Flexible(
              child: Text(
                'Roll no: ${student.rollNo}',
                style: TextStyle(
                  fontSize: fontSizes['rollNo'],
                  color: Colors.grey[600],
                  letterSpacing: 0.2,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Extension for calculating optimal dimensions using Euclidean geometry
extension GeometricCalculations on double {
  /// Calculates distance from center using Pythagorean theorem
  double distanceFromCenter(double width, double height) {
    final centerX = width / 2;
    final centerY = height / 2;
    return math.sqrt(centerX * centerX + centerY * centerY);
  }

  /// Applies golden ratio scaling
  double get goldenScale => this * 1.618;

  /// Applies inverse golden ratio scaling
  double get inverseGoldenScale => this / 1.618;
}
