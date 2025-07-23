import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/widgets/build_header_course_page.dart';
import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/widgets/build_search_bar_courses_page.dart';
import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/widgets/build_welcome_course_page.dart';
import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/widgets/bulid_course_card.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CourseCatalog extends StatelessWidget {
  const CourseCatalog({super.key});

  final List<Map<String, dynamic>> courses = const [
    {
      'title': 'Artificial Intelligence',
      'description': 'Learn how machines think and make decisions.',
      'enrolling': true,
      'enrollments': 215,
    },
    {
      'title': 'Android App Development',
      'description': 'Build native Android apps with Kotlin.',
      'enrolling': false,
      'enrollments': 144,
    },
    {
      'title': 'Flutter App Development',
      'description': 'Create cross-platform apps with Flutter.',
      'enrolling': true,
      'enrollments': 312,
    },
    {
      'title': 'Game Development',
      'description': 'Design and build interactive games.',
      'enrolling': true,
      'enrollments': 198,
    },
    {
      'title': 'Robotics',
      'description': 'Explore robotics systems and automation.',
      'enrolling': false,
      'enrollments': 103,
    },
    {
      'title': 'Go Language',
      'description': 'Master Google’s Go for high-performance apps.',
      'enrolling': true,
      'enrollments': 78,
    },
    {
      'title': 'Web Development',
      'description': 'Build modern web apps with HTML, CSS, JS.',
      'enrolling': true,
      'enrollments': 391,
    },
    {
      'title': 'Blockchain',
      'description': 'Dive into decentralized tech and smart contracts.',
      'enrolling': true,
      'enrollments': 129,
    },
    {
      'title': 'UI/UX Design',
      'description': 'Craft intuitive user experiences.',
      'enrolling': true,
      'enrollments': 240,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EBF9),
      body: SafeArea(
        child: Column(
          children: [
            BuildHeaderCoursePage(),
            BuildWelcomeCoursePage(),
            BuildSearchBarCoursesPage(),
            Expanded(
              child: FlutterCarousel.builder(
                itemCount: courses.length,
                options: FlutterCarouselOptions(
                  height: 340,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.75,
                  showIndicator: true,
                  slideIndicator: CircularSlideIndicator(
                    slideIndicatorOptions: SlideIndicatorOptions(
                      currentIndicatorColor: Colors.deepPurple,
                      indicatorBackgroundColor: Colors.grey.shade300,
                      indicatorRadius: 5,
                    ),
                  ),
                ),
                itemBuilder: (context, index, realIdx) {
                  final course = courses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: BulidCourseCard(
                      course: course,
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
