import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/time_graph_page/data/app_color.dart';
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/bloc/group_time_tracker_bloc.dart';
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/widgets/android_custom_paint.dart';
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/widgets/animated_text.dart';
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/widgets/group_container.dart';
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/widgets/header_background.dart';
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/widgets/header_text.dart';
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/widgets/lifted_carousel.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

import '../../../../core/theme/app_colors.dart';


class WorkshopTimeTracker extends StatefulWidget {
  const WorkshopTimeTracker({super.key});

  @override
  State<WorkshopTimeTracker> createState() => _WorkshopTimeTrackerState();
}

class _WorkshopTimeTrackerState extends State<WorkshopTimeTracker> {
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
    var bgSize = context.height * 0.24;
    var courseBoxCarouselSize = context.height * 0.35;
    var expandedSize = context.height * 0.46;
    return NeumorphicTheme(
      theme: const NeumorphicThemeData(
        baseColor: AppColors.background,
        lightSource: LightSource.topLeft,
        depth: 8, // how deep shadows look
        intensity: 0.6, // shadow brightness
      ),
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              centerTitle: true,
              title: HeaderText(text: "Workshop Time Tracker"),
              toolbarHeight: context.height * 0.1,
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
                      // alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: courseBoxCarouselSize,
                        width: context.width,
                        child: LiftedCarousel(
                          items: courseCards,
                          lift:
                              courseBoxCarouselSize *
                              0.2, // how much neighbors go UP
                          drop: 28, // how much center goes DOWN
                          minScale: 0.94,
                          viewportFraction: 1 / 3, // exactly 3 visible
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
                      text: "Something went wrong",
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
