// FILE: lib/src/features/admin_home_page/presentation/widgets/buildAdminHeader.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildAdminHeader() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final size = MediaQuery.of(context).size;
      final isTablet = size.width >= 600;
      final isDesktop = size.width >= 1024;

      // Responsive padding
      final horizontalPadding = isDesktop ? 40.0 : (isTablet ? 32.0 : 24.0);
      final verticalPadding = isDesktop ? 32.0 : 24.0;

      // Responsive sizing
      final buttonPadding = isDesktop ? 18.0 : (isTablet ? 14.0 : 12.0);
      final iconSize = isDesktop ? 22.0 : (isTablet ? 20.0 : 18.0);
      final fontSize = isDesktop ? 16.0 : 15.0;

      return Container(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          verticalPadding,
          horizontalPadding,
          16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 20 : 16,
                  vertical: isDesktop ? 12 : 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE5E5E5), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.04),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      color: Color(0xFF6B7280),
                      size: iconSize,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding: EdgeInsets.all(buttonPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE5E5E5), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.04),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF6B7280),
                      size: iconSize,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
