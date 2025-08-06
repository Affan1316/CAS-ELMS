import 'package:flutter/material.dart';

class WhyChooseUsPage extends StatelessWidget {
  const WhyChooseUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 700;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildReasonGrid(isSmallScreen),
              const SizedBox(height: 40),
              _buildCallToAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Why Choose CAS?",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E96C5),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Discover what sets Center for Advanced Solutions apart in the world of technology and innovation.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildReasonGrid(bool isSmallScreen) {
    final reasons = [
      _ReasonCard(
        icon: Icons.engineering,
        title: "Expert Team",
        description: "Work with top-tier developers, data scientists & AI engineers.",
      ),
      _ReasonCard(
        icon: Icons.lightbulb_outline,
        title: "Innovative Solutions",
        description: "Pioneering products using AI, ML, and data-driven tech.",
      ),
      _ReasonCard(
        icon: Icons.security,
        title: "Secure & Reliable",
        description: "We prioritize security, performance, and scalability.",
      ),
      _ReasonCard(
        icon: Icons.support_agent,
        title: "24/7 Support",
        description: "Dedicated support team for client success and reliability.",
      ),
      _ReasonCard(
        icon: Icons.extension,
        title: "Custom Development",
        description: "Tailored solutions to match your unique business needs.",
      ),
      _ReasonCard(
        icon: Icons.devices,
        title: "Cross-Platform",
        description: "We build for web, mobile, desktop, and wearables.",
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: reasons
          .map((card) => SizedBox(
                width: isSmallScreen ? double.infinity : 220,
                child: card,
              ))
          .toList(),
    );
  }

  Widget _buildCallToAction() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0E96C5),
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      child: Column(
        children: const [
          Text(
            "Ready to build something great?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Partner with CAS today to unlock the power of intelligent technology.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ReasonCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFA3B1C6),
            offset: Offset(5, 5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Color(0xFF0E96C5)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}
