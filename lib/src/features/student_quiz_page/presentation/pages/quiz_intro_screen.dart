import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/data/quiz_manager.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/pages/quiz_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';

class QuizIntroScreenUpdated extends StatefulWidget {
  final Map<String, dynamic> category;
  final VoidCallback onComplete;

  const QuizIntroScreenUpdated({
    super.key,
    required this.category,
    required this.onComplete,
  });

  @override
  State<QuizIntroScreenUpdated> createState() => _QuizIntroScreenUpdatedState();
}

class _QuizIntroScreenUpdatedState extends State<QuizIntroScreenUpdated> {
  bool isLoading = false;
  int remainingQuestions = 10;

  @override
  void initState() {
    super.initState();
    _loadRemainingQuestions();
  }

  Future<void> _loadRemainingQuestions() async {
    final remaining = await QuizManager.instance.getRemainingQuestions(
      widget.category['id'],
    );
    setState(() {
      remainingQuestions = remaining;
    });
  }

  Future<void> _startQuiz() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Check if user can attempt
      final canAttempt = await QuizManager.instance.canAttemptQuiz(
        widget.category['id'],
      );

      if (!canAttempt) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Daily limit reached for ${widget.category['title']}',
              ),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.pop(context);
        }
        return;
      }

      // Fetch questions from Google Sheets
      final questions = await QuizManager.instance.getDailyQuestions(
        widget.category['id'],
      );

      if (questions.isEmpty) {
        throw Exception('No questions available');
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (c, a, sa) => QuizScreenUpdated(
                  category: widget.category,
                  questions: questions,
                  onComplete: widget.onComplete,
                ),
            transitionsBuilder:
                (c, a, sa, child) => FadeTransition(opacity: a, child: child),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.category['gradientColors'] as List<Color>;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(Responsive.wp(context, 2)),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: gradientColors[0],
              size: Responsive.wp(context, 4.5),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quiz Overview',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
            fontSize: Responsive.sp(context, 18),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Responsive.wp(context, 6)),
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: EdgeInsets.all(Responsive.wp(context, 10.5)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  widget.category['icon'],
                  size: Responsive.wp(context, 21),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Responsive.hp(context, 4.5)),
              Text(
                widget.category['title'],
                style: TextStyle(
                  fontSize: Responsive.sp(context, 38),
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -1,
                ),
              ),
              SizedBox(height: Responsive.hp(context, 1.5)),
              Text(
                widget.category['description'],
                style: TextStyle(
                  fontSize: Responsive.sp(context, 16),
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: Responsive.hp(context, 5)),
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
                    _buildInfoRow(
                      context,
                      Icons.help_outline_rounded,
                      'Questions Today',
                      '$remainingQuestions',
                      gradientColors,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.hp(context, 2.2),
                      ),
                      child: const Divider(height: 1, thickness: 1),
                    ),
                    _buildInfoRow(
                      context,
                      Icons.schedule_rounded,
                      'Time Per Question',
                      '20 sec',
                      gradientColors,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.hp(context, 2.2),
                      ),
                      child: const Divider(height: 1, thickness: 1),
                    ),
                    _buildInfoRow(
                      context,
                      Icons.workspace_premium_rounded,
                      'Points Available',
                      '${remainingQuestions * 10}',
                      gradientColors,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: Responsive.hp(context, 7),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gradientColors[0],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: isLoading ? null : _startQuiz,
                  child:
                      isLoading
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            'Start Quiz Now',
                            style: TextStyle(
                              fontSize: Responsive.sp(context, 17),
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    List<Color> gradientColors,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(Responsive.wp(context, 3)),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: Responsive.wp(context, 5.5),
          ),
        ),
        SizedBox(width: Responsive.wp(context, 4)),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: Responsive.sp(context, 15),
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.sp(context, 16),
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
