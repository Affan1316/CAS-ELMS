import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/data/quiz_manager.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/presentation/widgets/quiz_card.dart';
import 'package:flutter_cas_app_main/src/features/student_quiz_page/utils/resposive.dart';

class QuizHomeScreen extends StatefulWidget {
  const QuizHomeScreen({super.key});

  @override
  State<QuizHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<QuizHomeScreen> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  Map<String, dynamic>? userStats;
  Map<String, int> categoryProgress = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        duration: Duration(milliseconds: 300 + (i * 100)),
        vsync: this,
      )..forward(),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Check and reset if new day
      await QuizManager.instance.checkAndResetIfNewDay();

      // Load user stats
      final stats = await QuizManager.instance.getUserStats();
      
      // Load category progress
      final progress = await QuizManager.instance.getAllCategoryProgress();

      setState(() {
        userStats = stats;
        categoryProgress = progress;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                Responsive.wp(context, 6),
                Responsive.hp(context, 2.5),
                Responsive.wp(context, 6),
                Responsive.hp(context, 2),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(Responsive.wp(context, 2.5)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE9ECEF)),
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF6366F1),
                            size: Responsive.wp(context, 5.5),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Responsive.wp(context, 4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 15),
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              SizedBox(height: Responsive.hp(context, 0.7)),
                              Text(
                                'Let\'s Learn Today',
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 26),
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(Responsive.wp(context, 3.5)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE9ECEF)),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: Color(0xFF6366F1),
                          size: Responsive.wp(context, 6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.hp(context, 2.5)),
                  Container(
                    padding: EdgeInsets.all(Responsive.wp(context, 5)),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(Responsive.wp(context, 3)),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.stars_rounded,
                            color: Colors.white,
                            size: Responsive.wp(context, 7),
                          ),
                        ),
                        SizedBox(width: Responsive.wp(context, 4)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Total Score',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: Responsive.sp(context, 13),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(height: Responsive.hp(context, 0.5)),
                              isLoading
                                  ? Text(
                                      'Loading...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Responsive.sp(context, 22),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  : Text(
                                      '${userStats?['total_score'] ?? 0} Points',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Responsive.sp(context, 22),
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.wp(context, 3.5),
                            vertical: Responsive.hp(context, 1),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                color: Color(0xFFFFA500),
                                size: Responsive.wp(context, 4.5),
                              ),
                              SizedBox(width: Responsive.wp(context, 1.5)),
                              Text(
                                '${userStats?['current_streak'] ?? 0}',
                                style: TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.w800,
                                  fontSize: Responsive.sp(context, 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: ListView(
                  padding: EdgeInsets.all(Responsive.wp(context, 6)),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Text(
                      'Quiz Categories',
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 20),
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: Responsive.hp(context, 2.5)),
                    if (isLoading)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(Responsive.hp(context, 5)),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      ...List.generate(
                        quizCategories.length,
                        (i) => FadeTransition(
                          opacity: _controllers[i],
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _controllers[i],
                                curve: Curves.easeOut,
                              ),
                            ),
                            child: QuizCardUpdated(
                              category: quizCategories[i],
                              questionsAnswered: categoryProgress[
                                      quizCategories[i]['id']] ??
                                  0,
                              onRefresh: _loadData,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Updated quiz categories (replacing old hardcoded data)
final List<Map<String, dynamic>> quizCategories = [
  {
    'id': 'Java',
    'title': 'Java Programming',
    'description': 'Master Java fundamentals',
    'icon': Icons.code_rounded,
    'gradientColors': [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  },
  {
    'id': 'Dart',
    'title': 'Dart Language',
    'description': 'Learn Dart essentials',
    'icon': Icons.flutter_dash_rounded,
    'gradientColors': [Color(0xFF06B6D4), Color(0xFF3B82F6)],
  },
  {
    'id': 'Python',
    'title': 'Python Basics',
    'description': 'Explore Python programming',
    'icon': Icons.terminal_rounded,
    'gradientColors': [Color(0xFF10B981), Color(0xFF34D399)],
  },
];