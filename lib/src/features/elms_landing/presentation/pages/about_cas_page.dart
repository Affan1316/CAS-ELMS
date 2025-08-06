import 'package:flutter/material.dart';

class AboutCasPage extends StatelessWidget {
  const AboutCasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 700;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('About Cas'),),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeroSection(isSmallScreen),
              const SizedBox(height: 30),
              _buildCompanyDescription(),
              const SizedBox(height: 30),
              _buildProductFeatures(isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0E96C5),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child:   _heroText(),
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Center for Advanced Solutions",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Building the future with AI, ML & Intelligent Software",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Who We Are",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E96C5),
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Center for Advanced Solutions (CAS) is a forward-thinking software development company. "
          "We specialize in crafting intelligent products powered by AI, Machine Learning, and Data Science. "
          "Our team is passionate about transforming complex challenges into user-friendly, scalable digital solutions.",
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProductFeatures(bool isSmallScreen) {
    final items = [
      _FeatureCard(icon: Icons.language, title: "Web Development"),
      _FeatureCard(icon: Icons.phone_android, title: "Android Apps"),
      _FeatureCard(icon: Icons.phone_iphone, title: "iOS Development"),
      _FeatureCard(icon: Icons.watch, title: "Wear OS Apps"),
      _FeatureCard(icon: Icons.memory, title: "AI & ML Products"),
      _FeatureCard(icon: Icons.bar_chart, title: "Data Science Solutions"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What We Build",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E96C5),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items
              .map((card) => SizedBox(
                    width: isSmallScreen ? double.infinity : 200,
                    child: card,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureCard({required this.icon, required this.title});

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
            offset: Offset(6, 6),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 12,
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
