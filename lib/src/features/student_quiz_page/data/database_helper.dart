import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz_master.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    // User Progress Table - tracks answered questions
    await db.execute('''
      CREATE TABLE user_progress (
        id $idType,
        category $textType,
        question_id $textType,
        question_index $intType,
        is_correct $boolType,
        answered_date $textType,
        time_taken $intType,
        score_earned $intType
      )
    ''');

    // Daily Tracking Table - tracks daily attempts per category
    await db.execute('''
      CREATE TABLE daily_tracking (
        id $idType,
        category $textType,
        quiz_date $textType,
        questions_answered $intType,
        last_reset_time $textType,
        UNIQUE(category, quiz_date)
      )
    ''');

    // Question Queue Table - tracks last question index per category
    await db.execute('''
      CREATE TABLE question_queue (
        id $idType,
        category $textType UNIQUE,
        last_question_index $intType,
        total_questions_answered $intType
      )
    ''');

    // User Stats Table - overall statistics
    await db.execute('''
      CREATE TABLE user_stats (
        id $idType,
        total_score $intType,
        total_correct $intType,
        total_wrong $intType,
        current_streak $intType,
        longest_streak $intType,
        last_attempt_date $textType
      )
    ''');

    // Insert initial user stats
    await db.insert('user_stats', {
      'total_score': 0,
      'total_correct': 0,
      'total_wrong': 0,
      'current_streak': 0,
      'longest_streak': 0,
      'last_attempt_date': DateTime.now().toIso8601String(),
    });

    // Insert initial question queue for each category
    for (String category in ['Java', 'Dart', 'Python']) {
      await db.insert('question_queue', {
        'category': category,
        'last_question_index': 0,
        'total_questions_answered': 0,
      });
    }
  }

  // ==================== USER PROGRESS ====================

  Future<int> saveQuestionProgress({
    required String category,
    required String questionId,
    required int questionIndex,
    required bool isCorrect,
    required int timeTaken,
    required int scoreEarned,
  }) async {
    final db = await database;
    return await db.insert('user_progress', {
      'category': category,
      'question_id': questionId,
      'question_index': questionIndex,
      'is_correct': isCorrect ? 1 : 0,
      'answered_date': DateTime.now().toIso8601String(),
      'time_taken': timeTaken,
      'score_earned': scoreEarned,
    });
  }

  Future<List<Map<String, dynamic>>> getAnsweredQuestions(String category) async {
    final db = await database;
    return await db.query(
      'user_progress',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  // ==================== DAILY TRACKING ====================

  Future<Map<String, dynamic>?> getDailyTracking(String category, String date) async {
    final db = await database;
    final results = await db.query(
      'daily_tracking',
      where: 'category = ? AND quiz_date = ?',
      whereArgs: [category, date],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateDailyTracking({
    required String category,
    required String date,
    required int questionsAnswered,
  }) async {
    final db = await database;
    final existing = await getDailyTracking(category, date);

    if (existing == null) {
      return await db.insert('daily_tracking', {
        'category': category,
        'quiz_date': date,
        'questions_answered': questionsAnswered,
        'last_reset_time': DateTime.now().toIso8601String(),
      });
    } else {
      return await db.update(
        'daily_tracking',
        {
          'questions_answered': questionsAnswered,
          'last_reset_time': DateTime.now().toIso8601String(),
        },
        where: 'category = ? AND quiz_date = ?',
        whereArgs: [category, date],
      );
    }
  }

  Future<int> getQuestionsAnsweredToday(String category) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final tracking = await getDailyTracking(category, today);
    return tracking?['questions_answered'] ?? 0;
  }

  // ==================== QUESTION QUEUE ====================

  Future<Map<String, dynamic>?> getQuestionQueue(String category) async {
    final db = await database;
    final results = await db.query(
      'question_queue',
      where: 'category = ?',
      whereArgs: [category],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateQuestionQueue({
    required String category,
    required int lastQuestionIndex,
    required int totalQuestionsAnswered,
  }) async {
    final db = await database;
    return await db.update(
      'question_queue',
      {
        'last_question_index': lastQuestionIndex,
        'total_questions_answered': totalQuestionsAnswered,
      },
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  // ==================== USER STATS ====================

  Future<Map<String, dynamic>> getUserStats() async {
    final db = await database;
    final results = await db.query('user_stats', limit: 1);
    return results.first;
  }

  Future<int> updateUserStats({
    required int totalScore,
    required int totalCorrect,
    required int totalWrong,
    required int currentStreak,
    required int longestStreak,
  }) async {
    final db = await database;
    return await db.update(
      'user_stats',
      {
        'total_score': totalScore,
        'total_correct': totalCorrect,
        'total_wrong': totalWrong,
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'last_attempt_date': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  // ==================== UTILITY ====================

  Future<void> resetDailyProgress() async {
    final db = await database;
    await db.delete('daily_tracking');
  }

  Future<void> resetAllProgress() async {
    final db = await database;
    await db.delete('user_progress');
    await db.delete('daily_tracking');
    await db.update(
      'question_queue',
      {'last_question_index': 0, 'total_questions_answered': 0},
    );
    await db.update(
      'user_stats',
      {
        'total_score': 0,
        'total_correct': 0,
        'total_wrong': 0,
        'current_streak': 0,
        'longest_streak': 0,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}