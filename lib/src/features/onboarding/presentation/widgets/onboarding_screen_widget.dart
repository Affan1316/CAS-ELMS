import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/pages/OnboardingPageModel.dart';


class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageModel page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            page.imagePath,
            height: screenHeight * 0.35,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              page.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              page.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
