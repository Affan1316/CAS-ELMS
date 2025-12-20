import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';
import '../shared/enums.dart';

class LeaveRequestCard extends StatelessWidget {
  final Leave leave;
  final int originalIndex;
  final Function(int, LeaveStatus) onStatusUpdate;
  final Function(Leave) onViewDetails;
  final bool isMobile;
  final bool isDesktop;

  const LeaveRequestCard({
    super.key,
    required this.leave,
    required this.originalIndex,
    required this.onStatusUpdate,
    required this.onViewDetails,
    required this.isMobile,
    required this.isDesktop,
  });

  static const double _borderRadiusLarge = 24.0;
  static const double _borderRadiusSmall = 16.0;
  static const double _paddingLarge = 24.0;
  static const double _paddingSmall = 16.0;
  static const double _spacingLarge = 20.0;
  static const double _spacingSmall = 12.0;
  static const double _avatarRadiusLarge = 28.0;
  static const double _avatarRadiusSmall = 24.0;
  static const double _iconSizeLarge = 56.0;
  static const double _iconSizeSmall = 48.0;
  static const double _buttonHeightLarge = 48.0;
  static const double _buttonHeightSmall = 44.0;
  static const double _minTouchTarget = 44.0;

  // Updated Colors based on Palette
  static const Color _primaryColor = Color(0xFF3B82F6); // Primary Start
  static const Color _surfaceColor = Color(0xFFFFFFFF); // Component Background
  static const Color _backgroundColor = Color(0xFFF8F9FD); // App Background
  static const Color _textPrimaryColor = Color(0xFF111827); // Primary Text
  static const Color _textSecondaryColor = Color(0xFF374151); // Secondary Text
  static const Color _borderColor = Color(0xFFE5E7EB); // Borders
  static const Color _successColor = Color(0xFF10B981);
  static const Color _errorColor = Color(0xFFEF4444);

  Color _getCategoryColor(String leaveType) {
    switch (leaveType.toLowerCase()) {
      case 'sick':
        return const Color(0xFFEF4444);
      case 'casual':
        return const Color(0xFF3B82F6); // Updated to Primary Start
      case 'emergency':
        return const Color(0xFFF59E0B);
      case 'maternity':
        return const Color(0xFF10B981);
      case 'annual':
        return const Color(0xFF8B5CF6);
      default:
        return _primaryColor;
    }
  }

  IconData _getCategoryIcon(String leaveType) {
    switch (leaveType.toLowerCase()) {
      case 'sick':
        return Icons.local_hospital_rounded;
      case 'casual':
        return Icons.person_rounded;
      case 'emergency':
        return Icons.emergency_rounded;
      case 'maternity':
        return Icons.child_care_rounded;
      case 'annual':
        return Icons.calendar_today_rounded;
      default:
        return Icons.event_note_rounded;
    }
  }

  double _getResponsiveSize(double largeSize, double smallSize) {
    return isMobile ? smallSize : largeSize;
  }

