import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';

Widget buildRoleCard(
  BuildContext context,
  String role,
  Widget avatar,
  Color color,
  bool isSelected,
) {
  // Get screen dimensions for responsiveness
  final screenSize = MediaQuery.of(context).size;
  final screenWidth = screenSize.width;
  final screenHeight = screenSize.height;

  // Calculate responsive dimensions
  final cardWidth = screenWidth * 0.35; // 35% of screen width
  final cardHeight = screenHeight * 0.25; // 25% of screen height

  // Ensure minimum and maximum sizes
  final responsiveWidth = cardWidth.clamp(140.0, 180.0);
  final responsiveHeight = cardHeight.clamp(180.0, 240.0);

  // Calculate avatar size based on card size - Made bigger
  final avatarSize = (responsiveWidth * 0.45).clamp(50.0, 85.0);

  // Calculate font size based on screen
  final fontSize = (screenWidth * 0.04).clamp(14.0, 18.0);

  // Calculate spacing based on card height
  final spacing = (responsiveHeight * 0.08).clamp(12.0, 20.0);

  // Define the background color for neumorphic effect
  final backgroundColor = Colors.grey.shade200;

  return GestureDetector(
    onTap: () {
      context.read<OnboardingBloc>().add(SelectRoleEvent(role));
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: responsiveWidth,
      height: responsiveHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow:
            isSelected
                ? [
                  // Inset effect for selected state
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(-3, -3),
                    blurRadius: 8,
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(3, 3),
                    blurRadius: 8,
                    spreadRadius: -2,
                  ),
                ]
                : [
                  // Raised effect for unselected state
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(6, 6),
                    blurRadius: 12,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(-6, -6),
                    blurRadius: 12,
                  ),
                ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar container with responsive neumorphic effect
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(-2, -2),
                            blurRadius: 4,
                            spreadRadius: -1,
                          ),
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                            spreadRadius: -1,
                          ),
                        ]
                        : [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(3, 3),
                            blurRadius: 6,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(-3, -3),
                            blurRadius: 6,
                          ),
                        ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(isSelected ? 0.3 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: SizedBox(
                    width: avatarSize * 0.85, // Increased from 0.7 to 0.85
                    height: avatarSize * 0.85,
                    child: avatar,
                  ),
                ),
              ),
            ),

            SizedBox(height: spacing),

            // Role text with responsive font
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.black87,
              ),
              child: Text(
                role,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
