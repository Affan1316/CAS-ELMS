import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/request_leave/presentation/pages/history_leaves_page.dart';
import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/pages/assignments_list_page.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/pages/list_of_request_leave_page.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_side_fee_details_screen%20.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/pages/quiz_home_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../my_student_attendence/presentation/student_adentence_page.dart';
import 'dart:math' as math;

/// Responsive Quick Actions Widget with Geometric Design Principles
///
/// Design Principles:
/// - 8dp grid system for precise spacing
/// - Golden ratio (φ ≈ 1.618) for proportional scaling
/// - Material Design 3 responsive breakpoints
/// - Euclidean geometry for card dimensions
/// - Neumorphic design with proper shadow calculations
Widget buildQuickActions(String studentName, String section, String studentId) {
  final List<Map<String, dynamic>> studentFeatures = [
    {
      'title': 'My Assignments',
      'icon': Icons.assignment_rounded,
      'color': const Color(0xFF6366F1),
      'count': '5 Due',
      'isUrgent': true,
      'screen': const AssignmentsListPage(),
    },
    {
      'title': 'IQ Test',
      'icon': LucideIcons.brain,
      'color': const Color(0xFF10B981),
      'count': '3.8 GPA',
      'isUrgent': false,
      'screen': const QuizHomeScreen(),
    },
    {
      'title': 'Workshop Tracker',
      'icon': Icons.schedule_rounded,
      'color': const Color(0xFF8B5CF6),
      'count': '6 Today',
      'isUrgent': false,
      'screen': const LeaveScreen(),
    },
    {
      'title': 'Leave Request',
      'icon': Icons.event_note_rounded,
      'color': const Color(0xFFF59E0B),
      'count': '2 Pending',
      'isUrgent': false,
      'screen': ListOfRequestLeaveScreen(section: section, name: studentName),
    },
    {
      'title': 'Installments',
      'icon': Icons.library_books_rounded,
      'color': const Color(0xFF06B6D4),
      'count': '2 Borrowed',
      'isUrgent': false,
      'screen': StudentSideFeeDetailsScreen(studentId: studentId),
    },
    {
      'title': 'Study Groups',
      'icon': Icons.group_rounded,
      'color': const Color(0xFFEF4444),
      'count': '3 Active',
      'isUrgent': false,
      'screen': Container(child: const Text("Coming soon")),
    },
    {
      'title': 'Attendance',
      'icon': Icons.event_available_rounded,
      'color': const Color(0xFF84CC16),
      'count': '95%',
      'isUrgent': false,
      'screen': const StudentAdentencePage(),
    },
  ];

  return LayoutBuilder(
    builder: (context, constraints) {
      final layout = _QuickActionsLayout.calculate(constraints.maxWidth);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: layout.horizontalPadding,
              vertical: layout.verticalPadding,
            ),
            child: _buildSectionHeader(layout),
          ),

          // Grid of action cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: layout.horizontalPadding),
            child: _buildActionGrid(context, studentFeatures, layout),
          ),

          SizedBox(height: layout.bottomSpacing),
        ],
      );
    },
  );
}

/// Build section header with responsive typography
Widget _buildSectionHeader(_QuickActionsLayout layout) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Quick Actions',
        style: TextStyle(
          fontSize: layout.titleFontSize,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1E293B),
          letterSpacing: -0.5,
          height: 1.2,
        ),
      ),
      if (layout.deviceClass == _DeviceClass.large)
        Text(
          '${layout.crossAxisCount} columns',
          style: TextStyle(
            fontSize: layout.subtitleFontSize,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            letterSpacing: 0.2,
          ),
        ),
    ],
  );
}

/// Build responsive grid of action cards
Widget _buildActionGrid(
  BuildContext context,
  List<Map<String, dynamic>> features,
  _QuickActionsLayout layout,
) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: layout.crossAxisCount,
      crossAxisSpacing: layout.gridSpacing,
      mainAxisSpacing: layout.gridSpacing,
      childAspectRatio: layout.cardAspectRatio,
    ),
    itemCount: features.length,
    itemBuilder: (context, index) {
      final feature = features[index];
      return _QuickActionCard(
        title: feature['title'],
        icon: feature['icon'],
        color: feature['color'],
        count: feature['count'],
        isUrgent: feature['isUrgent'],
        layout: layout,
        onTap: () {
          if (feature['screen'] != null) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => feature['screen']));
          }
        },
      );
    },
  );
}

