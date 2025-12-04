import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class CourseCatalog extends StatelessWidget {
  const CourseCatalog({super.key});

  final List<Map<String, dynamic>> courses = const [
    {
      'title': 'Artificial Intelligence',
      'description': 'Master AI algorithms, neural networks, and machine learning to build intelligent systems.',
      'enrolling': true,
      'color': Color(0xFF6366F1),
    },
    {
      'title': 'Android App Development',
      'description': 'Build native Android apps with Kotlin and master the latest Android frameworks.',
      'enrolling': false,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'Flutter App Development',
      'description': 'Create stunning cross-platform apps with Flutter and Dart programming.',
      'enrolling': true,
      'color': Color(0xFF3B82F6),
    },
    {
      'title': 'Game Development',
      'description': 'Design and build immersive games with modern engines and best practices.',
      'enrolling': true,
      'color': Color(0xFFEC4899),
    },
    {
      'title': 'Robotics',
      'description': 'Explore robotics systems, automation, and intelligent machine control.',
      'enrolling': false,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'Go Language',
      'description': 'Master Google\'s Go language for high-performance backend applications.',
      'enrolling': true,
      'color': Color(0xFF06B6D4),
    },
    {
      'title': 'Web Development',
      'description': 'Build modern, responsive web applications with HTML, CSS, and JavaScript.',
      'enrolling': true,
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'Blockchain',
      'description': 'Dive into decentralized technology, smart contracts, and cryptocurrency.',
      'enrolling': true,
      'color': Color(0xFFF97316),
    },
    {
      'title': 'UI/UX Design',
      'description': 'Craft beautiful, intuitive user experiences with modern design principles.',
      'enrolling': true,
      'color': Color(0xFFEF4444),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final isDesktop = size.width >= 1024;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(duration: 4000.ms, begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
          ),
          
          Positioned(
            top: size.height * 0.3,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFEC4899).withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(duration: 3500.ms, begin: const Offset(1, 1), end: const Offset(1.15, 1.15)),
          ),
          
          Positioned(
            bottom: 100,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8B5CF6).withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(duration: 3800.ms, begin: const Offset(1, 1), end: const Offset(1.18, 1.18)),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Header Section
                _buildHeader(context, size, isTablet, isDesktop),
                
                SizedBox(height: size.height * 0.02),
                
                // Courses Section
                Expanded(
                  child: _buildCoursesSection(context, size, isTablet, isDesktop),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size size, bool isTablet, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * (isDesktop ? 0.05 : 0.05),
        vertical: size.height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: size.width * (isDesktop ? 0.045 : isTablet ? 0.08 : 0.11),
              height: size.width * (isDesktop ? 0.045 : isTablet ? 0.08 : 0.11),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: const Color(0xFF1F2937),
                size: size.width * (isDesktop ? 0.022 : isTablet ? 0.04 : 0.055),
              ),
            ),
          )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.8, 0.8)),
          
          SizedBox(height: size.height * 0.03),
          
          // Title
          Text(
            'Course Catalog',
            style: TextStyle(
              fontSize: size.width * (isDesktop ? 0.045 : isTablet ? 0.065 : 0.085),
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1F2937),
              letterSpacing: -1.5,
              height: 1.1,
            ),
          )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideX(begin: -0.1, end: 0),
          
          SizedBox(height: size.height * 0.015),
          
          // Quotation
          Container(
            padding: EdgeInsets.all(size.width * (isDesktop ? 0.02 : 0.04)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.08),
                  const Color(0xFFEC4899).withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(size.width * (isDesktop ? 0.012 : 0.025)),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.format_quote_rounded,
                    color: Colors.white,
                    size: size.width * (isDesktop ? 0.025 : isTablet ? 0.045 : 0.06),
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: Text(
                    'Education is the most powerful weapon which you can use to change the world.',
                    style: TextStyle(
                      fontSize: size.width * (isDesktop ? 0.016 : isTablet ? 0.032 : 0.038),
                      color: const Color(0xFF4B5563),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          )
            .animate()
            .fadeIn(delay: 400.ms, duration: 700.ms)
            .slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildCoursesSection(BuildContext context, Size size, bool isTablet, bool isDesktop) {
    if (isDesktop) {
      return _buildGridView(context, size);
    }
    return _buildCarousel(context, size, isTablet);
  }

  Widget _buildGridView(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: GridView.builder(
        padding: EdgeInsets.only(bottom: size.height * 0.02),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size.width >= 1400 ? 3 : 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ModernCourseCard(course: courses[index])
            .animate(delay: (index * 100).ms)
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.9, 0.9));
        },
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, Size size, bool isTablet) {
    return FlutterCarousel.builder(
      itemCount: courses.length,
      options: FlutterCarouselOptions(
        height: size.height * (isTablet ? 0.6 : 0.58),
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.easeInOutCubic,
        enlargeCenterPage: true,
        enlargeFactor: 0.22,
        viewportFraction: isTablet ? 0.75 : 0.88,
        showIndicator: true,
        slideIndicator: CircularSlideIndicator(
          slideIndicatorOptions: SlideIndicatorOptions(
            currentIndicatorColor: const Color(0xFF6366F1),
            indicatorBackgroundColor: const Color(0xFFE5E7EB),
            indicatorRadius: 5,
            itemSpacing: 16,
            padding: EdgeInsets.only(bottom: size.height * 0.02),
          ),
        ),
      ),
      itemBuilder: (context, index, realIdx) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.015,
            vertical: size.height * 0.01,
          ),
          child: ModernCourseCard(course: courses[index])
            .animate(delay: (600 + (index * 80)).ms)
            .fadeIn(duration: 700.ms)
            .scale(begin: const Offset(0.92, 0.92)),
        );
      },
    );
  }
}

