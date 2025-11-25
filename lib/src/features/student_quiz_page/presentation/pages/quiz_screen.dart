import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_cas_app_main/src/features/student_quiz_page/domain/services/google_sheets_service.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/pages/result_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';

class QuizScreenUpdated extends StatefulWidget {
  final Map<String, dynamic> category;
  final List<QuestionModel> questions;
  final VoidCallback onComplete;

  const QuizScreenUpdated({
    super.key,
    required this.category,
    required this.questions,
    required this.onComplete,
  });

  @override
  State<QuizScreenUpdated> createState() => _QuizScreenUpdatedState();
}

class _QuizScreenUpdatedState extends State<QuizScreenUpdated>
    with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  int score = 0;
  bool answered = false;
  Timer? timer;
  int timeLeft = 0;
  late AnimationController _progressController;
  late AnimationController _pulseController;

  // Track answers and time for database
  List<bool> answersCorrect = [];
  List<int> timeTaken = [];
  int questionStartTime = 0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    startTimer();
    _progressController.forward();
    questionStartTime = DateTime.now().millisecondsSinceEpoch;
  }

  void startTimer() {
    timeLeft = 20; // 20 seconds as per your requirement
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
          } else {
            // Time's up - mark as wrong
            selectAnswer(-1); // -1 means no answer (timeout)
          }
        });
      }
    });
  }

  void selectAnswer(int index) {
    if (answered) return;

    final question = widget.questions[currentQuestionIndex];
    final isCorrect = index == question.correctAnswerIndex;
    final elapsedTime =
        (DateTime.now().millisecondsSinceEpoch - questionStartTime) ~/ 1000;

    setState(() {
      selectedAnswer = index;
      answered = true;
      if (isCorrect) {
        score++;
      }
    });

    // Save answer data
    answersCorrect.add(isCorrect);
    timeTaken.add(elapsedTime);

    timer?.cancel();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        answered = false;
        questionStartTime = DateTime.now().millisecondsSinceEpoch;
      });
      _progressController.reset();
      _progressController.forward();
      startTimer();
    } else {
      timer?.cancel();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a, sa) => ResultScreenUpdated(
              score: score,
              totalQuestions: widget.questions.length,
              category: widget.category,
              questions: widget.questions,
              answersCorrect: answersCorrect,
              timeTaken: timeTaken,
              onComplete: widget.onComplete,
            ),
            transitionsBuilder: (c, a, sa, child) =>
                FadeTransition(opacity: a, child: child),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / widget.questions.length;
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
              Icons.close_rounded,
              color: gradientColors[0],
              size: Responsive.wp(context, 5),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
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
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                        size: Responsive.wp(context, 10),
                      ),
                    ),
                    SizedBox(height: Responsive.hp(context, 2.5)),
                    Text(
                      'Exit Quiz?',
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 22),
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: Responsive.hp(context, 1.2)),
                    Text(
                      'Your progress will be lost if you exit now.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 14),
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: Responsive.hp(context, 3)),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: Responsive.hp(context, 1.7),
                              ),
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xFF1E293B),
                                fontWeight: FontWeight.w700,
                                fontSize: Responsive.sp(context, 15),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.wp(context, 3)),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                vertical: Responsive.hp(context, 1.7),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Exit',
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
                  ],
                ),
              ),
            );
          },
        ),
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.wp(context, 4.5),
            vertical: Responsive.hp(context, 1.1),
          ),
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
          child: Text(
            '${currentQuestionIndex + 1}/${widget.questions.length}',
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.sp(context, 14),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
              Responsive.wp(context, 6),
              0,
              Responsive.wp(context, 6),
              Responsive.hp(context, 2.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 6,
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: progress * _progressController.value,
                      backgroundColor: const Color(0xFFE9ECEF),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        gradientColors[0],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Responsive.wp(context, 6)),
              child: Column(
                children: [
                  SizedBox(height: Responsive.hp(context, 2)),
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: timeLeft <= 5
                            ? 1.0 + (_pulseController.value * 0.04)
                            : 1.0,
                        child: Container(
                          width: Responsive.wp(context, 27.5),
                          height: Responsive.wp(context, 27.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: timeLeft <= 5
                                  ? const Color(0xFFEF4444)
                                  : gradientColors[0],
                              width: 5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (timeLeft <= 5
                                            ? const Color(0xFFEF4444)
                                            : gradientColors[0])
                                        .withOpacity(0.25),
                                blurRadius: 25,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$timeLeft',
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 40),
                                  fontWeight: FontWeight.w800,
                                  color: timeLeft <= 5
                                      ? const Color(0xFFEF4444)
                                      : gradientColors[0],
                                  height: 1,
                                ),
                              ),
                              SizedBox(height: Responsive.hp(context, 0.5)),
                              Text(
                                'seconds',
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 11),
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Responsive.hp(context, 4)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Responsive.wp(context, 7)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          gradientColors[0].withOpacity(0.08),
                          gradientColors[1].withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: gradientColors[0].withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors[0].withOpacity(0.1),
                          blurRadius: 25,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.wp(context, 3.5),
                            vertical: Responsive.hp(context, 0.7),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'QUESTION',
                            style: TextStyle(
                              fontSize: Responsive.sp(context, 11),
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: Responsive.hp(context, 2.2)),
                        Text(
                          question.question,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 22),
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                            height: 1.4,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Responsive.hp(context, 4)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose Answer',
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 14),
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.hp(context, 2)),
                  ...List.generate(question.options.length, (index) {
                    final isSelected = selectedAnswer == index;
                    final isCorrect = index == question.correctAnswerIndex;
                    Color? backgroundColor;
                    Color? borderColor;
                    Color textColor = const Color(0xFF1E293B);
                    Color badgeColor = const Color(0xFFF8F9FA);
                    Color badgeTextColor = const Color(0xFF64748B);

                    if (answered) {
                      if (isCorrect) {
                        backgroundColor = const Color(0xFFF0FDF4);
                        borderColor = const Color(0xFF22C55E);
                        textColor = const Color(0xFF166534);
                        badgeColor = const Color(0xFF22C55E);
                        badgeTextColor = Colors.white;
                      } else if (isSelected) {
                        backgroundColor = const Color(0xFFFEF2F2);
                        borderColor = const Color(0xFFEF4444);
                        textColor = const Color(0xFF991B1B);
                        badgeColor = const Color(0xFFEF4444);
                        badgeTextColor = Colors.white;
                      }
                    } else if (isSelected) {
                      backgroundColor = gradientColors[0].withOpacity(0.08);
                      borderColor = gradientColors[0];
                      badgeColor = gradientColors[0];
                      badgeTextColor = Colors.white;
                    }

                    return GestureDetector(
                      onTap: () => selectAnswer(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        margin: EdgeInsets.only(
                          bottom: Responsive.hp(context, 1.7),
                        ),
                        padding: EdgeInsets.all(Responsive.wp(context, 4.5)),
                        decoration: BoxDecoration(
                          color: backgroundColor ?? Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: borderColor ?? const Color(0xFFE9ECEF),
                            width: 2,
                          ),
                          boxShadow: answered && (isCorrect || isSelected)
                              ? [
                                  BoxShadow(
                                    color:
                                        (isCorrect
                                                ? const Color(0xFF22C55E)
                                                : const Color(0xFFEF4444))
                                            .withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: Responsive.wp(context, 10.5),
                              height: Responsive.wp(context, 10.5),
                              decoration: BoxDecoration(
                                color: badgeColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: answered && (isCorrect || isSelected)
                                    ? Icon(
                                        isCorrect
                                            ? Icons.check_rounded
                                            : Icons.close_rounded,
                                        color: badgeTextColor,
                                        size: Responsive.wp(context, 6),
                                      )
                                    : Text(
                                        String.fromCharCode(65 + index),
                                        style: TextStyle(
                                          fontSize: Responsive.sp(context, 18),
                                          fontWeight: FontWeight.w800,
                                          color: badgeTextColor,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(width: Responsive.wp(context, 4)),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 15),
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}