/// Responsive layout configuration class
class _QuickActionsLayout {
  final _DeviceClass deviceClass;
  final double screenWidth;
  final int crossAxisCount;
  final double horizontalPadding;
  final double verticalPadding;
  final double gridSpacing;
  final double bottomSpacing;
  final double cardAspectRatio;

  // Typography
  final double titleFontSize;
  final double subtitleFontSize;
  final double cardTitleSize;
  final double countFontSize;

  // Card dimensions
  final double iconSize;
  final double iconInnerSize;
  final double cardPadding;
  final double borderRadius;

  // Shadow dimensions
  final double shadowOffset;
  final double shadowBlur;

  const _QuickActionsLayout({
    required this.deviceClass,
    required this.screenWidth,
    required this.crossAxisCount,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.gridSpacing,
    required this.bottomSpacing,
    required this.cardAspectRatio,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.cardTitleSize,
    required this.countFontSize,
    required this.iconSize,
    required this.iconInnerSize,
    required this.cardPadding,
    required this.borderRadius,
    required this.shadowOffset,
    required this.shadowBlur,
  });

  /// Calculate layout based on screen width using geometric principles
  static _QuickActionsLayout calculate(double screenWidth) {
    // Metrological constants
    const baseUnit = 8.0;
    const goldenRatio = 1.618;

    // Determine device class
    final deviceClass = _determineDeviceClass(screenWidth);

    // Calculate responsive values based on device class
    switch (deviceClass) {
      case _DeviceClass.compact:
        return _QuickActionsLayout(
          deviceClass: deviceClass,
          screenWidth: screenWidth,
          crossAxisCount: screenWidth < 360 ? 1 : 2,
          horizontalPadding: baseUnit * 2, // 16dp
          verticalPadding: baseUnit * 2, // 16dp
          gridSpacing: baseUnit * 2, // 16dp
          bottomSpacing: baseUnit * 2, // 16dp
          cardAspectRatio: screenWidth < 360 ? 2.5 : 1.0,
          titleFontSize: baseUnit * 3, // 24dp
          subtitleFontSize: baseUnit * 1.75, // 14dp
          cardTitleSize: baseUnit * 1.75, // 14dp
          countFontSize: baseUnit * 1.5, // 12dp
          iconSize: baseUnit * 8, // 64dp
          iconInnerSize: baseUnit * 4, // 32dp
          cardPadding: baseUnit * 2.5, // 20dp
          borderRadius: baseUnit * 3, // 24dp
          shadowOffset: baseUnit, // 8dp
          shadowBlur: baseUnit * 1.875, // 15dp
        );

      case _DeviceClass.medium:
        return _QuickActionsLayout(
          deviceClass: deviceClass,
          screenWidth: screenWidth,
          crossAxisCount: 3,
          horizontalPadding: baseUnit * 3, // 24dp
          verticalPadding: baseUnit * 2.5, // 20dp
          gridSpacing: baseUnit * 2.5, // 20dp
          bottomSpacing: baseUnit * 2.5, // 20dp
          cardAspectRatio: 1.05,
          titleFontSize: baseUnit * 3.5, // 28dp
          subtitleFontSize: baseUnit * 2, // 16dp
          cardTitleSize: baseUnit * 1.875, // 15dp
          countFontSize: baseUnit * 1.625, // 13dp
          iconSize: baseUnit * 8.75, // 70dp
          iconInnerSize: baseUnit * 4.5, // 36dp
          cardPadding: baseUnit * 3, // 24dp
          borderRadius: baseUnit * 3.5, // 28dp
          shadowOffset: baseUnit * 1.25, // 10dp
          shadowBlur: baseUnit * 2.25, // 18dp
        );

      case _DeviceClass.expanded:
        return _QuickActionsLayout(
          deviceClass: deviceClass,
          screenWidth: screenWidth,
          crossAxisCount: 4,
          horizontalPadding: baseUnit * 4, // 32dp
          verticalPadding: baseUnit * 3, // 24dp
          gridSpacing: baseUnit * 3, // 24dp
          bottomSpacing: baseUnit * 3, // 24dp
          cardAspectRatio: 1.1,
          titleFontSize: baseUnit * 4, // 32dp
          subtitleFontSize: baseUnit * 2.25, // 18dp
          cardTitleSize: baseUnit * 2, // 16dp
          countFontSize: baseUnit * 1.75, // 14dp
          iconSize: baseUnit * 10, // 80dp
          iconInnerSize: baseUnit * 5, // 40dp
          cardPadding: baseUnit * 3.5, // 28dp
          borderRadius: baseUnit * 4, // 32dp
          shadowOffset: baseUnit * 1.5, // 12dp
          shadowBlur: baseUnit * 2.5, // 20dp
        );

      case _DeviceClass.large:
        return _QuickActionsLayout(
          deviceClass: deviceClass,
          screenWidth: screenWidth,
          crossAxisCount: 5,
          horizontalPadding: baseUnit * 6, // 48dp
          verticalPadding: baseUnit * 4, // 32dp
          gridSpacing: baseUnit * 4, // 32dp
          bottomSpacing: baseUnit * 4, // 32dp
          cardAspectRatio: 1.15,
          titleFontSize: baseUnit * 4.5, // 36dp
          subtitleFontSize: baseUnit * 2.5, // 20dp
          cardTitleSize: baseUnit * 2.25, // 18dp
          countFontSize: baseUnit * 2, // 16dp
          iconSize: baseUnit * 11, // 88dp
          iconInnerSize: baseUnit * 5.5, // 44dp
          cardPadding: baseUnit * 4, // 32dp
          borderRadius: baseUnit * 4.5, // 36dp
          shadowOffset: baseUnit * 2, // 16dp
          shadowBlur: baseUnit * 3, // 24dp
        );
    }
  }

