import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/course_graph_screen/presentation/widgets/CourseDurationPainter.dart';
import 'package:flutter_cas_app_main/src/features/course_graph_screen/presentation/widgets/StudentPerformancePainter.dart';

class ELMSGraphsPage extends StatefulWidget {
  @override
  _ELMSGraphsPageState createState() => _ELMSGraphsPageState();
}

class _ELMSGraphsPageState extends State<ELMSGraphsPage>
    with TickerProviderStateMixin {
  late AnimationController _performanceController;
  late AnimationController _durationController;
  late Animation<double> _performanceAnimation;
  late Animation<double> _durationAnimation;

  // Sample data for student performance (grades over months)
  final List<double> performanceData = [75, 68, 82, 78, 85, 92, 88, 94, 89, 96];
  final List<String> performanceLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
  ];

  final List<double> durationData = [15, 22, 18, 28, 25, 30, 26, 32, 29, 35];
  final List<String> durationLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
  ];

  @override
  void initState() {
    super.initState();

    // Performance graph animation
    _performanceController = AnimationController(
      duration: Duration(milliseconds: 6000),
      vsync: this,
    );
    _performanceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _performanceController,
        curve: Curves.easeInOutQuart,
      ),
    );

    // Duration graph animation
    _durationController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );
    _durationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _durationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Start animations with longer delays
    Future.delayed(Duration(milliseconds: 500), () {
      _performanceController.forward();
    });

    Future.delayed(Duration(milliseconds: 1200), () {
      _durationController.forward();
    });
  }

  @override
  void dispose() {
    _performanceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0A0E27),
        appBar: AppBar(
          title: Text(
            'ELMS Analytics',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFF1A1F3A),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Student Performance Section
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Performance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Monthly grade progression',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1E2A5A).withOpacity(0.8),
                            Color(0xFF2D1B69).withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _performanceAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: StudentPerformancePainter(
                              data: performanceData,
                              labels: performanceLabels,
                              animationValue: _performanceAnimation.value,
                            ),
                            child: Container(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Course Duration Section
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Time Duration',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Weekly study hours tracking',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF1A1A2E),
                            Color(0xFF16213E),
                            Color(0xFF0F3460),
                          ],
                        ),
                        border: Border.all(
                          color: Color(0xFFE94560).withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFE94560).withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _durationAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: CourseDurationPainter(
                              data: durationData,
                              labels: durationLabels,
                              animationValue: _durationAnimation.value,
                            ),
                            child: Container(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
