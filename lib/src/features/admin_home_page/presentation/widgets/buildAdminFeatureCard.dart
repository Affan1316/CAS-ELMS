// FILE: lib/src/features/admin_home_page/presentation/widgets/buildAdminFeatureCard.dart

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/presentation/pages/add_course_page.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/DayWiseFeePage.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/FavouredStudentsScreen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_defaulters.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_history_screen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/groups_list_screen.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/pages/create_group_page.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/pages/read_group_page.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/pages/add_inquiry_page.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/pages/inquiry_detail_page.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/pages/admin_leave_request_management.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_enrollment_screen.dart';
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/pages/workshop_time_group_page.dart';

import '../../../certificate_creation_page/presentation/pages/createCertificatePage.dart';

/// Responsive Admin Feature Card with Geometric Design Principles
///
/// Design Principles:
/// - 8dp grid system for precise spacing
/// - Golden ratio (φ ≈ 1.618) for proportional scaling
/// - Material Design 3 responsive breakpoints
/// - Euclidean geometry for shadow calculations
/// - Micro-interactions with haptic feedback
Widget buildAdminFeatureCard(
  Map<String, dynamic> feature,
  int index,
  BuildContext context, {
  int? badgeCount,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final layout = _AdminCardLayout.calculate(
        MediaQuery.of(context).size.width,
      );

      return _AdminFeatureCard(
        feature: feature,
        index: index,
        badgeCount: badgeCount,
        layout: layout,
      );
    },
  );
}

/// Responsive layout configuration class
class _AdminCardLayout {
  final _DeviceClass deviceClass;
  final double screenWidth;

  // Card dimensions
  final double padding;
  final double borderRadius;
  final double iconContainerSize;
  final double iconPadding;
  final double iconSize;

  // Typography
  final double titleFontSize;
  final double subtitleFontSize;
  final double badgeFontSize;

  // Spacing
  final double spacing;
  final double badgePadding;

  // Shadow dimensions
  final double shadowBlur;
  final double shadowOffset;
  final double elevation;

  const _AdminCardLayout({
    required this.deviceClass,
    required this.screenWidth,
    required this.padding,
    required this.borderRadius,
    required this.iconContainerSize,
    required this.iconPadding,
    required this.iconSize,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.badgeFontSize,
    required this.spacing,
    required this.badgePadding,
    required this.shadowBlur,
    required this.shadowOffset,
    required this.elevation,
  });

