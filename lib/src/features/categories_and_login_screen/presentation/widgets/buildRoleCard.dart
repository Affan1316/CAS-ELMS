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
  // Define the background color for neumorphic effect
  final backgroundColor =
      Colors.grey.shade200; // You can customize this base color

  return GestureDetector(
    onTap: () {
      context.read<OnboardingBloc>().add(SelectRoleEvent(role));
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 160,
      height: 220,
      decoration: BoxDecoration(
        color: backgroundColor, // Always keep neutral for neumorphic effect
        borderRadius: BorderRadius.circular(16),
        boxShadow:
            isSelected
                ? [
                  // Inset effect for selected state (pressed in)
                  // Dark shadow on top-left to simulate depth
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(-3, -3),
                    blurRadius: 8,
                    spreadRadius: -2,
                  ),
                  // Light shadow on bottom-right to enhance inset look
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(3, 3),
                    blurRadius: 8,
                    spreadRadius: -2,
                  ),
                ]
                : [
                  // Raised effect for unselected state (protruding out)
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
        // Inner content
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar container with neumorphic effect
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow:
                    isSelected
                        ? [
                          // Inset avatar effect when selected
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
                          // Raised avatar when not selected
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
                child: avatar,
              ),
            ),
            const SizedBox(height: 16),

            // Role text
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.black87,
              ),
              child: Text(role),
            ),
          ],
        ),
      ),
    ),
  );
}
