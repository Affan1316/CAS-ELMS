import 'dart:ui';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class BulidCourseCard extends StatelessWidget {
  const BulidCourseCard({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final bool enrolling = course['enrolling'];
    
    // Enhanced gradient colors
    final gradientColors = enrolling 
        ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
        : [const Color(0xFF64748B), const Color(0xFF475569)];
    
    final statusColor = enrolling ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    
    // Responsive sizing
    final cardPadding = screenWidth * 0.055;
    final iconSize = screenWidth * 0.065;
    final titleSize = screenWidth * 0.052;
    final descSize = screenWidth * 0.038;
    final buttonHeight = screenHeight * 0.065;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.055),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.25),
            blurRadius: screenWidth * 0.06,
            offset: Offset(0, screenHeight * 0.012),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(screenWidth * 0.055),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.055),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
            child: Stack(
              children: [
                // Decorative background circles
                Positioned(
                  top: -screenWidth * 0.12,
                  right: -screenWidth * 0.12,
                  child: Container(
                    width: screenWidth * 0.35,
                    height: screenWidth * 0.35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                
                // Main content
                Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with icon and status
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(screenWidth * 0.04),
                            ),
                            child: Icon(
                              _getCourseIcon(course['title']),
                              color: Colors.white,
                              size: iconSize,
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Status badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.008,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(screenWidth * 0.05),
                              border: Border.all(
                                color: statusColor.withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: screenWidth * 0.015,
                                  height: screenWidth * 0.015,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: statusColor.withOpacity(0.5),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.015),
                                Text(
                                  enrolling ? 'OPEN' : 'CLOSED',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: screenWidth * 0.028,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: screenHeight * 0.022),
                      
                      // Course title
                      Text(
                        course['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: screenHeight * 0.015),
                      
                      // Description
                      Expanded(
                        child: Text(
                          course['description'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: descSize,
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.02),
                      
                      // Enrollment info
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.014,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_rounded,
                              size: screenWidth * 0.045,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              '${course['enrollments']} enrolled',
                              style: TextStyle(
                                fontSize: screenWidth * 0.034,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.018),
                      
                      // Enroll button
                      Container(
                        width: double.infinity,
                        height: buttonHeight,
                        decoration: BoxDecoration(
                          gradient: enrolling
                              ? const LinearGradient(
                                  colors: [Colors.white, Color(0xFFF8F9FA)],
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(screenWidth * 0.04),
                          boxShadow: enrolling ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ] : [],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: enrolling ? () {} : null,
                            borderRadius: BorderRadius.circular(screenWidth * 0.04),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    enrolling ? 'Enroll Now' : 'Not Available',
                                    style: TextStyle(
                                      color: enrolling 
                                          ? gradientColors[1]
                                          : Colors.white.withOpacity(0.5),
                                      fontWeight: FontWeight.w800,
                                      fontSize: screenWidth * 0.042,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  if (enrolling) ...[
                                    SizedBox(width: screenWidth * 0.02),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: gradientColors[1],
                                      size: screenWidth * 0.05,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  IconData _getCourseIcon(String title) {
    if (title.contains('AI') || title.contains('Artificial')) return Icons.psychology_rounded;
    if (title.contains('Android')) return Icons.android_rounded;
    if (title.contains('Flutter')) return Icons.flutter_dash_rounded;
    if (title.contains('Game')) return Icons.sports_esports_rounded;
    if (title.contains('Robot')) return Icons.smart_toy_rounded;
    if (title.contains('Go')) return Icons.code_rounded;
    if (title.contains('Web')) return Icons.web_rounded;
    if (title.contains('Blockchain')) return Icons.currency_bitcoin_rounded;
    if (title.contains('UI') || title.contains('UX')) return Icons.palette_rounded;
    return Icons.school_rounded;
  }
}