  /// Determine device class from screen width
  static _DeviceClass _determineDeviceClass(double width) {
    if (width < 600) {
      return _DeviceClass.compact;
    } else if (width < 840) {
      return _DeviceClass.medium;
    } else if (width < 1200) {
      return _DeviceClass.expanded;
    } else {
      return _DeviceClass.large;
    }
  }

  /// Calculate card width using golden ratio
  double get cardWidth {
    final totalPadding = horizontalPadding * 2;
    final spacing = gridSpacing * (crossAxisCount - 1);
    return (screenWidth - totalPadding - spacing) / crossAxisCount;
  }
}

/// Device class enumeration
enum _DeviceClass {
  compact, // < 600dp
  medium, // 600-840dp
  expanded, // 840-1200dp
  large, // > 1200dp
}

/// Quick Action Card with neumorphic design
class _QuickActionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String count;
  final bool isUrgent;
  final _QuickActionsLayout layout;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
    required this.isUrgent,
    required this.layout,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(widget.layout.borderRadius),
          boxShadow: _isPressed ? _getPressedShadows() : _getDefaultShadows(),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.layout.borderRadius),
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Padding(
              padding: EdgeInsets.all(widget.layout.cardPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildIconContainer(),
                  SizedBox(height: widget.layout.cardPadding * 0.75),
                  _buildTitle(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build icon container with gradient and shadow
  Widget _buildIconContainer() {
    // Calculate icon border radius using golden ratio
    final iconBorderRadius = widget.layout.iconSize * 0.28;

    return Container(
      width: widget.layout.iconSize,
      height: widget.layout.iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color.withOpacity(0.2),
            widget.color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(iconBorderRadius),
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        widget.icon,
        color: widget.color,
        size: widget.layout.iconInnerSize,
      ),
    );
  }

  /// Build card title with responsive typography
  Widget _buildTitle() {
    return Flexible(
      child: Text(
        widget.title,
        style: TextStyle(
          fontSize: widget.layout.cardTitleSize,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1E293B),
          height: 1.2,
          letterSpacing: 0.2,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Get default neumorphic shadows
  List<BoxShadow> _getDefaultShadows() {
    return [
      BoxShadow(
        color: const Color(0xFFD1D5DB).withOpacity(0.6),
        blurRadius: widget.layout.shadowBlur,
        offset: Offset(widget.layout.shadowOffset, widget.layout.shadowOffset),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.white.withOpacity(0.9),
        blurRadius: widget.layout.shadowBlur,
        offset: Offset(
          -widget.layout.shadowOffset,
          -widget.layout.shadowOffset,
        ),
        spreadRadius: 0,
      ),
    ];
  }

  /// Get pressed state shadows (flattened)
  List<BoxShadow> _getPressedShadows() {
    final reducedOffset = widget.layout.shadowOffset * 0.5;
    final reducedBlur = widget.layout.shadowBlur * 0.7;

    return [
      BoxShadow(
        color: const Color(0xFFD1D5DB).withOpacity(0.4),
        blurRadius: reducedBlur,
        offset: Offset(reducedOffset, reducedOffset),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.white.withOpacity(0.7),
        blurRadius: reducedBlur,
        offset: Offset(-reducedOffset, -reducedOffset),
        spreadRadius: 0,
      ),
    ];
  }
}
