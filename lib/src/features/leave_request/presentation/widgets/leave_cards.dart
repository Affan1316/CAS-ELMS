import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class LeaveCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  final VoidCallback onTap;

  const LeaveCard({
    super.key,
    required this.item,
    required this.index,
    required this.onTap,
  });

  double _getResponsiveFontSize(double screenWidth, double mobile, double tablet) {
    if (screenWidth >= 768) return tablet;
    return mobile;
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'sick':
        return const Color(0xFFE74C3C);
      case 'casual':
        return const Color(0xFF3498DB);
      case 'emergency':
        return const Color(0xFFF39C12);
      default:
        return const Color(0xFF9B59B6);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sick':
        return Icons.local_hospital_rounded;
      case 'casual':
        return Icons.person_rounded;
      case 'emergency':
        return Icons.emergency_rounded;
      default:
        return Icons.event_note_rounded;
    }
  }

  // Widget _buildCategoryChip(BuildContext context) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final isTablet = screenWidth >= 768;
    
  //   return Container(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: isTablet ? 16 : 14,
  //       vertical: isTablet ? 10 : 8,
  //     ),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           _getCategoryColor(item['category'] as String).withOpacity(0.15),
  //           _getCategoryColor(item['category'] as String).withOpacity(0.1),
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
  //       border: Border.all(
  //         color: _getCategoryColor(item['category'] as String).withOpacity(0.3),
  //         width: 1,
  //       ),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Container(
  //           width: isTablet ? 10 : 8,
  //           height: isTablet ? 10 : 8,
  //           decoration: BoxDecoration(
  //             color: _getCategoryColor(item['category'] as String),
  //             shape: BoxShape.circle,
  //           ),
  //         ),
  //         SizedBox(width: isTablet ? 10 : 8),
  //         Text(
  //           item['category'] as String,
  //           style: TextStyle(
  //             fontSize: _getResponsiveFontSize(screenWidth, 12, 14),
  //             fontWeight: FontWeight.w600,
  //             color: _getCategoryColor(item['category'] as String),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStatusBadge(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    
    IconData statusIcon;
    switch ((item['status'] as String).toLowerCase()) {
      case 'approved':
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'declined':
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusIcon = Icons.schedule_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 14,
        vertical: isTablet ? 10 : 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (item['statusColor'] as Color).withOpacity(0.15),
            (item['statusColor'] as Color).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        border: Border.all(
          color: (item['statusColor'] as Color).withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: isTablet ? 18 : 16,
            color: item['statusColor'] as Color,
          ),
          SizedBox(width: isTablet ? 8 : 6),
          Text(
            item['status'] as String,
            style: TextStyle(
              fontSize: _getResponsiveFontSize(screenWidth, 12, 14),
              fontWeight: FontWeight.w700,
              color: item['statusColor'] as Color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 768;
    final isLandscape = screenWidth > screenHeight;
    
    // Responsive dimensions
    final cardMargin = isTablet ? 24.0 : 20.0;
    final cardPadding = isTablet ? 32.0 : 24.0;
    final iconSize = isTablet ? 64.0 : 56.0;
    final iconInnerSize = isTablet ? 32.0 : 28.0;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: cardMargin),
        constraints: isTablet ? const BoxConstraints(maxWidth: 800) : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isTablet ? 32 : 28),
            topRight: Radius.circular(isTablet ? 32 : 28),
            bottomLeft: Radius.circular(isTablet ? 28 : 24),
            bottomRight: Radius.circular(isTablet ? 28 : 24),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFFAFBFF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.08),
              blurRadius: isTablet ? 24 : 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: isTablet ? 12 : 10,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isTablet ? 32 : 28),
            topRight: Radius.circular(isTablet ? 32 : 28),
            bottomLeft: Radius.circular(isTablet ? 28 : 24),
            bottomRight: Radius.circular(isTablet ? 28 : 24),
          ),
          child: Stack(
            children: [
              // Decorative background elements
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: isTablet ? 100 : 80,
                  height: isTablet ? 100 : 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _getCategoryColor(item['category'] as String).withOpacity(0.1),
                        _getCategoryColor(item['category'] as String).withOpacity(0.02),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: isTablet ? 120 : 100,
                  height: isTablet ? 120 : 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6366F1).withOpacity(0.05),
                        const Color(0xFF6366F1).withOpacity(0.01),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Main content
              Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with status and category
                    Flex(
                      direction: isLandscape && !isTablet ? Axis.horizontal : Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // _buildCategoryChip(context),
                        _buildStatusBadge(context),
                      ],
                    ),
                    
                    SizedBox(height: isTablet ? 24 : 20),
                    
                    // Leave type and date section
                    Flex(
                      direction: isLandscape && screenWidth < 600 ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon container
                        Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _getCategoryColor(item['category'] as String),
                                _getCategoryColor(item['category'] as String).withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(isTablet ? 20 : 18),
                            boxShadow: [
                              BoxShadow(
                                color: _getCategoryColor(item['category'] as String).withOpacity(0.3),
                                blurRadius: isTablet ? 16 : 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            _getCategoryIcon(item['category'] as String),
                            color: Colors.white,
                            size: iconInnerSize,
                          ),
                        ),
                        
                        SizedBox(
                          width: isLandscape && screenWidth < 600 ? 0 : (isTablet ? 20 : 16),
                          height: isLandscape && screenWidth < 600 ? (isTablet ? 20 : 16) : 0,
                        ),
                        
                        // Leave details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['type'] as String,
                                style: TextStyle(
                                  fontSize: _getResponsiveFontSize(screenWidth, 20, 24),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1D29),
                                  letterSpacing: -0.5,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: isTablet ? 8 : 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    size: isTablet ? 18 : 16,
                                    color: Colors.grey.shade500,
                                  ),
                                  SizedBox(width: isTablet ? 8 : 6),
                                  Expanded(
                                    child: Text(
                                      item['date'] as String,
                                      style: TextStyle(
                                        fontSize: _getResponsiveFontSize(screenWidth, 14, 16),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Arrow button
                        Container(
                          width: isTablet ? 48 : 40,
                          height: isTablet ? 48 : 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: const Color(0xFF6366F1),
                            size: isTablet ? 20 : 18,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: isTablet ? 24 : 20),
                    
                    // Divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.shade200,
                            Colors.grey.shade100,
                            Colors.grey.shade200,
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: isTablet ? 20 : 16),
                    
                    // Bottom section with reason and applied date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reason section
                        if ((item['reason'] as String?)?.isNotEmpty ?? false)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 16 : 12,
                              vertical: isTablet ? 12 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: isTablet ? 18 : 16,
                                  color: Colors.grey.shade600,
                                ),
                                SizedBox(width: isTablet ? 12 : 8),
                                Expanded(
                                  child: Text(
                                    item['reason'] as String,
                                    style: TextStyle(
                                      fontSize: _getResponsiveFontSize(screenWidth, 13, 15),
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        SizedBox(height: isTablet ? 16 : 12),
                        
                        // Applied date
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isTablet ? 8 : 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                              ),
                              child: Icon(
                                Icons.access_time_rounded,
                                size: isTablet ? 16 : 14,
                                color: const Color(0xFF6366F1),
                              ),
                            ),
                            SizedBox(width: isTablet ? 12 : 8),
                            Expanded(
                              child: Text(
                                'Applied on ${item['appliedDate']}',
                                style: TextStyle(
                                  fontSize: _getResponsiveFontSize(screenWidth, 12, 14),
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}