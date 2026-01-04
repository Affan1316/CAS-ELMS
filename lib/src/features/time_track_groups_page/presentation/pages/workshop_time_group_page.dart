import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../student_workshop_time_tracker/data/app_color.dart';
import '../bloc/group_time_tracker_bloc.dart';
import '../widgets/android_custom_paint.dart';
import '../widgets/animated_text.dart';
import '../widgets/group_container.dart';
import '../widgets/header_background.dart';
import '../widgets/lifted_carousel.dart';

class GroupWorkshopTimePage extends StatefulWidget {
  final String? studentName; // Add student name parameter
  const GroupWorkshopTimePage({super.key, this.studentName});

  @override
  State<GroupWorkshopTimePage> createState() => _GroupWorkshopTimePageState();
}

class _GroupWorkshopTimePageState extends State<GroupWorkshopTimePage> {
  int? selectedCourse;
  late List<Widget> courseCards;

  @override
  void initState() {
    super.initState();
    courseCards = [
      CourseCard(
        courseName: CourseNames.ai,
        imgPath: "assets/images/ai_logo.png",
        index: 0,
        selectedIndex: selectedCourse,
        onPressed: () {
          context.read<GroupTimeTrackerBloc>().add(
            SelectCourseEvent(CourseNames.ai),
          );
          if (selectedCourse == 0) {
            selectedCourse = null;
          } else {
            selectedCourse = 0;
          }
        },
      ),
      CourseCard(
        courseName: CourseNames.android,
        index: 1,
        selectedIndex: selectedCourse,
        onPressed: () {
          context.read<GroupTimeTrackerBloc>().add(
            SelectCourseEvent(CourseNames.android),
          );
          if (selectedCourse == 1) {
            selectedCourse = null;
          } else {
            selectedCourse = 1;
          }
        },
        child: AndroidLogo(),
      ),
      CourseCard(
        courseName: CourseNames.flutter,
        index: 2,
        selectedIndex: selectedCourse,
        onPressed: () {
          context.read<GroupTimeTrackerBloc>().add(
            SelectCourseEvent(CourseNames.flutter),
          );
          if (selectedCourse == 2) {
            selectedCourse = null;
          } else {
            selectedCourse = 2;
          }
        },
        child: FlutterLogo(size: 48),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final isTablet = screenWidth >= 768;
    
    final horizontalPadding = screenWidth * (isTablet ? 0.042 : 0.06);
    final titleFontSize = size.width * 0.07;
    final iconSize = size.width * 0.065;
    final backButtonPadding = size.width * 0.04;
    
    var bgSize = context.height * 0.24;
    var courseBoxCarouselSize = context.height * 0.35;
    var expandedSize = context.height * 0.46;
    
    return NeumorphicTheme(
      theme: const NeumorphicThemeData(
        baseColor: AppColors.background,
        lightSource: LightSource.topLeft,
        depth: 8,
        intensity: 0.6,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Fixed Neumorphic Header
            Container(
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  children: [
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
                          color: Colors.white,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                            left: horizontalPadding * 0.4,
                            right: horizontalPadding * 1.2,
                            top: size.height * 0.025,
                            bottom: size.height * 0.025,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size.width * 0.06),
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FadeInDown(
                                delay: const Duration(milliseconds: 300),
                                child: NeumorphicButton(
                                  onPressed: () => Navigator.of(context).maybePop(),
                                  style: NeumorphicStyle(
                                    boxShape: const NeumorphicBoxShape.circle(),
                                    depth: 6,
                                    intensity: 0.8,
                                    shape: NeumorphicShape.flat,
                                    color: Colors.white,
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
                                              gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xFF6A11CB),
                                                  Color(0xFF2575FC),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(size.width * 0.01),
                                            ),
                                          ),
                                          SizedBox(width: size.width * 0.025),
                                          Text(
                                            'Track Your',
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
                                          'Workshop Time',
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
                                    if (widget.studentName != null) ...[
                                      SizedBox(height: size.height * 0.008),
                                      FadeInDown(
                                        delay: const Duration(milliseconds: 600),
                                        child: Text(
                                          'Student: ${widget.studentName}',
                                          style: TextStyle(
                                            fontSize: titleFontSize * 0.45,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                  ],
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: AppColors.background,
                    expandedHeight: expandedSize,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: HeaderBackground(height: bgSize),
                          ),
                          Positioned(
                            top: bgSize * 0.55,
                            child: SizedBox(
                              height: courseBoxCarouselSize,
                              width: context.width,
                              child: LiftedCarousel(
                                items: courseCards,
                                lift: courseBoxCarouselSize * 0.2,
                                drop: 28,
                                minScale: 0.94,
                                viewportFraction: 1 / 3,
                                padEnds: true,
                                elevation: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  BlocBuilder<GroupTimeTrackerBloc, GroupTimeTrackerState>(
                    bloc: context.read<GroupTimeTrackerBloc>(),
                    builder: (context, state) {
                      if (state is GroupTimeTrackerInitial) {
                        return SliverToBoxAdapter(
                          child: Center(child: MyAnimatedText()),
                        );
                      } else if (state is GroupTimeTrackerLoading) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 48,
                                width: 48,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        );
                      } else if (state is GroupLoaded) {
                        return getGridView(
                          groupNames: state.groupNames,
                          courseName: state.courseName,
                        );
                      } else if (state is GroupTimeTrackerError) {
                        return SliverToBoxAdapter(
                          child: MyAnimatedText(
                            color: Colors.red,
                            text: state.error ?? "Something went wrong",
                          ),
                        );
                      } else {
                        return SliverToBoxAdapter(
                          child: MyAnimatedText(
                            color: Colors.red,
                            text: "Something went wrong",
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getGridView({
  required List<String> groupNames,
  required String courseName,
}) {
  return SliverPadding(
    padding: const EdgeInsets.all(12),
    sliver: SliverAnimatedGrid(
      initialItemCount: groupNames.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 26,
        crossAxisSpacing: 16,
        mainAxisExtent: 180,
      ),
      itemBuilder: (context, index, animation) {
        return ScaleTransition(
          scale: animation.drive(
            Tween<double>(
              begin: 0.85,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeOutBack)),
          ),
          child: GroupsContainer(
            groupName: groupNames[index],
            courseName: courseName,
          ),
        );
      },
    ),
  );
}