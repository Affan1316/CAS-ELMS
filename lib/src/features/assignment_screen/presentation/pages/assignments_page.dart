import 'package:flutter_cas_app_main/src/features/assignment_screen/presentation/widgets/cards.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:animate_do/animate_do.dart';

class InterviewStagesPage extends StatelessWidget {
  const InterviewStagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    child: NeumorphicButton(
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                      style: const NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.circle(),
                        depth: 8,
                        intensity: 0.8,
                        shape: NeumorphicShape.flat,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Icon(Icons.arrow_back_ios_new, size: 26),
                    ),
                  ),
                  const SizedBox(width: 40),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Assignments',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: -4,
                  intensity: 0.8,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(30),
                  ),
                  color: const Color(0xFFE2E2E2),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black54,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ...List.generate(3, (index) {
              final details = ['30 Questions', '20 Questions', '25 Questions'];
              final titles = ['If-Else', 'Loops', 'Switch Statements'];
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 24),
                child: FadeInUp(
                  duration: Duration(milliseconds: 500 + (index * 120)),
                  child: StageCard(
                    title: titles[index],
                    extraDetail: details[index],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
