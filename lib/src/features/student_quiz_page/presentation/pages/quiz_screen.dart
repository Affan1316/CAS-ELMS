// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter_cas_app_main/src/features/student_quiz_page/domain/services/google_sheets_service.dart';
// import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/pages/result_screen.dart';
// import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';

// class QuizScreenUpdated extends StatefulWidget {
//   final Map<String, dynamic> category;
//   final List<QuestionModel> questions;
//   final VoidCallback onComplete;

//   const QuizScreenUpdated({
//     super.key,
//     required this.category,
//     required this.questions,
//     required this.onComplete,
//   });

//   @override
//   State<QuizScreenUpdated> createState() => _QuizScreenUpdatedState();
// }

// class _QuizScreenUpdatedState extends State<QuizScreenUpdated>
//     with TickerProviderStateMixin {
//   int currentQuestionIndex = 0;
//   int? selectedAnswer;
//   int score = 0;
//   bool answered = false;
//   Timer? timer;
//   int timeLeft = 0;
//   late AnimationController _progressController;
//   late AnimationController _pulseController;

//   // Track answers and time for database
//   List<bool> answersCorrect = [];
//   List<int> timeTaken = [];
//   int questionStartTime = 0;

//   @override
//   void initState() {
//     super.initState();
//     _progressController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..repeat(reverse: true);
//     startTimer();
//     _progressController.forward();
//     questionStartTime = DateTime.now().millisecondsSinceEpoch;
//   }

//   void startTimer() {
//     timeLeft = 20; // 20 seconds as per your requirement
//     timer?.cancel();
//     timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (mounted) {
//         setState(() {
//           if (timeLeft > 0) {
//             timeLeft--;
//           } else {
//             // Time's up - mark as wrong
//             selectAnswer(-1); // -1 means no answer (timeout)
//           }
//         });
//       }
//     });
//   }

//   void selectAnswer(int index) {
//     if (answered) return;

//     final question = widget.questions[currentQuestionIndex];
//     final isCorrect = index == question.correctAnswerIndex;
//     final elapsedTime =
//         (DateTime.now().millisecondsSinceEpoch - questionStartTime) ~/ 1000;

//     setState(() {
//       selectedAnswer = index;
//       answered = true;
//       if (isCorrect) {
//         score++;
//       }
//     });

//     // Save answer data
//     answersCorrect.add(isCorrect);
//     timeTaken.add(elapsedTime);

//     timer?.cancel();
//     Future.delayed(const Duration(milliseconds: 1400), () {
//       if (mounted) nextQuestion();
//     });
//   }

