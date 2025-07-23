import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cas_app_main/src/features/alumni_page/presentation/widgets/neumorphic_card.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:project_cas/main.dart';
// import 'package:project_cas/courses_detail_page/presentation/widgets/neumorphic_card.dart';

class AlumniShowcasePage extends StatelessWidget {
  final String selectedYear;
  const AlumniShowcasePage({super.key, required this.selectedYear});

  final List<Map<String, String>> alumni = const [
    {
      'name': 'Ayaan Khan',
      'year': '2020',
      'role': 'AI Engineer',
      'company': 'Google',
      'linkedin': 'https://linkedin.com/in/ayaan-khan',
      'github': 'https://github.com/ayaankhan',
    },
    {
      'name': 'Meher Fatima',
      'year': '2019',
      'role': 'UI/UX Designer',
      'company': 'Adobe',
      'linkedin': 'https://linkedin.com/in/meher-fatima',
    },
    {
      'name': 'Zeeshan Ali',
      'year': '2021',
      'role': 'Data Scientist',
      'company': 'Microsoft',
      'github': 'https://github.com/zeeshanali',
    },
    {
      'name': 'Fatima Noor',
      'year': '2022',
      'role': 'Cloud Architect',
      'company': 'AWS',
      'linkedin': 'https://linkedin.com/in/fatimanoor',
    },
    {
      'name': 'Ahmed Raza',
      'year': '2020',
      'role': 'DevOps Engineer',
      'company': 'Netflix',
      'github': 'https://github.com/ahmedraza',
    },
    {
      'name': 'Sarah Malik',
      'year': '2023',
      'role': 'Product Manager',
      'company': 'Spotify',
      'linkedin': 'https://linkedin.com/in/sarahmalik',
    },
    {
      'name': 'Tariq Hamid',
      'year': '2018',
      'role': 'ML Researcher',
      'company': 'OpenAI',
      'github': 'https://github.com/tariqhamid',
    },
    {
      'name': 'Hina Qureshi',
      'year': '2019',
      'role': 'Software Engineer',
      'company': 'Meta',
      'linkedin': 'https://linkedin.com/in/hinaqureshi',
    },
    {
      'name': 'Bilal Shah',
      'year': '2021',
      'role': 'QA Lead',
      'company': 'Tesla',
      'github': 'https://github.com/bilalshah',
    },
    {
      'name': 'Nida Jamil',
      'year': '2020',
      'role': 'Mobile Dev',
      'company': 'Samsung',
    },
    {
      'name': 'Fahad Aziz',
      'year': '2022',
      'role': 'Systems Engineer',
      'company': 'IBM',
    },
    {
      'name': 'Sadia Rehman',
      'year': '2023',
      'role': 'Security Analyst',
      'company': 'Cisco',
      'linkedin': 'https://linkedin.com/in/sadiarehman',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAlumni =
        alumni.where((alum) => alum['year'] == selectedYear).toList();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              Hero(
                tag: 'year-$selectedYear',
                child: Text(
                  "Class of $selectedYear",
                  style: GoogleFonts.orbitron(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              itemCount: filteredAlumni.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 30,
                childAspectRatio: 0.5,
              ),
              itemBuilder: (context, index) {
                final alum = filteredAlumni[index];
                final offset = index.isEven ? -5.0 : 5.0;
                return Animate(
                  effects: const [FadeEffect(), ScaleEffect()],
                  delay: Duration(milliseconds: index * 120),
                  child: Transform.translate(
                    offset: Offset(0, offset),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NeumorphicCard(alum: alum),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
