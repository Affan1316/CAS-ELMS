// Entry Widget

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/course_catalog/presentation/widgets/course_card.dart';
import 'package:flutter_cas_app_main/src/features/course_catalog/presentation/widgets/course_data.dart';
import 'package:flutter_cas_app_main/src/features/course_catalog/presentation/widgets/promo_banner.dart';

class CourseCatalogScreen extends StatefulWidget {
  const CourseCatalogScreen({super.key});

  @override
  State<CourseCatalogScreen> createState() => CourseCatalogScreenState();
}

class CourseCatalogScreenState extends State<CourseCatalogScreen> {
  final Set<String> _selectedCourses = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.bgColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Hello!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome to the Center for Advanced Solutions.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              _buildSearchField(),
              const SizedBox(height: 24),
              const PromoBanner(),
              const SizedBox(height: 28),
              const Text(
                'Available Courses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double maxWidth = constraints.maxWidth;
                  final double itemWidth = (maxWidth - 36) / 2;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        CourseData.courseTitles
                            .map(
                              (title) => CourseCard(
                                title: title,
                                width: itemWidth,
                                isSelected: _selectedCourses.contains(title),
                                onTap: () {
                                  setState(() {
                                    if (_selectedCourses.contains(title)) {
                                      _selectedCourses.remove(title);
                                    } else {
                                      _selectedCourses.add(title);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.bgColor,
      title: const Text(
        'Course Catalog',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      leading: const Icon(Icons.arrow_back, color: Colors.black),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.notifications_none, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for a course...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppColors.searchFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
