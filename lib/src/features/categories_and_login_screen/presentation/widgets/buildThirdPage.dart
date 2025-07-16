import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';

Widget buildThirdPage(BuildContext context, OnboardingInitial state) {
  final interests = [
    {'name': 'Java', 'color': Colors.purple},
    {'name': 'Andriod', 'color': Colors.pink},
    {'name': 'Flutter', 'color': Colors.teal},
    {'name': 'BlockChain', 'color': Colors.red},
    {'name': 'Ai/ML/DL', 'color': Colors.indigo},
    {'name': 'Robotics', 'color': Colors.blue},
    {'name': 'web Dev', 'color': Colors.green},
    {'name': 'Game', 'color': Colors.grey},
  ];

  return Stack(
    children: [
      // Half screen background with rounded bottom corners
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 216, 240, 239),
              Color.fromARGB(255, 216, 240, 239),
            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),

      // Main content
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Title
            SlideInWidget(
              delay: const Duration(milliseconds: 200),
              begin: const Offset(0, -0.5),
              child: const Text(
                'What fascinates you?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Subtitle
            SlideInWidget(
              delay: const Duration(milliseconds: 400),
              begin: const Offset(0, -0.5),
              child: const Text(
                'To give you a personalized experience,\nlet us know your interests.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Interest chips
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 26,
                  mainAxisSpacing: 26,
                  childAspectRatio: 3,
                ),
                itemCount: interests.length,
                itemBuilder: (context, index) {
                  final interest = interests[index];
                  final isSelected = state.selectedInterests.contains(
                    interest['name'],
                  );

                  return SlideInWidget(
                    delay: Duration(milliseconds: 600 + (index * 100)),
                    begin: const Offset(0, 0.5),
                    child: GestureDetector(
                      onTap: () {
                        context.read<OnboardingBloc>().add(
                          SelectInterestEvent(interest['name'] as String),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? (interest['color'] as Color).withOpacity(
                                    0.1,
                                  )
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color:
                                isSelected
                                    ? (interest['color'] as Color)
                                    : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  isSelected
                                      ? (interest['color'] as Color)
                                          .withOpacity(0.2)
                                      : Colors.black.withOpacity(0.05),
                              blurRadius: isSelected ? 12 : 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: isSelected ? 10 : 8,
                              height: isSelected ? 10 : 8,
                              decoration: BoxDecoration(
                                color: interest['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? (interest['color'] as Color)
                                        : Colors.black87,
                              ),
                              child: Text(interest['name'] as String),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    ],
  );
}
