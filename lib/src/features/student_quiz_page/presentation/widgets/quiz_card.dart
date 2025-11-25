import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/data/quiz_manager.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/pages/quiz_intro_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';

class QuizCardUpdated extends StatefulWidget {
  final Map<String, dynamic> category;
  final int questionsAnswered;
  final VoidCallback onRefresh;

  const QuizCardUpdated({
    super.key,
    required this.category,
    required this.questionsAnswered,
    required this.onRefresh,
  });

  @override
  State<QuizCardUpdated> createState() => _QuizCardUpdatedState();
}

class _QuizCardUpdatedState extends State<QuizCardUpdated> {
  bool _isPressed = false;
  String? _resetTime;

  @override
  void initState() {
    super.initState();
    _loadResetTime();
  }

  Future<void> _loadResetTime() async {
    if (widget.questionsAnswered >= 10) {
      final time = await QuizManager.instance.getNextResetTime();
      if (mounted) {
        setState(() {
          _resetTime = time;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLocked = widget.questionsAnswered >= 10;
    final remaining = 10 - widget.questionsAnswered;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (isLocked) {
          _showLockedDialog();
        } else {
          Future.delayed(const Duration(milliseconds: 50), () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, sa) => QuizIntroScreenUpdated(
                  category: widget.category,
                  onComplete: widget.onRefresh,
                ),
                transitionsBuilder: (c, a, sa, child) => FadeTransition(
                  opacity: a,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.96,
                      end: 1.0,
                    ).animate(CurvedAnimation(parent: a, curve: Curves.easeOut)),
                    child: child,
                  ),
                ),
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          });
        }
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          margin: EdgeInsets.only(bottom: Responsive.hp(context, 2)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(Responsive.wp(context, 5)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.wp(context, 4.5)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isLocked
                          ? [Colors.grey[400]!, Colors.grey[500]!]
                          : widget.category['gradientColors'],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: (isLocked
                                ? Colors.grey[400]!
                                : widget.category['gradientColors'][0])
                            .withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    isLocked ? Icons.lock_rounded : widget.category['icon'],
                    color: Colors.white,
                    size: Responsive.wp(context, 7.5),
                  ),
                ),
                SizedBox(width: Responsive.wp(context, 4)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category['title'],
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 19),
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: Responsive.hp(context, 0.7)),
                      Text(
                        widget.category['description'],
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 13),
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: Responsive.hp(context, 1.2)),
                      Wrap(
                        spacing: Responsive.wp(context, 2),
                        runSpacing: Responsive.hp(context, 0.5),
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.wp(context, 2.5),
                              vertical: Responsive.hp(context, 0.6),
                            ),
                            decoration: BoxDecoration(
                              color: isLocked
                                  ? Colors.grey[200]
                                  : widget.category['gradientColors'][0]
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: Responsive.wp(context, 3.2),
                                  color: isLocked
                                      ? Colors.grey[600]
                                      : widget.category['gradientColors'][0],
                                ),
                                SizedBox(width: Responsive.wp(context, 1)),
                                Text(
                                  '${widget.questionsAnswered}/10',
                                  style: TextStyle(
                                    fontSize: Responsive.sp(context, 11),
                                    fontWeight: FontWeight.w700,
                                    color: isLocked
                                        ? Colors.grey[600]
                                        : widget.category['gradientColors'][0],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isLocked)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Responsive.wp(context, 2.5),
                                vertical: Responsive.hp(context, 0.6),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.play_circle_rounded,
                                    size: Responsive.wp(context, 3.2),
                                    color: Colors.green[700],
                                  ),
                                  SizedBox(width: Responsive.wp(context, 1)),
                                  Text(
                                    '$remaining left',
                                    style: TextStyle(
                                      fontSize: Responsive.sp(context, 11),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (isLocked && _resetTime != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Responsive.wp(context, 2.5),
                                vertical: Responsive.hp(context, 0.6),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.schedule_rounded,
                                    size: Responsive.wp(context, 3.2),
                                    color: Colors.orange[700],
                                  ),
                                  SizedBox(width: Responsive.wp(context, 1)),
                                  Text(
                                    _resetTime!,
                                    style: TextStyle(
                                      fontSize: Responsive.sp(context, 11),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Responsive.wp(context, 2)),
                Container(
                  padding: EdgeInsets.all(Responsive.wp(context, 2.5)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isLocked
                        ? Icons.lock_rounded
                        : Icons.arrow_forward_ios_rounded,
                    color: isLocked
                        ? Colors.grey[600]
                        : widget.category['gradientColors'][0],
                    size: Responsive.wp(context, 4.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLockedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        contentPadding: EdgeInsets.all(Responsive.wp(context, 6)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(Responsive.wp(context, 4)),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_rounded,
                color: Colors.orange,
                size: Responsive.wp(context, 10),
              ),
            ),
            SizedBox(height: Responsive.hp(context, 2.5)),
            Text(
              'Daily Limit Reached',
              style: TextStyle(
                fontSize: Responsive.sp(context, 22),
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: Responsive.hp(context, 1.2)),
            Text(
              'You\'ve completed 10 questions for ${widget.category['title']} today. Come back tomorrow for more!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.sp(context, 14),
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            if (_resetTime != null) ...[
              SizedBox(height: Responsive.hp(context, 2)),
              Container(
                padding: EdgeInsets.all(Responsive.wp(context, 3)),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_rounded,
                      color: Colors.orange[700],
                      size: Responsive.wp(context, 5),
                    ),
                    SizedBox(width: Responsive.wp(context, 2)),
                    Text(
                      'Resets in $_resetTime',
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 14),
                        fontWeight: FontWeight.w700,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: Responsive.hp(context, 3)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.category['gradientColors'][0],
                  padding: EdgeInsets.symmetric(
                    vertical: Responsive.hp(context, 1.7),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Got It',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: Responsive.sp(context, 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}