//   void nextQuestion() {
//     if (currentQuestionIndex < widget.questions.length - 1) {
//       setState(() {
//         currentQuestionIndex++;
//         selectedAnswer = null;
//         answered = false;
//         questionStartTime = DateTime.now().millisecondsSinceEpoch;
//       });
//       _progressController.reset();
//       _progressController.forward();
//       startTimer();
//     } else {
//       timer?.cancel();
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder:
//                 (c, a, sa) => ResultScreenUpdated(
//                   score: score,
//                   totalQuestions: widget.questions.length,
//                   category: widget.category,
//                   questions: widget.questions,
//                   answersCorrect: answersCorrect,
//                   timeTaken: timeTaken,
//                   onComplete: widget.onComplete,
//                 ),
//             transitionsBuilder:
//                 (c, a, sa, child) => FadeTransition(opacity: a, child: child),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     _progressController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final question = widget.questions[currentQuestionIndex];
//     final progress = (currentQuestionIndex + 1) / widget.questions.length;
//     final gradientColors = widget.category['gradientColors'] as List<Color>;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFAFA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             padding: EdgeInsets.all(Responsive.wp(context, 2)),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF8F9FA),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               Icons.close_rounded,
//               color: gradientColors[0],
//               size: Responsive.wp(context, 5),
//             ),
//           ),
//           onPressed: () {
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder:
//                   (context) => AlertDialog(
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                     contentPadding: EdgeInsets.all(Responsive.wp(context, 6)),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(Responsive.wp(context, 4)),
//                           decoration: BoxDecoration(
//                             color: Colors.red.withOpacity(0.1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.warning_rounded,
//                             color: Colors.red,
//                             size: Responsive.wp(context, 10),
//                           ),
//                         ),
//                         SizedBox(height: Responsive.hp(context, 2.5)),
//                         Text(
//                           'Exit Quiz?',
//                           style: TextStyle(
//                             fontSize: Responsive.sp(context, 22),
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF1E293B),
//                           ),
//                         ),
//                         SizedBox(height: Responsive.hp(context, 1.2)),
//                         Text(
//                           'Your progress will be lost if you exit now.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: Responsive.sp(context, 14),
//                             color: Colors.grey[600],
//                             height: 1.4,
//                           ),
//                         ),
//                         SizedBox(height: Responsive.hp(context, 3)),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: OutlinedButton(
//                                 style: OutlinedButton.styleFrom(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: Responsive.hp(context, 1.7),
//                                   ),
//                                   side: BorderSide(
//                                     color: Colors.grey[300]!,
//                                     width: 1.5,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text(
//                                   'Cancel',
//                                   style: TextStyle(
//                                     color: Color(0xFF1E293B),
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: Responsive.sp(context, 15),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: Responsive.wp(context, 3)),
//                             Expanded(
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: Responsive.hp(context, 1.7),
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 0,
//                                 ),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text(
//                                   'Exit',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: Responsive.sp(context, 15),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//             );
//           },
//         ),
//         title: Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: Responsive.wp(context, 4.5),
//             vertical: Responsive.hp(context, 1.1),
//           ),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: gradientColors),
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: [
//               BoxShadow(
//                 color: gradientColors[0].withOpacity(0.25),
//                 blurRadius: 10,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Text(
//             '${currentQuestionIndex + 1}/${widget.questions.length}',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: Responsive.sp(context, 14),
//               fontWeight: FontWeight.w800,
//               letterSpacing: 0.3,
//             ),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.white,
//             padding: EdgeInsets.fromLTRB(
//               Responsive.wp(context, 6),
//               0,
//               Responsive.wp(context, 6),
//               Responsive.hp(context, 2.5),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: SizedBox(
//                 height: 6,
//                 child: AnimatedBuilder(
//                   animation: _progressController,
//                   builder: (context, child) {
//                     return LinearProgressIndicator(
//                       value: progress * _progressController.value,
//                       backgroundColor: const Color(0xFFE9ECEF),
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         gradientColors[0],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: EdgeInsets.all(Responsive.wp(context, 6)),
//               child: Column(
//                 children: [
//                   SizedBox(height: Responsive.hp(context, 2)),
//                   AnimatedBuilder(
//                     animation: _pulseController,
//                     builder: (context, child) {
//                       return Transform.scale(
//                         scale:
//                             timeLeft <= 5
//                                 ? 1.0 + (_pulseController.value * 0.04)
//                                 : 1.0,
//                         child: Container(
//                           width: Responsive.wp(context, 27.5),
//                           height: Responsive.wp(context, 27.5),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color:
//                                   timeLeft <= 5
//                                       ? const Color(0xFFEF4444)
//                                       : gradientColors[0],
//                               width: 5,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: (timeLeft <= 5
//                                         ? const Color(0xFFEF4444)
//                                         : gradientColors[0])
//                                     .withOpacity(0.25),
//                                 blurRadius: 25,
//                                 spreadRadius: 2,
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 '$timeLeft',
//                                 style: TextStyle(
//                                   fontSize: Responsive.sp(context, 40),
//                                   fontWeight: FontWeight.w800,
//                                   color:
//                                       timeLeft <= 5
//                                           ? const Color(0xFFEF4444)
//                                           : gradientColors[0],
//                                   height: 1,
//                                 ),
//                               ),
//                               SizedBox(height: Responsive.hp(context, 0.5)),
//                               Text(
//                                 'seconds',
//                                 style: TextStyle(
//                                   fontSize: Responsive.sp(context, 11),
//                                   color: Colors.grey[600],
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: Responsive.hp(context, 4)),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.all(Responsive.wp(context, 7)),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           gradientColors[0].withOpacity(0.08),
//                           gradientColors[1].withOpacity(0.05),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(24),
//                       border: Border.all(
//                         color: gradientColors[0].withOpacity(0.2),
//                         width: 2,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: gradientColors[0].withOpacity(0.1),
//                           blurRadius: 25,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: Responsive.wp(context, 3.5),
//                             vertical: Responsive.hp(context, 0.7),
//                           ),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(colors: gradientColors),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             'QUESTION',
//                             style: TextStyle(
//                               fontSize: Responsive.sp(context, 11),
//                               fontWeight: FontWeight.w800,
//                               color: Colors.white,
//                               letterSpacing: 1.2,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: Responsive.hp(context, 2.2)),
//                         Text(
//                           question.question,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: Responsive.sp(context, 22),
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF1E293B),
//                             height: 1.4,
//                             letterSpacing: -0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: Responsive.hp(context, 4)),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Choose Answer',
//                       style: TextStyle(
//                         fontSize: Responsive.sp(context, 14),
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF64748B),
//                         letterSpacing: 0.3,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: Responsive.hp(context, 2)),
//                   ...List.generate(question.options.length, (index) {
//                     final isSelected = selectedAnswer == index;
//                     final isCorrect = index == question.correctAnswerIndex;
//                     Color? backgroundColor;
//                     Color? borderColor;
//                     Color textColor = const Color(0xFF1E293B);
//                     Color badgeColor = const Color(0xFFF8F9FA);
//                     Color badgeTextColor = const Color(0xFF64748B);

