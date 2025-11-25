class UserStats {
  final int totalScore;
  final int totalCorrect;
  final int totalWrong;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastAttemptDate;

  const UserStats({
    required this.totalScore,
    required this.totalCorrect,
    required this.totalWrong,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastAttemptDate,
  });

  // Empty stats for initial state
  factory UserStats.empty() {
    return UserStats(
      totalScore: 0,
      totalCorrect: 0,
      totalWrong: 0,
      currentStreak: 0,
      longestStreak: 0,
      lastAttemptDate: DateTime.now(),
    );
  }

  // Calculate accuracy percentage
  double get accuracy {
    final total = totalCorrect + totalWrong;
    if (total == 0) return 0;
    return (totalCorrect / total) * 100;
  }

  // Total questions attempted
  int get totalQuestions => totalCorrect + totalWrong;
}