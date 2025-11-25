import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class GoogleSheetsService {
  static const String apiKey = 'AIzaSyCgQfRayTamzPfQ7t_h1ng2aKDhX8x6RzQ';
  static const String spreadsheetId = '12V4gy42pL-NXMTHwwEnFZNMyiGLxIIoR8ONH3m7Guho';

  // Sheet names
  static const Map<String, String> sheetNames = {
    'Java': 'Java_Quiz_Questions',
    'Dart': 'Dart_Quiz_Questions',
    'Python': 'Python_Quiz_Questions',
  };

  // Fetch questions from Google Sheets
  static Future<List<QuestionModel>> fetchQuestions({
    required String category,
    int limit = 10,
    bool random = true,
  }) async {
    try {
      final sheetName = sheetNames[category];
      if (sheetName == null) {
        throw Exception('Invalid category: $category');
      }

      // Fetch all questions from the sheet
      final url = Uri.parse(
        'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName!A2:G?key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> rows = data['values'] ?? [];

        if (rows.isEmpty) {
          throw Exception('No questions found in $category');
        }

        // Convert rows to QuestionModel list
        List<QuestionModel> allQuestions = [];
        for (int i = 0; i < rows.length; i++) {
          final row = rows[i];
          if (row.length >= 7) {
            allQuestions.add(QuestionModel(
              questionId: row[0].toString(),
              question: row[1].toString(),
              optionA: row[2].toString(),
              optionB: row[3].toString(),
              optionC: row[4].toString(),
              optionD: row[5].toString(),
              correctAnswer: row[6].toString(),
              category: category,
              index: i + 1,
            ));
          }
        }

        // Return random or sequential questions
        if (random) {
          allQuestions.shuffle(Random());
          return allQuestions.take(limit).toList();
        } else {
          return allQuestions.take(limit).toList();
        }
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  // Fetch random 10 questions for daily quiz
  static Future<List<QuestionModel>> fetchDailyQuestions(String category) async {
    return await fetchQuestions(
      category: category,
      limit: 10,
      random: true,
    );
  }

  // Fetch total count of questions in a sheet
  static Future<int> getTotalQuestionsCount(String category) async {
    try {
      final sheetName = sheetNames[category];
      if (sheetName == null) return 0;

      final url = Uri.parse(
        'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName!A2:A?key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> rows = data['values'] ?? [];
        return rows.length;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}

// Question Model
class QuestionModel {
  final String questionId;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;
  final String category;
  final int index;

  QuestionModel({
    required this.questionId,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.category,
    required this.index,
  });

  List<String> get options => [optionA, optionB, optionC, optionD];

  int get correctAnswerIndex {
    // Correct answer is stored as 'A', 'B', 'C', or 'D'
    final answerMap = {'A': 0, 'B': 1, 'C': 2, 'D': 3};
    return answerMap[correctAnswer.toUpperCase()] ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'question': question,
        'optionA': optionA,
        'optionB': optionB,
        'optionC': optionC,
        'optionD': optionD,
        'correctAnswer': correctAnswer,
        'category': category,
        'index': index,
      };

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        questionId: json['questionId'],
        question: json['question'],
        optionA: json['optionA'],
        optionB: json['optionB'],
        optionC: json['optionC'],
        optionD: json['optionD'],
        correctAnswer: json['correctAnswer'],
        category: json['category'],
        index: json['index'],
      );
}