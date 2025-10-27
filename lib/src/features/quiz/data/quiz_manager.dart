import 'package:flutter_cas_app_main/src/features/quiz/domain/services/google_sheets_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';


class QuizManager {
  static final QuizManager instance = QuizManager._init();
  final DatabaseHelper _db = DatabaseHelper.instance;

  QuizManager._init();

  // ==================== DAILY LIMIT CHECK ====================

  Future<bool> canAttemptQuiz(String category) async {
    final today = _getTodayDate();
    final questionsAnswered = await _db.getQuestionsAnsweredToday(category);
    return questionsAnswered < 10;
  }

  Future<int> getRemainingQuestions(String category) async {
    final questionsAnswered = await _db.getQuestionsAnsweredToday(category);
    return 10 - questionsAnswered;
  }

  Future<Map<String, int>> getAllCategoryProgress() async {
    Map<String, int> progress = {};
    for (String category in ['Java', 'Dart', 'Python']) {
      progress[category] = await _db.getQuestionsAnsweredToday(category);
    }
    return progress;
  }

  // ==================== FETCH DAILY QUESTIONS ====================

  Future<List<QuestionModel>> getDailyQuestions(String category) async {
    // Check if user can attempt
    if (!await canAttemptQuiz(category)) {
      throw Exception('Daily limit reached for $category');
    }

    // Fetch random 10 questions
    final questions = await GoogleSheetsService.fetchDailyQuestions(category);
    
    // Get remaining questions allowed
    final remaining = await getRemainingQuestions(category);
    
    // Return only the allowed number
    return questions.take(remaining).toList();
  }

  // ==================== SAVE QUIZ RESULT ====================

  Future<void> saveQuizResult({
    required String category,
    required List<QuestionModel> questions,
    required List<bool> answers,
    required List<int> timeTaken,
  }) async {
    final today = _getTodayDate();
    int totalScore = 0;
    int correctAnswers = 0;
    int wrongAnswers = 0;

    // Save each question progress
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final isCorrect = answers[i];
      final score = isCorrect ? 10 : 0;

      await _db.saveQuestionProgress(
        category: category,
        questionId: question.questionId,
        questionIndex: question.index,
        isCorrect: isCorrect,
        timeTaken: timeTaken[i],
        scoreEarned: score,
      );

      totalScore += score;
      if (isCorrect) {
        correctAnswers++;
      } else {
        wrongAnswers++;
      }
    }

    // Update daily tracking
    final currentAnswered = await _db.getQuestionsAnsweredToday(category);
    await _db.updateDailyTracking(
      category: category,
      date: today,
      questionsAnswered: currentAnswered + questions.length,
    );

    // Update user stats
    await _updateUserStats(totalScore, correctAnswers, wrongAnswers);

    // Update question queue
    final queue = await _db.getQuestionQueue(category);
    final lastIndex = queue?['last_question_index'] ?? 0;
    final totalAnswered = queue?['total_questions_answered'] ?? 0;

    await _db.updateQuestionQueue(
      category: category,
      lastQuestionIndex: lastIndex + questions.length,
      totalQuestionsAnswered: totalAnswered + questions.length,
    );
  }

  Future<void> _updateUserStats(int score, int correct, int wrong) async {
    final stats = await _db.getUserStats();
    final totalScore = (stats['total_score'] ?? 0) + score;
    final totalCorrect = (stats['total_correct'] ?? 0) + correct;
    final totalWrong = (stats['total_wrong'] ?? 0) + wrong;

    // Update streak
    final lastAttempt = DateTime.parse(stats['last_attempt_date']);
    final today = DateTime.now();
    final daysDiff = today.difference(lastAttempt).inDays;

    int currentStreak = stats['current_streak'] ?? 0;
    int longestStreak = stats['longest_streak'] ?? 0;

    if (daysDiff == 0) {
      // Same day, keep streak
    } else if (daysDiff == 1) {
      // Consecutive day, increment streak
      currentStreak++;
    } else {
      // Streak broken
      currentStreak = 1;
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    await _db.updateUserStats(
      totalScore: totalScore,
      totalCorrect: totalCorrect,
      totalWrong: totalWrong,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
    );
  }

  // ==================== STATS & PROGRESS ====================

  Future<Map<String, dynamic>> getUserStats() async {
    return await _db.getUserStats();
  }

  Future<Map<String, dynamic>> getCategoryStats(String category) async {
    final answered = await _db.getAnsweredQuestions(category);
    int totalScore = 0;
    int correct = 0;
    int wrong = 0;

    for (var q in answered) {
      totalScore += (q['score_earned'] ?? 0) as int;
      if ((q['is_correct'] ?? 0) == 1) {
        correct++;
      } else {
        wrong++;
      }
    }

    return {
      'totalQuestions': answered.length,
      'totalScore': totalScore,
      'correct': correct,
      'wrong': wrong,
      'accuracy': answered.isEmpty ? 0 : (correct / answered.length * 100).round(),
    };
  }

  // ==================== RESET ====================

  Future<void> resetDailyProgress() async {
    await _db.resetDailyProgress();
  }

  Future<void> resetAllProgress() async {
    await _db.resetAllProgress();
  }

  // ==================== UTILITY ====================

  String _getTodayDate() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  Future<String> getNextResetTime() async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final duration = tomorrow.difference(now);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '${hours}h ${minutes}m';
  }

  // Check if it's a new day and reset if needed
  Future<void> checkAndResetIfNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheckDate = prefs.getString('last_check_date') ?? '';
    final today = _getTodayDate();

    if (lastCheckDate != today) {
      // New day detected - reset is automatic because we check by date
      await prefs.setString('last_check_date', today);
    }
  }
}