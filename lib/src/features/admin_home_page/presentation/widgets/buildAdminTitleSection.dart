// FILE: lib/src/features/admin_home_page/presentation/widgets/buildAdminTitleSection.dart

import 'package:flutter/widgets.dart';

Widget buildAdminTitleSection() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final size = MediaQuery.of(context).size;
      final isTablet = size.width >= 600;
      final isDesktop = size.width >= 1024;

      // Responsive padding
      final horizontalPadding = isDesktop ? 40.0 : (isTablet ? 32.0 : 24.0);

      // Responsive font sizes
      final titleFontSize = isDesktop ? 40.0 : (isTablet ? 36.0 : 28.0);
      final subtitleFontSize = isDesktop ? 20.0 : (isTablet ? 19.0 : 16.0);
      final spacing = isDesktop ? 16.0 : 12.0;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            Text(
              'Management System',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w300,
                color: Color(0xFF1F2937),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing),
            Text(
              'Center For Advance Studies',
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3B82F6),
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    },
  );
}