//                     if (answered) {
//                       if (isCorrect) {
//                         backgroundColor = const Color(0xFFF0FDF4);
//                         borderColor = const Color(0xFF22C55E);
//                         textColor = const Color(0xFF166534);
//                         badgeColor = const Color(0xFF22C55E);
//                         badgeTextColor = Colors.white;
//                       } else if (isSelected) {
//                         backgroundColor = const Color(0xFFFEF2F2);
//                         borderColor = const Color(0xFFEF4444);
//                         textColor = const Color(0xFF991B1B);
//                         badgeColor = const Color(0xFFEF4444);
//                         badgeTextColor = Colors.white;
//                       }
//                     } else if (isSelected) {
//                       backgroundColor = gradientColors[0].withOpacity(0.08);
//                       borderColor = gradientColors[0];
//                       badgeColor = gradientColors[0];
//                       badgeTextColor = Colors.white;
//                     }

//                     return GestureDetector(
//                       onTap: () => selectAnswer(index),
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 250),
//                         curve: Curves.easeOut,
//                         margin: EdgeInsets.only(
//                           bottom: Responsive.hp(context, 1.7),
//                         ),
//                         padding: EdgeInsets.all(Responsive.wp(context, 4.5)),
//                         decoration: BoxDecoration(
//                           color: backgroundColor ?? Colors.white,
//                           borderRadius: BorderRadius.circular(18),
//                           border: Border.all(
//                             color: borderColor ?? const Color(0xFFE9ECEF),
//                             width: 2,
//                           ),
//                           boxShadow:
//                               answered && (isCorrect || isSelected)
//                                   ? [
//                                     BoxShadow(
//                                       color: (isCorrect
//                                               ? const Color(0xFF22C55E)
//                                               : const Color(0xFFEF4444))
//                                           .withOpacity(0.2),
//                                       blurRadius: 20,
//                                       spreadRadius: 1,
//                                     ),
//                                   ]
//                                   : [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.02),
//                                       blurRadius: 10,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                         ),
//                         child: Row(
//                           children: [
//                             AnimatedContainer(
//                               duration: const Duration(milliseconds: 250),
//                               width: Responsive.wp(context, 10.5),
//                               height: Responsive.wp(context, 10.5),
//                               decoration: BoxDecoration(
//                                 color: badgeColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child:
//                                     answered && (isCorrect || isSelected)
//                                         ? Icon(
//                                           isCorrect
//                                               ? Icons.check_rounded
//                                               : Icons.close_rounded,
//                                           color: badgeTextColor,
//                                           size: Responsive.wp(context, 6),
//                                         )
//                                         : Text(
//                                           String.fromCharCode(65 + index),
//                                           style: TextStyle(
//                                             fontSize: Responsive.sp(
//                                               context,
//                                               18,
//                                             ),
//                                             fontWeight: FontWeight.w800,
//                                             color: badgeTextColor,
//                                           ),
//                                         ),
//                               ),
//                             ),
//                             SizedBox(width: Responsive.wp(context, 4)),
//                             Expanded(
//                               child: Text(
//                                 question.options[index],
//                                 style: TextStyle(
//                                   fontSize: Responsive.sp(context, 15),
//                                   color: textColor,
//                                   fontWeight: FontWeight.w600,
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_cas_app_main/src/features/student_quiz_page/domain/services/google_sheets_service.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/pages/result_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';