  /// Calculate layout based on screen width using geometric principles
  static _AdminCardLayout calculate(double screenWidth) {
    // Metrological constants
    const baseUnit = 8.0;
    const goldenRatio = 1.618;

    // Determine device class
    final deviceClass = _determineDeviceClass(screenWidth);

    // Calculate responsive values based on device class
    switch (deviceClass) {
      case _DeviceClass.compact:
        // Phones: < 600dp
        final isVerySmall = screenWidth < 360;

        return _AdminCardLayout(
          deviceClass: deviceClass,
          screenWidth: screenWidth,
          padding: isVerySmall ? baseUnit * 2 : baseUnit * 2.5, // 16-20dp
          borderRadius: baseUnit * 2.5, // 20dp
          iconContainerSize: baseUnit * 7, // 56dp
          iconPadding: baseUnit * 2, // 16dp
          iconSize: baseUnit * 4, // 32dp
          titleFontSize:
              isVerySmall ? baseUnit * 1.875 : baseUnit * 2, // 15-16dp
          subtitleFontSize: baseUnit * 1.5, // 12dp
          badgeFontSize: baseUnit * 1.5, // 12dp
          spacing: baseUnit * 2, // 16dp
          badgePadding: baseUnit, // 8dp
          shadowBlur: baseUnit * 2, // 16dp
          shadowOffset: baseUnit * 0.5, // 4dp
          elevation: 4.0,
        );

      case _DeviceClass.medium:
        // Tablets portrait: 600-840dp
        return _AdminCardLayout(
          deviceClass: deviceClass,
          screenWidth: screenWidth,
          padding: baseUnit * 2.75, // 22dp
          borderRadius: baseUnit * 2.5, // 20dp
          iconContainerSize: baseUnit * 8, // 64dp
          iconPadding: baseUnit * 2.25, // 18dp
          iconSize: baseUnit * 4.25, // 34dp
          titleFontSize: baseUnit * 2, // 16dp
          subtitleFontSize: baseUnit * 1.625, // 13dp
          badgeFontSize: baseUnit * 1.625, // 13dp
          spacing: baseUnit * 2.25, // 18dp
          badgePadding: baseUnit * 1.125, // 9dp
          shadowBlur: baseUnit * 2.25, // 18dp
          shadowOffset: baseUnit * 0.5, // 4dp
          elevation: 6.0,
        );

      case _DeviceClass.expanded:
        // Tablets landscape: 840-1200dp
        return _AdminCardLayout(
          deviceClass: deviceClass,
          screenWidth: screenWidth,
          padding: baseUnit * 3, // 24dp
          borderRadius: baseUnit * 2.5, // 20dp
          iconContainerSize: baseUnit * 9, // 72dp
          iconPadding: baseUnit * 2.25, // 18dp
          iconSize: baseUnit * 4.5, // 36dp
          titleFontSize: baseUnit * 2.125, // 17dp
          subtitleFontSize: baseUnit * 1.625, // 13dp
          badgeFontSize: baseUnit * 1.75, // 14dp
          spacing: baseUnit * 2.25, // 18dp
          badgePadding: baseUnit * 1.25, // 10dp
          shadowBlur: baseUnit * 2.5, // 20dp
          shadowOffset: baseUnit * 0.5, // 4dp
          elevation: 8.0,
        );

      case _DeviceClass.large:
        // Desktops: > 1200dp
        return _AdminCardLayout(
          deviceClass: deviceClass,
          screenWidth: screenWidth,
          padding: baseUnit * 3.5, // 28dp
          borderRadius: baseUnit * 3, // 24dp
          iconContainerSize: baseUnit * 10, // 80dp
          iconPadding: baseUnit * 2.5, // 20dp
          iconSize: baseUnit * 5, // 40dp
          titleFontSize: baseUnit * 2.25, // 18dp
          subtitleFontSize: baseUnit * 1.75, // 14dp
          badgeFontSize: baseUnit * 1.75, // 14dp
          spacing: baseUnit * 2.5, // 20dp
          badgePadding: baseUnit * 1.5, // 12dp
          shadowBlur: baseUnit * 3, // 24dp
          shadowOffset: baseUnit * 0.75, // 6dp
          elevation: 10.0,
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

  /// Calculate icon container border radius using golden ratio
  double get iconBorderRadius => iconContainerSize * 0.28;
}

/// Device class enumeration
enum _DeviceClass {
  compact, // < 600dp
  medium, // 600-840dp
  expanded, // 840-1200dp
  large, // > 1200dp
}

/// Admin Feature Card with animations and micro-interactions
class _AdminFeatureCard extends StatefulWidget {
  final Map<String, dynamic> feature;
  final int index;
  final int? badgeCount;
  final _AdminCardLayout layout;

  const _AdminFeatureCard({
    required this.feature,
    required this.index,
    required this.badgeCount,
    required this.layout,
  });

  @override
  State<_AdminFeatureCard> createState() => _AdminFeatureCardState();
}

class _AdminFeatureCardState extends State<_AdminFeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
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
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _elevationAnimation = Tween<double>(
      begin: widget.layout.elevation,
      end: widget.layout.elevation * 0.5,
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
    HapticFeedback.mediumImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    _navigateToScreen(context, widget.index);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget cardContent = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.layout.borderRadius),
              border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
              boxShadow: _buildShadows(),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.layout.borderRadius),
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                child: Padding(
                  padding: EdgeInsets.all(widget.layout.padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconContainer(),
                      SizedBox(height: widget.layout.spacing),
                      _buildTitle(),
                      const SizedBox(height: 4),
                      _buildSubtitle(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    // Wrap with badge if needed
    if (widget.badgeCount != null && widget.badgeCount! > 0) {
      return badges.Badge(
        badgeContent: Text(
          widget.badgeCount.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: widget.layout.badgeFontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
        badgeStyle: badges.BadgeStyle(
          badgeColor: Colors.red,
          padding: EdgeInsets.all(widget.layout.badgePadding),
          borderRadius: BorderRadius.circular(16),
          elevation: 12,
        ),
        position: badges.BadgePosition.topEnd(top: -10, end: -5),
        child: cardContent,
      );
    }

    return cardContent;
  }

  /// Build icon container with responsive sizing
  Widget _buildIconContainer() {
    return Container(
      width: widget.layout.iconContainerSize,
      height: widget.layout.iconContainerSize,
      padding: EdgeInsets.all(widget.layout.iconPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(widget.layout.iconBorderRadius),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Icon(
        widget.feature['icon'] as IconData,
        size: widget.layout.iconSize,
        color: const Color(0xFF3B82F6),
      ),
    );
  }

  /// Build card title with responsive typography
  Widget _buildTitle() {
    return Text(
      widget.feature['title'] as String,
      style: TextStyle(
        fontSize: widget.layout.titleFontSize,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
        height: 1.2,
        letterSpacing: 0.1,
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build card subtitle with responsive typography
  Widget _buildSubtitle() {
    return Text(
      widget.feature['subtitle'] as String,
      style: TextStyle(
        fontSize: widget.layout.subtitleFontSize,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
        height: 1.3,
        letterSpacing: 0.1,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build responsive shadows with elevation
  List<BoxShadow> _buildShadows() {
    final elevation = _elevationAnimation.value;
    final blur =
        widget.layout.shadowBlur * (elevation / widget.layout.elevation);
    final offset =
        widget.layout.shadowOffset * (elevation / widget.layout.elevation);

    return [
      BoxShadow(
        color: const Color(0xFF000000).withOpacity(0.06),
        blurRadius: blur,
        offset: Offset(0, offset),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color(0xFF000000).withOpacity(0.04),
        blurRadius: blur * 0.5,
        offset: Offset(0, offset * 0.5),
        spreadRadius: 0,
      ),
    ];
  }
}

/// Navigation handler for admin features
void _navigateToScreen(BuildContext context, int index) {
  print('Navigation triggered for index: $index');

  try {
    switch (index) {
      case 0:
        print('Navigating to Pay Fee');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => GroupsListScreen(
                  isNavigateToAttendence: false,
                  isNavigateToWorkShopGraphPage: false,
                ),
          ),
        );
        break;

      case 1:
        print('Navigating to Fee Defaulter');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FeeDefaulters()),
        );
        break;

      case 2:
        print('Navigating to Create Group');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CreateGroupPage()),
        );
        break;

      case 3:
        print('Navigating to Enroll Student');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StudentEnrollmentScreen()),
        );
        break;

      case 4:
        print('Navigating to AddCoursesPage');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddCoursesPage()),
        );
        break;

      case 5:
        print('Navigating to Inquiry Page');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => InquiryDetailPage()),
        );
        break;

      case 6:
        print('Navigating to FeeHistoryScreen');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DayWiseFeePage()),
        );
        break;

      case 7:
        print('Navigating to Add Inquiry');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddInquiryPage()),
        );
        break;

      case 8:
        print('Navigating to Group Detail');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupMainDetailPage()),
        );
        break;

      case 9:
        print('Navigating to Workshop Time');
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GroupWorkshopTimePage()),
        );
        break;

      case 10:
        print('Navigating to Admin Leave Management System');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => GroupsListScreen(
                  isNavigateToAttendence: true,
                  isNavigateToWorkShopGraphPage: false,
                ),
          ),
        );
      case 11:
        print('Navigating to Admin Leave Management System');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AdminLeaveRequestManagement(),
          ),
        );
        break;
      case 12:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FavouredStudentsScreen()),
        );
        break;
      case 13:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CreateCertificatePage()),
        );
        break;

      default:
        print('Invalid index: $index');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Feature not available')));
        break;
    }
  } catch (e) {
    print('Navigation error: $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigation error: $e')));
  }
}
