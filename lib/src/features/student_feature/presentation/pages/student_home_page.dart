import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/widgets/buildHeader.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/widgets/buildPopularTeachersSection.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/widgets/buildQuickActions.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/widgets/buildRecentActivities.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/widgets/buildStatsCard.dart';

class StudentHomePage extends StatefulWidget {
  final String id;
  final StudentEntityClass studentEntityClass;
  const StudentHomePage({
    super.key,
    required this.id,
    required this.studentEntityClass,
  });

  @override
  State<StudentHomePage> createState() {
    // if (studentEntityClass == null) {
    //   //   AssertionError("student is null");
    //   throw AssertionError('student is null');
    // }
    return _StudentHomePageState();
  }
}

class _StudentHomePageState extends State<StudentHomePage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> subjects = [
    {
      'title': 'Mathematics',
      'icon': Icons.calculate_rounded,
      'gradient': [const Color(0xFF667eea), const Color(0xFF764ba2)],
      'isSelected': true,
      'courses': 24,
      'progress': 0.75,
    },
    {
      'title': 'Physics',
      'icon': Icons.science_rounded,
      'gradient': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      'isSelected': false,
      'courses': 18,
      'progress': 0.60,
    },
    {
      'title': 'Chemistry',
      'icon': Icons.biotech_rounded,
      'gradient': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      'isSelected': false,
      'courses': 22,
      'progress': 0.45,
    },
    {
      'title': 'Biology',
      'icon': Icons.eco_rounded,
      'gradient': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      'isSelected': false,
      'courses': 20,
      'progress': 0.80,
    },
    {
      'title': 'Computer Science',
      'icon': Icons.computer_rounded,
      'gradient': [const Color(0xFF667eea), const Color(0xFF764ba2)],
      'isSelected': false,
      'courses': 32,
      'progress': 0.55,
    },
    {
      'title': 'English',
      'icon': Icons.book_rounded,
      'gradient': [const Color(0xFFfa709a), const Color(0xFFfee140)],
      'isSelected': false,
      'courses': 16,
      'progress': 0.70,
    },
    {
      'title': 'History',
      'icon': Icons.history_edu_rounded,
      'gradient': [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
      'isSelected': false,
      'courses': 14,
      'progress': 0.65,
    },
    {
      'title': 'Art & Design',
      'icon': Icons.palette_rounded,
      'gradient': [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
      'isSelected': false,
      'courses': 12,
      'progress': 0.40,
    },
  ];

  @override
  void initState() {
    super.initState();
    debugPrint("${widget.studentEntityClass.name}");
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build get callled");

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(
                      widget.studentEntityClass.name,
                      context,
                      widget.id,
                    ),
                    // buildStatsCard(),
                    buildQuickActions(widget.id),
                    buildPopularTeachersSection(),

                    // buildRecentActivities(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