  double get _borderRadius =>
      _getResponsiveSize(_borderRadiusLarge, _borderRadiusSmall);
  double get _padding => _getResponsiveSize(_paddingLarge, _paddingSmall);
  double get _spacing => _getResponsiveSize(_spacingLarge, _spacingSmall);
  double get _avatarRadius =>
      _getResponsiveSize(_avatarRadiusLarge, _avatarRadiusSmall);
  double get _iconContainerSize =>
      _getResponsiveSize(_iconSizeLarge, _iconSizeSmall);
  double get _buttonHeight =>
      _getResponsiveSize(_buttonHeightLarge, _buttonHeightSmall);

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = !isMobile;
    final status = LeaveStatusHelper.stringToLeaveStatus(leave.status);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 16 : 0),
      constraints: isTablet ? const BoxConstraints(maxWidth: 800) : null,
      decoration: _buildCardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Stack(
          children: [
            _buildBackgroundDecoration(),
            Padding(
              padding: EdgeInsets.all(_padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(status, isLargeScreen),
                  SizedBox(height: _spacing),
                  _buildLeaveTypeSection(isLargeScreen),
                  SizedBox(height: _spacing),
                  _buildDivider(),
                  SizedBox(height: _spacing * 0.8),
                  _buildReasonSection(isLargeScreen),
                  SizedBox(height: _spacing),
                  _buildBottomSection(isLargeScreen, screenWidth),
                  SizedBox(height: _spacing),
                  _buildActionButtons(
                    context,
                    leave,
                    originalIndex,
                    isLargeScreen,
                    status,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(_borderRadius),
      color: _surfaceColor,
      boxShadow: [
        BoxShadow(
          color: _primaryColor.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
      border: Border.all(color: _borderColor, width: 1),
    );
  }

  Widget _buildBackgroundDecoration() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_surfaceColor, _backgroundColor],
            stops: [0.0, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(LeaveStatus status, bool isLargeScreen) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_avatarRadius),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: _primaryColor,
            radius: _avatarRadius,
            child: Text(
              UIHelper.getInitials(leave.studentName),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: _getResponsiveSize(16, 14),
              ),
            ),
          ),
        ),
        SizedBox(width: _spacing * 0.8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leave.studentName,
                style: TextStyle(
                  fontSize: _getResponsiveSize(20, 18),
                  fontWeight: FontWeight.w700,
                  color: _textPrimaryColor,
                  letterSpacing: -0.3,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.badge_outlined,
                    size: 16,
                    color: _textSecondaryColor,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Section: ${leave.section}",
                    style: TextStyle(
                      fontSize: _getResponsiveSize(14, 12),
                      color: _textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildStatusBadge(status, isLargeScreen),
      ],
    );
  }

  Widget _buildStatusBadge(LeaveStatus status, bool isLargeScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsiveSize(16, 12),
        vertical: _getResponsiveSize(10, 8),
      ),
      decoration: BoxDecoration(
        color: LeaveStatusHelper.getStatusColor(status).withOpacity(0.12),
        borderRadius: BorderRadius.circular(_getResponsiveSize(20, 16)),
        border: Border.all(
          color: LeaveStatusHelper.getStatusColor(status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status == LeaveStatus.approved
                ? Icons.check_circle_rounded
                : status == LeaveStatus.rejected
                ? Icons.cancel_rounded
                : Icons.schedule_rounded,
            size: _getResponsiveSize(16, 14),
            color: LeaveStatusHelper.getStatusColor(status),
          ),
          SizedBox(width: _getResponsiveSize(6, 4)),
          Text(
            LeaveStatusHelper.getStatusText(status),
            style: TextStyle(
              color: LeaveStatusHelper.getStatusColor(status),
              fontSize: _getResponsiveSize(13, 11),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveTypeSection(bool isLargeScreen) {
    // Debug prints
    print('DEBUG - fromDate: ${leave.fromDate}');
    print('DEBUG - toDate: ${leave.toDate}');
    print('DEBUG - currentDate: ${leave.currentDate}');

    return Row(
      children: [
        Container(
          width: _iconContainerSize,
          height: _iconContainerSize,
          decoration: BoxDecoration(
            color: _getCategoryColor(leave.leaveType),
            borderRadius: BorderRadius.circular(_getResponsiveSize(16, 12)),
            boxShadow: [
              BoxShadow(
                color: _getCategoryColor(leave.leaveType).withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            _getCategoryIcon(leave.leaveType),
            color: Colors.white,
            size: _getResponsiveSize(28, 24),
          ),
        ),
        SizedBox(width: _spacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leave.leaveType,
                style: TextStyle(
                  fontSize: _getResponsiveSize(22, 18),
                  fontWeight: FontWeight.w700,
                  color: _textPrimaryColor,
                  letterSpacing: -0.3,
                  height: 1.2,
                ),
              ),
              SizedBox(height: _getResponsiveSize(8, 6)),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: _getResponsiveSize(18, 16),
                    color: _textSecondaryColor,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${leave.fromDate} - ${leave.toDate}",
                      style: TextStyle(
                        fontSize: _getResponsiveSize(15, 13),
                        fontWeight: FontWeight.w500,
                        color: _textSecondaryColor,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: const BoxDecoration(color: _borderColor),
    );
  }

  Widget _buildReasonSection(bool isLargeScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_getResponsiveSize(16, 12)),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: _getResponsiveSize(18, 16),
            color: _textSecondaryColor,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              leave.reason,
              style: TextStyle(
                fontSize: _getResponsiveSize(15, 14),
                color: _textPrimaryColor,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(bool isLargeScreen, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet(screenWidth) ? 8 : 6),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF3B82F6,
                ).withOpacity(0.1), // Updated to Primary Start
                borderRadius: BorderRadius.circular(
                  isTablet(screenWidth) ? 10 : 8,
                ),
              ),
              child: Icon(
                Icons.access_time_rounded,
                size: isTablet(screenWidth) ? 16 : 14,
                color: const Color(0xFF3B82F6), // Updated to Primary Start
              ),
            ),
            SizedBox(width: isTablet(screenWidth) ? 12 : 8),
            Expanded(
              child: Text(
                'Applied on ${leave.currentDate}',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(screenWidth, 12, 14),
                  color: const Color(
                    0xFF6B7280,
                  ), // Updated to Cool Gray/Input Icons
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool isTablet(double screenWidth) {
    return screenWidth >= 768 && screenWidth < 1024;
  }

  double _getResponsiveFontSize(
    double screenWidth,
    double small,
    double large,
  ) {
    return screenWidth < 768 ? small : large;
  }

  Widget _buildActionButtons(
    BuildContext context,
    Leave leave,
    int originalIndex,
    bool isLargeScreen,
    LeaveStatus status,
  ) {
    if (status == LeaveStatus.pending) {
      if (isLargeScreen) {
        return Row(
          children: [
            Expanded(
              child: _buildActionButton(
                onPressed:
                    () => onStatusUpdate(originalIndex, LeaveStatus.approved),
                icon: Icons.check_circle_outline,
                label: "Approve",
                backgroundColor: _successColor,
                foregroundColor: Colors.white,
                isOutlined: false,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                onPressed:
                    () => onStatusUpdate(originalIndex, LeaveStatus.rejected),
                icon: Icons.cancel_outlined,
                label: "Reject",
                backgroundColor: _errorColor,
                foregroundColor: Colors.white,
                isOutlined: false,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                onPressed: () => onViewDetails(leave),
                icon: Icons.visibility_outlined,
                label: "View",
                backgroundColor: _primaryColor,
                foregroundColor: _primaryColor,
                isOutlined: true,
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    onPressed:
                        () =>
                            onStatusUpdate(originalIndex, LeaveStatus.approved),
                    label: "Approve",
                    backgroundColor: _successColor,
                    foregroundColor: Colors.white,
                    isOutlined: false,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    onPressed:
                        () =>
                            onStatusUpdate(originalIndex, LeaveStatus.rejected),
                    label: "Reject",
                    backgroundColor: _errorColor,
                    foregroundColor: Colors.white,
                    isOutlined: false,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: _buildActionButton(
                onPressed: () => onViewDetails(leave),
                label: "View Details",
                backgroundColor: _primaryColor,
                foregroundColor: _primaryColor,
                isOutlined: true,
              ),
            ),
          ],
        );
      }
    } else {
      return SizedBox(
        width: double.infinity,
        child: _buildActionButton(
          onPressed: () => onViewDetails(leave),
          icon: Icons.visibility_outlined,
          label: "View Details",
          backgroundColor: _primaryColor,
          foregroundColor: _primaryColor,
          isOutlined: true,
        ),
      );
    }
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    IconData? icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required bool isOutlined,
  }) {
    final buttonHeight =
        _buttonHeight > _minTouchTarget ? _buttonHeight : _minTouchTarget;

    if (isOutlined) {
      return SizedBox(
        height: buttonHeight,
        child:
            icon != null
                ? OutlinedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(icon, size: 18),
                  label: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: _getResponsiveSize(15, 14),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: foregroundColor,
                    side: BorderSide(color: foregroundColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
                : OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: foregroundColor,
                    side: BorderSide(color: foregroundColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: _getResponsiveSize(15, 14),
                    ),
                  ),
                ),
      );
    } else {
      return SizedBox(
        height: buttonHeight,
        child:
            icon != null
                ? ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(icon, size: 18),
                  label: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: _getResponsiveSize(15, 14),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
                : ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: _getResponsiveSize(15, 14),
                    ),
                  ),
                ),
      );
    }
  }
}
