import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'alumni_showcase_page.dart'; // import your destination page

class YearSelectorPage extends StatelessWidget {
  const YearSelectorPage({super.key});

  final List<String> years = const [
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              "🎓 Select Year",
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Browse alumni by graduation year",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 140,
                perspective: 0.003,
                diameterRatio: 1.1,
                physics: const FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (ctx, i) {
                    final year = years[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => AlumniShowcasePage(selectedYear: year),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'year-$year',
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 40,
                          ),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFFEFF1F5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4, -4),
                                blurRadius: 10,
                              ),
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(4, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            year,
                            style: GoogleFonts.orbitron(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: years.length,
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
