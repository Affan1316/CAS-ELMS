import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/data/quiz_manager.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/domain/services/google_sheets_service.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';
import 'quiz_home_screen.dart';

class ResultScreenUpdated extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final Map<String, dynamic> category;
  final List<QuestionModel> questions;
  final List<bool> answersCorrect;
  final List<int> timeTaken;
  final VoidCallback onComplete;

  const ResultScreenUpdated({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.category,
    required this.questions,
    required this.answersCorrect,
    required this.timeTaken,
    required this.onComplete,
  });

  @override
  State<ResultScreenUpdated> createState() => _ResultScreenUpdatedState();
}

class _ResultScreenUpdatedState extends State<ResultScreenUpdated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isSaving = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
    _saveResults();
  }

  Future<void> _saveResults() async {
    try {
      // Save quiz results to database
      await QuizManager.instance.saveQuizResult(
        category: widget.category['id'],
        questions: widget.questions,
        answers: widget.answersCorrect,
        timeTaken: widget.timeTaken,
      );

      setState(() {
        isSaving = false;
      });
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving results: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.score / widget.totalQuestions * 100).round();
    final passed = percentage >= 60;
    final gradientColors = widget.category['gradientColors'] as List<Color>;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Quiz Complete',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
            fontSize: Responsive.sp(context, 18),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(Responsive.wp(context, 6)),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight -
                    Responsive.wp(context, 12),
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: Responsive.hp(context, 3)),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: Responsive.wp(context, 32),
                        height: Responsive.wp(context, 32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: passed
                                ? [
                                    const Color(0xFF10B981),
                                    const Color(0xFF34D399),
                                  ]
                                : [
                                    const Color(0xFFEF4444),
                                    const Color(0xFFF87171),
                                  ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (passed
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444))
                                  .withOpacity(0.4),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          passed
                              ? Icons.emoji_events_rounded
                              : Icons.refresh_rounded,
                          size: Responsive.wp(context, 16),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.hp(context, 3)),
                    Text(
                      passed ? 'Excellent Work!' : 'Keep Trying!',
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 30),
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.8,
                      ),
                    ),
                    SizedBox(height: Responsive.hp(context, 1)),
                    Text(
                      passed
                          ? 'You did an amazing job!'
                          : 'Practice makes perfect',
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 14),
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isSaving) ...[
                      SizedBox(height: Responsive.hp(context, 2)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                gradientColors[0],
                              ),
                            ),
                          ),
                          SizedBox(width: Responsive.wp(context, 2)),
                          Text(
                            'Saving progress...',
                            style: TextStyle(
                              fontSize: Responsive.sp(context, 12),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: Responsive.hp(context, 3.5)),
                    Container(
                      padding: EdgeInsets.all(Responsive.wp(context, 6)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Your Score',
                            style: TextStyle(
                              fontSize: Responsive.sp(context, 14),
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: Responsive.hp(context, 1.5)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${widget.score}',
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 64),
                                  fontWeight: FontWeight.w800,
                                  color: passed
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                  height: 0.9,
                                  letterSpacing: -2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: Responsive.hp(context, 1.2),
                                ),
                                child: Text(
                                  '/${widget.totalQuestions}',
                                  style: TextStyle(
                                    fontSize: Responsive.sp(context, 28),
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Responsive.hp(context, 2)),
                          Container(
                            padding: EdgeInsets.all(Responsive.wp(context, 4)),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStat(
                                  context,
                                  Icons.check_circle_rounded,
                                  'Correct',
                                  '${widget.score}',
                                  const Color(0xFF10B981),
                                ),
                                Container(
                                  width: 1.5,
                                  height: Responsive.hp(context, 5.5),
                                  color: const Color(0xFFE9ECEF),
                                ),
                                _buildStat(
                                  context,
                                  Icons.cancel_rounded,
                                  'Wrong',
                                  '${widget.totalQuestions - widget.score}',
                                  const Color(0xFFEF4444),
                                ),
                                Container(
                                  width: 1.5,
                                  height: Responsive.hp(context, 5.5),
                                  color: const Color(0xFFE9ECEF),
                                ),
                                _buildStat(
                                  context,
                                  Icons.percent_rounded,
                                  'Score',
                                  '$percentage%',
                                  const Color(0xFF6366F1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(height: Responsive.hp(context, 3)),
                    SizedBox(
                      width: double.infinity,
                      height: Responsive.hp(context, 6.5),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFE9ECEF),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          widget.onComplete();
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a, sa) => const  QuizHomeScreen(),
                              transitionsBuilder: (c, a, sa, child) =>
                                  FadeTransition(opacity: a, child: child),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Back to Home',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 16),
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.hp(context, 2)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Flexible(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.wp(context, 2.75)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: Responsive.wp(context, 6.5)),
          ),
          SizedBox(height: Responsive.hp(context, 1.2)),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.sp(context, 22),
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: Responsive.hp(context, 0.25)),
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.sp(context, 11),
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}