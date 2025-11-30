import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/time_graph_page/data/app_color.dart'
    hide AppColors;
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/widgets/android_custom_paint.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

class GroupsContainer extends StatelessWidget {
  const GroupsContainer({
    super.key,
    required this.groupName,
    required this.courseName,
  });
  final String groupName;
  final String courseName;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        color: AppColors.bgColor,
        depth: 6,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: Container(
        // margin: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 12),
            FittedBox(
              child: SizedBox(
                height: 120,
                width: 120,
                child: Image.asset("assets/images/group_illustration.png"),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: FittedBox(
                child: Row(
                  children: [
                    _getIcons(courseName),
                    SizedBox(width: 6),
                    Text(
                      groupName,
                      style: TextStyle(
                        fontSize: TextSizes.titleMedium,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

Widget _getIcons(String name) {
  return switch (name) {
    CourseNames.ai => SizedBox(
      width: 24,
      height: 24,
      child: Image.asset("assets/images/ai_logo.png"),
    ),
    CourseNames.android => AndroidLogo(size: 24),
    CourseNames.flutter => FlutterLogo(size: 24),
    _ => throw UnimplementedError(),
  };
}
