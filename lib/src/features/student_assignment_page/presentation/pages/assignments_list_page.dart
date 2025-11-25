import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/model/assignment_model.dart';
import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/widgets/assignment_cards.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:animate_do/animate_do.dart';

class AssignmentsListPage extends StatefulWidget {
  const AssignmentsListPage({super.key});

  @override
  State<AssignmentsListPage> createState() => _AssignmentsListPageState();
}

class _AssignmentsListPageState extends State<AssignmentsListPage> {
  String _searchQuery = '';
  
  List<Assignment> get _filteredAssignments {
    if (_searchQuery.isEmpty) {
      return AssignmentsData.allAssignments;
    }
    return AssignmentsData.allAssignments.where((assignment) {
      return assignment.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             assignment.subject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             assignment.difficulty.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;
    final titleFontSize = size.width * 0.07;
    final searchFontSize = size.width * 0.04;
    final iconSize = size.width * 0.065;
    final backButtonPadding = size.width * 0.04;

    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: [
            // Enhanced Header Section
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: horizontalPadding * 0.8,
                vertical: size.height * 0.02,
              ),
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 8,
                  intensity: 0.65,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(size.width * 0.06),
                  ),
                  color: const Color(0xFFE2E2E2),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding * 1.2,
                    vertical: size.height * 0.025,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width * 0.06),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFE2E2E2).withOpacity(0.9),
                        const Color(0xFFD5D5D5).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeInDown(
                        delay: const Duration(milliseconds: 300),
                        child: NeumorphicButton(
                          onPressed: () {
                            Navigator.of(context).maybePop();
                          },
                          style: NeumorphicStyle(
                            boxShape: const NeumorphicBoxShape.circle(),
                            depth: 6,
                            intensity: 0.8,
                            shape: NeumorphicShape.flat,
                            color: const Color(0xFFE2E2E2),
                          ),
                          padding: EdgeInsets.all(backButtonPadding),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: iconSize,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInDown(
                              delay: const Duration(milliseconds: 400),
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width * 0.01,
                                    height: titleFontSize * 0.65,
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(size.width * 0.01),
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.025),
                                  Text(
                                    'Explore',
                                    style: TextStyle(
                                      fontSize: titleFontSize * 0.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.008),
                            FadeInDown(
                              delay: const Duration(milliseconds: 500),
                              child: ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFF6A11CB),
                                    Color(0xFF2575FC),
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Assignments',
                                  style: TextStyle(
                                    fontSize: titleFontSize * 1.1,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.02),

            // Search Bar
            FadeInDown(
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: size.height * 0.01,
                ),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: -4,
                    intensity: 0.8,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(size.width * 0.075),
                    ),
                    color: const Color(0xFFE2E2E2),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: searchFontSize,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search assignments...',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: searchFontSize,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black54,
                          size: iconSize,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: size.height * 0.017,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.04),

            // Assignment Cards List - Using real data
            ..._filteredAssignments.asMap().entries.map((entry) {
              final index = entry.key;
              final assignment = entry.value;
              
              return Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding * 0.5,
                  right: horizontalPadding * 0.5,
                  bottom: size.height * 0.03,
                ),
                child: FadeInUp(
                  duration: Duration(milliseconds: 500 + (index * 120)),
                  child: AssignmentCard(
                    assignmentId: assignment.id,
                    title: assignment.title,
                    extraDetail: assignment.questionCount,
                    subject: assignment.subject,
                    difficulty: assignment.difficulty,
                  ),
                ),
              );
            }).toList(),

            // Bottom Padding
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }
}