// ── Tokens ────────────────────────────────────────────────────────────────────

class _T {
  static const pageBg = Color(0xFFF5F5F5);
  static const cardBg = Color(0xFFFFFFFF);
  static const surfaceBg = Color(0xFFEAEAEA);
  static const heroBg = Color(0xFF111111);
  static const inkDeep = Color(0xFF111111);
  static const inkMid = Color(0xFF555555);
  static const inkSoft = Color(0xFFAAAAAA);
  static const divider = Color(0xFFEBEBEB);

  static const correctBg = Color(0xFFF0FDF4);
  static const correctBorder = Color(0xFF22C55E);
  static const correctFg = Color(0xFF166534);
  static const wrongBg = Color(0xFFFEF2F2);
  static const wrongBorder = Color(0xFFEF4444);
  static const wrongFg = Color(0xFF991B1B);
  static const dangerTimer = Color(0xFFEF4444);
}

// ── Page ──────────────────────────────────────────────────────────────────────

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
  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  int score = 0;
  bool answered = false;
  Timer? timer;
  int timeLeft = 0;
  late AnimationController _progressController;
  late AnimationController _pulseController;

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
    timeLeft = 20;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
          } else {
            selectAnswer(-1);
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
      if (isCorrect) score++;
    });
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
            pageBuilder:
                (c, a, sa) => ResultScreenUpdated(
                  score: score,
                  totalQuestions: widget.questions.length,
                  category: widget.category,
                  questions: widget.questions,
                  answersCorrect: answersCorrect,
                  timeTaken: timeTaken,
                  onComplete: widget.onComplete,
                ),
            transitionsBuilder:
                (c, a, sa, child) => FadeTransition(opacity: a, child: child),
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
  // ── END LOGIC ─────────────────────────────────────────────────────────────

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => _ExitDialog(
            onCancel: () => Navigator.pop(ctx),
            onExit: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final question = widget.questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / widget.questions.length;
    final gradientColors = widget.category['gradientColors'] as List<Color>;
    final accentColor = gradientColors[0];
    final isDanger = timeLeft <= 5;

    return Scaffold(
      backgroundColor: _T.pageBg,
      body: Column(
        children: [
          // ── Top bar ──────────────────────────────────────────────────
          _TopBar(
            currentIndex: currentQuestionIndex,
            total: widget.questions.length,
            progress: progress,
            progressController: _progressController,
            accentColor: accentColor,
            onClose: _showExitDialog,
          ),

          // ── Scrollable content ───────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Timer ring
                  _TimerRing(
                    pulseController: _pulseController,
                    timeLeft: timeLeft,
                    isDanger: isDanger,
                    accentColor: accentColor,
                  ),

                  const SizedBox(height: 20),

                  // Question bubble
                  _QuestionBubble(
                    question: question.question,
                    accentColor: accentColor,
                  ),

                  const SizedBox(height: 20),

                  // Options
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            'CHOOSE ANSWER',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: _T.inkSoft,
                            ),
                          ),
                        ),
                        ...List.generate(
                          question.options.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _OptionTile(
                              index: index,
                              text: question.options[index],
                              isCorrect: index == question.correctAnswerIndex,
                              selectedAnswer: selectedAnswer,
                              answered: answered,
                              accentColor: accentColor,
                              onTap: () => selectAnswer(index),
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
        ],
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int currentIndex;
  final int total;
  final double progress;
  final AnimationController progressController;
  final Color accentColor;
  final VoidCallback onClose;

  const _TopBar({
    required this.currentIndex,
    required this.total,
    required this.progress,
    required this.progressController,
    required this.accentColor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: _T.cardBg,
      padding: EdgeInsets.fromLTRB(16, topPad + 10, 16, 14),
      child: Row(
        children: [
          // Close button
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: _T.surfaceBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.close_rounded, size: 16, color: _T.inkMid),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 4,
                child: AnimatedBuilder(
                  animation: progressController,
                  builder:
                      (_, __) => LinearProgressIndicator(
                        value: progress * progressController.value,
                        backgroundColor: _T.surfaceBg,
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Counter pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${currentIndex + 1}/$total',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Timer ring ────────────────────────────────────────────────────────────────

class _TimerRing extends StatelessWidget {
  final AnimationController pulseController;
  final int timeLeft;
  final bool isDanger;
  final Color accentColor;

  const _TimerRing({
    required this.pulseController,
    required this.timeLeft,
    required this.isDanger,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final ringColor = isDanger ? _T.dangerTimer : accentColor;

    return AnimatedBuilder(
      animation: pulseController,
      builder:
          (_, __) => Transform.scale(
            scale: isDanger ? 1.0 + (pulseController.value * 0.04) : 1.0,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: _T.cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$timeLeft',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: ringColor,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'sec',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ringColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

// ── Question bubble ───────────────────────────────────────────────────────────

class _QuestionBubble extends StatelessWidget {
  final String question;
  final Color accentColor;
  const _QuestionBubble({required this.question, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _T.divider),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'QUESTION',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _T.inkDeep,
              height: 1.45,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Option tile ───────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool isCorrect;
  final int? selectedAnswer;
  final bool answered;
  final Color accentColor;
  final VoidCallback onTap;

  const _OptionTile({
    required this.index,
    required this.text,
    required this.isCorrect,
    required this.selectedAnswer,
    required this.answered,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedAnswer == index;

    Color bgColor = _T.cardBg;
    Color borderColor = _T.divider;
    Color textColor = _T.inkDeep;
    Color badgeBg = _T.surfaceBg;
    Color badgeFg = _T.inkMid;
    Widget badgeChild = Text(
      String.fromCharCode(65 + index),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: badgeFg,
      ),
    );

    if (answered) {
      if (isCorrect) {
        bgColor = _T.correctBg;
        borderColor = _T.correctBorder;
        textColor = _T.correctFg;
        badgeBg = _T.correctBorder;
        badgeChild = const Icon(
          Icons.check_rounded,
          size: 15,
          color: Colors.white,
        );
      } else if (isSelected) {
        bgColor = _T.wrongBg;
        borderColor = _T.wrongBorder;
        textColor = _T.wrongFg;
        badgeBg = _T.wrongBorder;
        badgeChild = const Icon(
          Icons.close_rounded,
          size: 15,
          color: Colors.white,
        );
      }
    } else if (isSelected) {
      bgColor = accentColor.withOpacity(0.08);
      borderColor = accentColor;
      badgeBg = accentColor;
      badgeChild = Text(
        String.fromCharCode(65 + index),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
              child: Center(child: badgeChild),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Exit dialog ───────────────────────────────────────────────────────────────

class _ExitDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onExit;
  const _ExitDialog({required this.onCancel, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _T.cardBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.warning_rounded,
                  color: _T.wrongBorder,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Exit quiz?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _T.inkDeep,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your progress will be lost if you exit now.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: _T.inkSoft, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: _T.surfaceBg,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _T.inkDeep,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: onExit,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: _T.wrongBorder,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Center(
                        child: Text(
                          'Exit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
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
  }
}
