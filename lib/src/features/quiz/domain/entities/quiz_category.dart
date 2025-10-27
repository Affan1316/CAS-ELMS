// Pure business entity (no dependencies)
class QuizCategory {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final List<String> gradientColorHex;

  const QuizCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.gradientColorHex,
  });

  // Empty category for error states
  factory QuizCategory.empty() {
    return const QuizCategory(
      id: '',
      title: '',
      description: '',
      iconName: 'code',
      gradientColorHex: ['#6366F1', '#8B5CF6'],
    );
  }
}