class ModernCourseCard extends StatelessWidget {
  const ModernCourseCard({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final isDesktop = size.width >= 1024;
    
    final bool enrolling = course['enrolling'];
    final Color primaryColor = course['color'] ?? const Color(0xFF6366F1);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Top gradient accent
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            
            // Decorative circle
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primaryColor.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(size.width * (isDesktop ? 0.02 : 0.055)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: EdgeInsets.all(size.width * (isDesktop ? 0.012 : 0.032)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getCourseIcon(course['title']),
                      color: Colors.white,
                      size: size.width * (isDesktop ? 0.03 : isTablet ? 0.065 : 0.075),
                    ),
                  ),
                  
                  SizedBox(height: size.height * (isDesktop ? 0.025 : 0.03)),
                  
                  // Title
                  Text(
                    course['title'],
                    style: TextStyle(
                      color: const Color(0xFF1F2937),
                      fontSize: size.width * (isDesktop ? 0.022 : isTablet ? 0.048 : 0.055),
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: size.height * 0.015),
                  
                  // Description
                  Expanded(
                    child: Text(
                      course['description'],
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: size.width * (isDesktop ? 0.015 : isTablet ? 0.036 : 0.04),
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  SizedBox(height: size.height * 0.025),
                  
                  // Button
                  Container(
                    width: double.infinity,
                    height: size.height * (isDesktop ? 0.055 : 0.065),
                    decoration: BoxDecoration(
                      gradient: enrolling
                          ? LinearGradient(
                              colors: [primaryColor, primaryColor.withOpacity(0.85)],
                            )
                          : LinearGradient(
                              colors: [
                                const Color(0xFFE5E7EB),
                                const Color(0xFFD1D5DB),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: enrolling ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ] : [],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: enrolling ? () {} : null,
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                enrolling ? 'Enroll Now' : 'Coming Soon',
                                style: TextStyle(
                                  color: enrolling
                                      ? Colors.white
                                      : const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w800,
                                  fontSize: size.width * (isDesktop ? 0.016 : isTablet ? 0.038 : 0.042),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (enrolling) ...[
                                SizedBox(width: size.width * 0.02),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: size.width * (isDesktop ? 0.02 : isTablet ? 0.045 : 0.05),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCourseIcon(String title) {
    if (title.contains('AI') || title.contains('Artificial')) return Icons.psychology_rounded;
    if (title.contains('Android')) return Icons.android_rounded;
    if (title.contains('Flutter')) return Icons.flutter_dash_rounded;
    if (title.contains('Game')) return Icons.sports_esports_rounded;
    if (title.contains('Robot')) return Icons.smart_toy_rounded;
    if (title.contains('Go')) return Icons.code_rounded;
    if (title.contains('Web')) return Icons.web_rounded;
    if (title.contains('Blockchain')) return Icons.currency_bitcoin_rounded;
    if (title.contains('UI') || title.contains('UX')) return Icons.palette_rounded;
    return Icons.school_rounded;
  }
}