// FILE: lib/src/features/admin_home_page/presentation/widgets/buildAdminCarouselSlider.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_event.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_state.dart';

Widget buildAdminCarouselSlider(PageController _pageController) {
  final carouselItems = [
    {
      'title': 'Course Detail',
      'subtitle': 'Manage courses and curriculum',
      'description':
          'View and manage all course information, schedules, and student enrollment details',
      'icon': Icons.book_outlined,
      'color': Color(0xFF3B82F6),
      'bgColor': Color(0xFFF0F7FF),
    },
    {
      'title': 'Inquiry Detail',
      'subtitle': 'Student inquiries and support',
      'description':
          'Handle student inquiries, admissions, and provide support for all academic queries',
      'icon': Icons.help_outline,
      'color': Color(0xFF10B981),
      'bgColor': Color(0xFFF0FDF4),
    },
  ];

  return BlocBuilder<AdminHomeBloc, AdminHomeState>(
    builder: (context, state) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final size = MediaQuery.of(context).size;
          final isTablet = size.width >= 600;
          final isDesktop = size.width >= 1024;

          // Responsive dimensions
          final horizontalPadding = isDesktop ? 40.0 : (isTablet ? 32.0 : 24.0);
          final carouselHeight = isDesktop ? 220.0 : (isTablet ? 200.0 : 180.0);
          final spacing = isDesktop ? 20.0 : 16.0;

          return Column(
            children: [
              Container(
                height: carouselHeight,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    context.read<AdminHomeBloc>().add(PageChangedEvent(index));
                  },
                  itemCount: carouselItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        16,
                      ),
                      child: _buildCarouselCard(carouselItems[index]),
                    );
                  },
                ),
              ),
              SizedBox(height: spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  carouselItems.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width:
                        state.currentPage == index
                            ? (isDesktop ? 24 : 20)
                            : (isDesktop ? 10 : 8),
                    height: isDesktop ? 10 : 8,
                    decoration: BoxDecoration(
                      color:
                          state.currentPage == index
                              ? Color(0xFF3B82F6)
                              : Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildCarouselCard(Map<String, dynamic> item) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final size = MediaQuery.of(context).size;
      final isTablet = size.width >= 600;
      final isDesktop = size.width >= 1024;

      // Responsive sizing
      final padding = isDesktop ? 24.0 : (isTablet ? 22.0 : 20.0);
      final iconSize = isDesktop ? 40.0 : (isTablet ? 36.0 : 32.0);
      final iconPadding = isDesktop ? 18.0 : 16.0;
      final titleFontSize = isDesktop ? 22.0 : (isTablet ? 21.0 : 20.0);
      final subtitleFontSize = isDesktop ? 15.0 : 14.0;
      final descFontSize = isDesktop ? 13.0 : 12.0;
      final arrowSize = isDesktop ? 18.0 : 16.0;

      return GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          // Handle card tap
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFFF3F4F6), width: 1),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.06),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.04),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(iconPadding),
                  decoration: BoxDecoration(
                    color: item['bgColor'] as Color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (item['color'] as Color).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    size: iconSize,
                    color: item['color'] as Color,
                  ),
                ),
                SizedBox(width: isDesktop ? 20 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item['subtitle'] as String,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w500,
                          color: item['color'] as Color,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        item['description'] as String,
                        style: TextStyle(
                          fontSize: descFontSize,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: arrowSize,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
