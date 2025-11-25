import 'package:flutter_cas_app_main/src/features/student_assignment_page/presentation/model/assignment_model.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:animate_do/animate_do.dart';

class AssignmentDetailPage extends StatelessWidget {
  final String assignmentId;

  const AssignmentDetailPage({
    super.key,
    required this.assignmentId,
  });

  @override
  Widget build(BuildContext context) {
    // Get the assignment data
    final assignment = AssignmentsData.getAssignmentById(assignmentId);

    // Handle case where assignment is not found
    if (assignment == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFE2E2E2),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.black38,
              ),
              SizedBox(height: 16),
              Text(
                'Assignment not found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;
    final titleFontSize = size.width * 0.08;
    final subtitleFontSize = size.width * 0.032;
    final contentFontSize = size.width * 0.038;
    final buttonFontSize = size.width * 0.045;
    final backButtonSize = size.width * 0.042;

    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  size.height * 0.02,
                  horizontalPadding,
                  size.height * 0.01,
                ),
                child: Row(
                  children: [
                    // Neumorphic Back Button
                    NeumorphicButton(
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                      style: const NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.circle(),
                        depth: 8,
                        intensity: 0.8,
                      ),
                      padding: EdgeInsets.all(size.width * 0.04),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: backButtonSize,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: size.width * 0.05),
                    // Title Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment.title,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: size.height * 0.003),
                          Wrap(
                            spacing: size.width * 0.02,
                            runSpacing: size.height * 0.008,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.025,
                                  vertical: size.height * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black87.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.03,
                                  ),
                                ),
                                child: Text(
                                  assignment.questionCount,
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.025,
                                  vertical: size.height * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black87.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.03,
                                  ),
                                ),
                                child: Text(
                                  assignment.difficulty,
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.025,
                                  vertical: size.height * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black87.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.03,
                                  ),
                                ),
                                child: Text(
                                  assignment.subject,
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
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

          // Content Section with Enhanced Design
          Expanded(
            child: FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 200),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: size.height * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Content Card with Neumorphic Design
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: -6,
                        intensity: 0.85,
                        surfaceIntensity: 0.4,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(size.width * 0.06),
                        ),
                        color: const Color(0xFFE2E2E2),
                        lightSource: LightSource.topLeft,
                        shape: NeumorphicShape.concave,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section Header
                            Row(
                              children: [
                                Container(
                                  width: size.width * 0.01,
                                  height: size.height * 0.03,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(
                                      size.width * 0.005,
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Text(
                                  "Assignment Overview",
                                  style: TextStyle(
                                    fontSize: buttonFontSize,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.025),

                            // All Questions List
                            ...List.generate(assignment.questions.length, (index) {
                              return _buildQuestionItem(
                                context,
                                "${index + 1}",
                                assignment.questions[index],
                                contentFontSize,
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(
    BuildContext context,
    String number,
    String question,
    double fontSize,
  ) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Number Badge
          Container(
            width: size.width * 0.08,
            height: size.width * 0.08,
            decoration: BoxDecoration(
              color: Colors.black87.withOpacity(0.08),
              borderRadius: BorderRadius.circular(size.width * 0.025),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: fontSize * 0.93,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.035),
          // Question Text
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.005),
              child: Text(
                question,
                style: TextStyle(
                  fontSize: fontSize,
                  height: 1.5,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}