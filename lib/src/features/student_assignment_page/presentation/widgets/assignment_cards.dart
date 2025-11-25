import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/pages/assignments_detail_page.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AssignmentCard extends StatefulWidget {
  final String assignmentId;
  final String title;
  final String extraDetail;
  final String subject;
  final String difficulty;

  const AssignmentCard({
    super.key,
    required this.assignmentId,
    required this.title,
    required this.extraDetail,
    required this.subject,
    required this.difficulty,
  });

  @override
  State<AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  // Generate unique color based on title
  Color _getCardColor() {
    final hash = widget.title.hashCode.abs();
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEC4899), // Pink
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF10B981), // Emerald
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEF4444), // Red
      const Color(0xFF3B82F6), // Blue
    ];
    return colors[hash % colors.length];
  }

  // Generate icon based on title
  IconData _getTopicIcon() {
    final title = widget.title.toLowerCase();
    if (title.contains('if') || title.contains('else')) {
      return Icons.alt_route_rounded;
    } else if (title.contains('loop') || title.contains('for') || title.contains('while')) {
      return Icons.loop_rounded;
    } else if (title.contains('switch') || title.contains('case')) {
      return Icons.switch_left_rounded;
    } else if (title.contains('function') || title.contains('method')) {
      return Icons.functions_rounded;
    } else if (title.contains('array') || title.contains('list')) {
      return Icons.view_list_rounded;
    } else if (title.contains('class') || title.contains('object')) {
      return Icons.category_rounded;
    } else if (title.contains('string')) {
      return Icons.text_fields_rounded;
    } else if (title.contains('input') || title.contains('scanner')) {
      return Icons.keyboard_rounded;
    } else if (title.contains('java')) {
      return Icons.coffee_rounded;
    } else {
      return Icons.code_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardColor = _getCardColor();
    final topicIcon = _getTopicIcon();

    return Neumorphic(
      style: NeumorphicStyle(
        depth: 10,
        intensity: 0.85,
        surfaceIntensity: 0.35,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(size.width * 0.055),
        ),
        color: const Color(0xFFE2E2E2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Gradient Background
          Container(
            height: size.height * 0.22,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cardColor,
                  cardColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.055),
                topRight: Radius.circular(size.width * 0.055),
              ),
            ),
            child: Stack(
              children: [
                // Decorative Pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PatternPainter(cardColor),
                  ),
                ),

                // Icon in Center
                Center(
                  child: Container(
                    padding: EdgeInsets.all(size.width * 0.08),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      topicIcon,
                      size: size.width * 0.15,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Navigate Button
                Positioned(
                  top: size.height * 0.015,
                  right: size.height * 0.015,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => 
                            AssignmentDetailPage(assignmentId: widget.assignmentId),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: size.width * 0.05,
                        color: cardColor,
                      ),
                    ),
                  ),
                ),

                // Difficulty Badge
                Positioned(
                  top: size.height * 0.015,
                  left: size.height * 0.015,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.006,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(size.width * 0.04),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      widget.difficulty,
                      style: TextStyle(
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(size.width * 0.045),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: size.height * 0.008),

                // Info Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Count
                    Row(
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: size.width * 0.04,
                          color: Colors.black54,
                        ),
                        SizedBox(width: size.width * 0.015),
                        Text(
                          widget.extraDetail,
                          style: TextStyle(
                            fontSize: size.width * 0.037,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    // Subject
                    SizedBox(height: size.height * 0.006),
                    Row(
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: size.width * 0.04,
                          color: Colors.black54,
                        ),
                        SizedBox(width: size.width * 0.015),
                        Expanded(
                          child: Text(
                            widget.subject,
                            style: TextStyle(
                              fontSize: size.width * 0.037,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
    );
  }
}

// Custom Painter for Decorative Pattern
class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw decorative circles
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.2 + (i * 20)),
        20 + (i * 15.0),
        paint,
      );
    }

    // Draw decorative lines
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(size.width * 0.1, size.height * 0.7 + (i * 10)),
        Offset(size.width * 0.3, size.height * 0.7 + (i * 10)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}