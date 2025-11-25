import 'package:flutter_cas_app_main/src/features/student_quiz_page/domain/entities/question.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/domain/entities/quiz_category.dart';

class Quiz {
  final QuizCategory category;
  final List<Question> questions;
  final DateTime startTime;
  final int totalTimeSeconds;

  const Quiz({
    required this.category,
    required this.questions,
    required this.startTime,
    this.totalTimeSeconds = 20, // 20 seconds per question
  });

  // Calculate total available points
  int get totalPoints => questions.length * 10;

  // Get total quiz duration
  int get totalDuration => questions.length * totalTimeSeconds;

  // Check if quiz is empty
  bool get isEmpty => questions.isEmpty;

  // Get question count
  int get questionCount => questions.length;
}