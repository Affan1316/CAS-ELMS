class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String category;
  final int? index;

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
    this.index,
  });

  // Helper method to check if answer is correct
  bool isCorrectAnswer(int selectedIndex) {
    return selectedIndex == correctAnswerIndex;
  }
}